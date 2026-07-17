import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'albums_grid_view.dart' show LibraryEmptyState;

// ---------------------------------------------------------------------------
// RemoteFavoritesView
// Vue favoris en mode remote : fusionne, dans 3 onglets (pistes/albums/
// artistes), les favoris locaux du profil + les favoris streaming Tune +
// les favoris de chaque service connecté. Utilise un modèle d'affichage léger
// (_FavItem) plutôt que les modèles Drift.
// ---------------------------------------------------------------------------

enum _FavKind { track, album, artist }

enum _FavOrigin { local, tune, service }

class _FavItem {
  final String title;
  final String? subtitle;
  final String? coverPath; // local cover path (via ArtworkView)
  final String? coverUrl; // remote cover URL (Image.network)
  final _FavOrigin origin;
  final int? localId; // for local items
  final String? service; // for streaming/service items
  final String? serviceId;

  _FavItem({
    required this.title,
    this.subtitle,
    this.coverPath,
    this.coverUrl,
    required this.origin,
    this.localId,
    this.service,
    this.serviceId,
  });
}

class RemoteFavoritesView extends StatefulWidget {
  const RemoteFavoritesView({super.key});

  @override
  State<RemoteFavoritesView> createState() => _RemoteFavoritesViewState();
}

class _RemoteFavoritesViewState extends State<RemoteFavoritesView> {
  _FavKind _kind = _FavKind.track;
  bool _loading = false;
  List<_FavItem> _items = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  String get _typeSingular => switch (_kind) {
        _FavKind.track => 'track',
        _FavKind.album => 'album',
        _FavKind.artist => 'artist',
      };

  String get _typePlural => switch (_kind) {
        _FavKind.track => 'tracks',
        _FavKind.album => 'albums',
        _FavKind.artist => 'artists',
      };

  Future<void> _load() async {
    final app = context.read<AppState>();
    final api = app.apiClient;
    // Active profile id lives on the API client (set on selection), as a String.
    final pid = api?.activeProfileId != null ? int.tryParse(api!.activeProfileId!) : null;
    if (api == null || pid == null) return;
    // Capture connected services before the awaits (avoid using context across
    // async gaps).
    final connected = context
        .read<LibraryState>()
        .streamingServices
        .where((s) => s.authenticated)
        .map((s) => s.serviceId)
        .toList();
    setState(() => _loading = true);
    final items = <_FavItem>[];

    // 1. Local profile favorites (flat records → hydrate by id). Best-effort.
    try {
      final rows = await api.getProfileFavorites(pid, type: _typeSingular);
      await Future.wait(rows.map((r) async {
        final id = (r is Map) ? r['item_id'] as int? : null;
        if (id == null) return;
        final Map<String, dynamic>? obj = switch (_kind) {
          _FavKind.track => await api.getTrackById(id),
          _FavKind.album => await api.getAlbumById(id),
          _FavKind.artist => await api.getArtistById(id),
        };
        if (obj != null) items.add(_localToFavItem(obj));
      }));
    } catch (_) {/* skip local on failure */}

    // 2. Tune-hearted streaming favorites (metadata already present).
    try {
      final rows = await api.getProfileStreamingFavorites(pid, type: _typeSingular);
      for (final r in rows) {
        if (r is Map<String, dynamic>) items.add(_streamingToFavItem(r, _FavOrigin.tune));
      }
    } catch (_) {}

    // 3. Each connected (authenticated) service's own favorites.
    await Future.wait(connected.map((svc) async {
      try {
        final rows = await api.getStreamingFavorites(svc, _typePlural);
        for (final r in rows) {
          if (r is Map<String, dynamic>) {
            items.add(_streamingToFavItem({...r, 'service': r['service'] ?? svc}, _FavOrigin.service));
          }
        }
      } catch (_) {}
    }));

    if (mounted) {
      setState(() {
        _items = items;
        _loading = false;
      });
    }
  }

  _FavItem _localToFavItem(Map<String, dynamic> o) {
    final artist = o['artist_name'] as String?;
    final album = o['album_title'] as String?;
    final sub = [if (artist != null) artist, if (album != null) album].join(' · ');
    return _FavItem(
      title: (o['title'] ?? o['name'] ?? '') as String,
      subtitle: sub.isEmpty ? null : sub,
      coverPath: (o['cover_path'] ?? o['image_path']) as String?,
      origin: _FavOrigin.local,
      localId: o['id'] as int?,
    );
  }

  _FavItem _streamingToFavItem(Map<String, dynamic> o, _FavOrigin origin) {
    // Tune favorites use {title,artist,album,cover_url,service,service_id};
    // service favorites use full objects {title/name, artist_name, cover_path/…}.
    final artist = (o['artist'] ?? o['artist_name']) as String?;
    final album = (o['album'] ?? o['album_title']) as String?;
    final sub = [if (artist != null) artist, if (album != null) album].join(' · ');
    return _FavItem(
      title: (o['title'] ?? o['name'] ?? '') as String,
      subtitle: sub.isEmpty ? null : sub,
      coverUrl: (o['cover_url'] as String?) ?? (o['cover_path'] is String && (o['cover_path'] as String).startsWith('http') ? o['cover_path'] as String : null),
      coverPath: (o['cover_path'] is String && !(o['cover_path'] as String).startsWith('http')) ? o['cover_path'] as String : null,
      origin: origin,
      service: (o['service'] ?? o['source']) as String?,
      serviceId: (o['service_id'] ?? o['source_id'] ?? o['id']?.toString()) as String?,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SegmentedButton<_FavKind>(
            segments: const [
              ButtonSegment(value: _FavKind.track, label: Text('Pistes')),
              ButtonSegment(value: _FavKind.album, label: Text('Albums')),
              ButtonSegment(value: _FavKind.artist, label: Text('Artistes')),
            ],
            selected: {_kind},
            onSelectionChanged: (s) {
              setState(() => _kind = s.first);
              _load();
            },
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _items.isEmpty
                  ? LibraryEmptyState(
                      icon: Icons.favorite_border_rounded,
                      message: l.libraryEmptyFavorites,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => const Divider(
                          height: 1, indent: 72, color: TuneColors.divider),
                      itemBuilder: (_, i) => _tile(_items[i]),
                    ),
        ),
      ],
    );
  }

  Widget _tile(_FavItem it) {
    final Widget leading = it.coverUrl != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(it.coverUrl!, width: 44, height: 44, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.music_note, size: 44)),
          )
        : ArtworkView(filePath: it.coverPath, size: 44, cornerRadius: 4);
    return ListTile(
      leading: leading,
      title: Text(it.title,
          style: TuneFonts.body, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: it.subtitle == null
          ? null
          : Text(it.subtitle!,
              style: TuneFonts.footnote, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: it.origin == _FavOrigin.local
          ? const Icon(Icons.favorite_rounded, color: TuneColors.accent, size: 18)
          : Icon(Icons.cloud_outlined, color: TuneColors.accent.withValues(alpha: 0.7), size: 18),
    );
  }
}
