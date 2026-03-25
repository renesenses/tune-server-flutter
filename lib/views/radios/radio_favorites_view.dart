import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// T14.2 — RadioFavoritesView
// Historique des morceaux sauvegardés lors de l'écoute radio + export CSV.
// Miroir de RadioFavoritesView.swift (iOS)
// ---------------------------------------------------------------------------

class RadioFavoritesView extends StatefulWidget {
  const RadioFavoritesView({super.key});

  @override
  State<RadioFavoritesView> createState() => _RadioFavoritesViewState();
}

class _RadioFavoritesViewState extends State<RadioFavoritesView> {
  List<RadioFavorite>? _favorites;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final favs = await context
        .read<AppState>()
        .engine
        .db
        .radioRepo
        .allFavorites();
    if (mounted) setState(() => _favorites = favs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(AppLocalizations.of(context).radioFavTitle,
            style: TuneFonts.title3),
        actions: [
          if (_favorites?.isNotEmpty == true)
            IconButton(
              icon: const Icon(Icons.download_rounded,
                  color: TuneColors.textSecondary),
              tooltip: AppLocalizations.of(context).radioFavExportCsv,
              onPressed: _exportCsv,
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_favorites == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_favorites!.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bookmark_border_rounded,
                size: 56, color: TuneColors.textTertiary),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context).radioFavEmpty,
                style: TuneFonts.subheadline),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: _favorites!.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 1, indent: 16, color: TuneColors.divider),
      itemBuilder: (_, i) => _FavoriteTile(
        favorite: _favorites![i],
        onDelete: () => _delete(_favorites![i]),
      ),
    );
  }

  Future<void> _delete(RadioFavorite fav) async {
    await context.read<AppState>().engine.db.radioRepo.deleteFavorite(fav.id);
    await _load();
  }

  Future<void> _exportCsv() async {
    final favs = _favorites;
    if (favs == null || favs.isEmpty) return;

    final buffer = StringBuffer();
    buffer.writeln('Title,Artist,Station,Stream URL,Date');
    for (final f in favs) {
      buffer.writeln(
        '"${_escapeCsv(f.title)}","${_escapeCsv(f.artist)}","${_escapeCsv(f.stationName)}","${_escapeCsv(f.streamUrl)}","${f.savedAt}"',
      );
    }

    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/radio_favorites.csv');
      await file.writeAsString(buffer.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)
              .radioFavExportDone(file.path))),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(
              AppLocalizations.of(context).radioFavExportError)),
        );
      }
    }
  }

  static String _escapeCsv(String s) => s.replaceAll('"', '""');
}

// ---------------------------------------------------------------------------
// _FavoriteTile
// ---------------------------------------------------------------------------

class _FavoriteTile extends StatelessWidget {
  final RadioFavorite favorite;
  final VoidCallback onDelete;

  const _FavoriteTile({required this.favorite, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(favorite.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          favorite.title,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          favorite.artist.isNotEmpty
              ? '${favorite.artist} · ${favorite.stationName}'
              : favorite.stationName,
          style: TuneFonts.footnote,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          _formatDate(favorite.savedAt),
          style: TuneFonts.footnote,
        ),
      ),
    );
  }

  static String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/'
          '${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}
