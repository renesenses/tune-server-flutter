import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/database/database.dart';
import '../../server/library/apple_music_library.dart';
import '../../server/library/metadata_reader.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'albums_grid_view.dart';

// ---------------------------------------------------------------------------
// T12.6 — AppleMusicView
// Bibliothèque iPod/Apple Music locale (iOS uniquement).
// Affiche les pistes via MPMediaLibrary et permet de les lire.
// Masquée sur Android (Platform.isIOS guard dans LibraryView).
// Miroir de AppleMusicView.swift (iOS)
// ---------------------------------------------------------------------------

class AppleMusicView extends StatefulWidget {
  const AppleMusicView({super.key});

  @override
  State<AppleMusicView> createState() => _AppleMusicViewState();
}

class _AppleMusicViewState extends State<AppleMusicView> {
  final _library = const AppleMusicLibrary();

  _ViewState _state = _ViewState.idle;
  List<TrackMetadata> _tracks = [];
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _checkAuthorization();
  }

  Future<void> _checkAuthorization() async {
    final status = await _library.authorizationStatus();
    if (status == 'authorized') {
      await _loadTracks();
    } else if (status == 'notDetermined') {
      if (mounted) setState(() => _state = _ViewState.needsPermission);
    } else {
      if (mounted) {
        setState(() {
          _state = _ViewState.error;
          _errorMsg = 'Accès à la bibliothèque Apple Music refusé.';
        });
      }
    }
  }

  Future<void> _requestPermission() async {
    setState(() => _state = _ViewState.loading);
    final granted = await _library.requestAuthorization();
    if (granted) {
      await _loadTracks();
    } else {
      if (mounted) {
        setState(() {
          _state = _ViewState.error;
          _errorMsg = 'Autorisation refusée. '
              'Activez l\'accès dans Réglages > Confidentialité > Musique.';
        });
      }
    }
  }

  Future<void> _loadTracks() async {
    if (mounted) setState(() => _state = _ViewState.loading);
    final list = <TrackMetadata>[];
    await for (final t in _library.allTracks()) {
      list.add(t);
    }
    if (mounted) {
      setState(() {
        _tracks = list;
        _state = _ViewState.loaded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (_state) {
      _ViewState.idle || _ViewState.loading => const Center(
          child: CircularProgressIndicator(),
        ),
      _ViewState.needsPermission => _PermissionPrompt(
          onRequest: _requestPermission,
        ),
      _ViewState.error => _ErrorView(message: _errorMsg ?? 'Erreur inconnue'),
      _ViewState.loaded => _TrackList(
          tracks: _tracks,
          onRefresh: _loadTracks,
        ),
    };
  }
}

// ---------------------------------------------------------------------------
// Sub-states
// ---------------------------------------------------------------------------

enum _ViewState { idle, loading, needsPermission, error, loaded }

// ---------------------------------------------------------------------------
// _PermissionPrompt
// ---------------------------------------------------------------------------

class _PermissionPrompt extends StatelessWidget {
  final VoidCallback onRequest;
  const _PermissionPrompt({required this.onRequest});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.library_music_rounded,
                size: 64, color: TuneColors.textTertiary),
            const SizedBox(height: 20),
            const Text(
              'Accès à Apple Music',
              style: TuneFonts.title3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Autorisez l\'accès à votre bibliothèque musicale '
              'pour lire vos pistes Apple Music.',
              style: TuneFonts.subheadline,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: TuneColors.accent),
              onPressed: onRequest,
              child: Text(AppLocalizations.of(context).appleMusicAuthorize),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ErrorView
// ---------------------------------------------------------------------------

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 48, color: TuneColors.error),
            const SizedBox(height: 12),
            Text(message,
                style: TuneFonts.subheadline, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _TrackList
// ---------------------------------------------------------------------------

class _TrackList extends StatelessWidget {
  final List<TrackMetadata> tracks;
  final Future<void> Function() onRefresh;
  const _TrackList({required this.tracks, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) {
      return const LibraryEmptyState(
        icon: Icons.music_off_rounded,
        message: 'Bibliothèque Apple Music vide',
      );
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: TuneColors.accent,
      child: ListView.separated(
        itemCount: tracks.length,
        separatorBuilder: (_, __) => const Divider(
            height: 1, indent: 72, color: TuneColors.divider),
        itemBuilder: (_, i) => _AppleTrackTile(
          meta: tracks[i],
          onTap: () => _playAppleTrack(context, tracks[i]),
        ),
      ),
    );
  }

  Future<void> _playAppleTrack(
      BuildContext context, TrackMetadata meta) async {
    final app = context.read<AppState>();
    // Construit une Track éphémère pour Apple Music
    final track = Track(
      id: 0,
      title: meta.title,
      albumTitle: meta.album,
      artistName: meta.artist,
      filePath: meta.filePath,
      source: 'apple_music',
      trackNumber: meta.trackNumber,
      discNumber: meta.discNumber,
      durationMs: meta.durationMs,
      format: meta.format,
      favorite: false,
    );
    await app.playTracks([track]);
  }
}

class _AppleTrackTile extends StatelessWidget {
  final TrackMetadata meta;
  final VoidCallback onTap;
  const _AppleTrackTile({required this.meta, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: TuneColors.surfaceVariant,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.music_note_rounded,
            color: TuneColors.textTertiary, size: 22),
      ),
      title: Text(meta.title,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: _subtitle(meta),
      trailing: meta.format != null
          ? FormatBadge(format: meta.format)
          : null,
    );
  }

  Widget? _subtitle(TrackMetadata meta) {
    final parts = <String>[
      if (meta.artist != null) meta.artist!,
      if (meta.album != null) meta.album!,
    ];
    if (parts.isEmpty) return null;
    return Text(
      parts.join(' · '),
      style: TuneFonts.footnote,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
