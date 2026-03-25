import 'dart:async';

import 'package:flutter/material.dart' hide Radio;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/database/database.dart';
import '../../server/event_bus.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'radio_favorites_view.dart';

// ---------------------------------------------------------------------------
// T14.1 — RadiosView
// Liste radios, lecture, toggle favori, import M3U (coller / URL), ajout manuel.
// Métadonnées live via EventBus RadioMetadataEvent.
// Miroir de RadiosView.swift (iOS)
// ---------------------------------------------------------------------------

class RadiosView extends StatefulWidget {
  const RadiosView({super.key});

  @override
  State<RadiosView> createState() => _RadiosViewState();
}

class _RadiosViewState extends State<RadiosView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(l.radiosTitle, style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_rounded,
                size: 22, color: TuneColors.textSecondary),
            tooltip: l.radiosSavedFavorites,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RadioFavoritesView()),
            ),
          ),
          PopupMenuButton<_MenuAction>(
            icon: const Icon(Icons.more_vert_rounded,
                color: TuneColors.textSecondary),
            onSelected: (action) {
              if (action == _MenuAction.importText) {
                _showImportTextDialog();
              } else {
                _showImportUrlDialog();
              }
            },
            itemBuilder: (_) {
              final l = AppLocalizations.of(context);
              return [
                PopupMenuItem(
                  value: _MenuAction.importText,
                  child: ListTile(
                    leading: const Icon(Icons.paste_rounded),
                    title: Text(l.radiosPasteM3u),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: _MenuAction.importUrl,
                  child: ListTile(
                    leading: const Icon(Icons.download_rounded),
                    title: Text(l.radiosImportUrl),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ];
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          tabs: [
            Tab(text: l.radiosTabAll),
            Tab(text: l.radiosTabFavorites),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TuneColors.accent,
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: const [
          _RadioList(favoritesOnly: false),
          _RadioList(favoritesOnly: true),
        ],
      ),
    );
  }

  // ---- Dialogs ----

  Future<void> _showAddDialog() async {
    final nameCtrl = TextEditingController();
    final urlCtrl = TextEditingController();
    final genreCtrl = TextEditingController();

    final l = AppLocalizations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.radiosAdd, style: TuneFonts.title3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: TuneFonts.body,
              decoration: InputDecoration(labelText: l.radiosName),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: urlCtrl,
              style: TuneFonts.body,
              decoration: InputDecoration(labelText: l.radiosStreamUrl),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: genreCtrl,
              style: TuneFonts.body,
              decoration: InputDecoration(labelText: l.radiosGenre),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.btnCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.btnAdd,
                style: const TextStyle(color: TuneColors.accent)),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final name = nameCtrl.text.trim();
      final url = urlCtrl.text.trim();
      if (name.isNotEmpty && url.isNotEmpty) {
        await context.read<AppState>().addRadio(
              name: name,
              streamUrl: url,
              genre: genreCtrl.text.trim().isEmpty
                  ? null
                  : genreCtrl.text.trim(),
            );
      }
    }
  }

  Future<void> _showImportTextDialog() async {
    final ctrl = TextEditingController();
    final l = AppLocalizations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.radiosPasteM3u, style: TuneFonts.title3),
        content: TextField(
          controller: ctrl,
          style: TuneFonts.footnote,
          maxLines: 8,
          decoration: const InputDecoration(
            hintText: '#EXTM3U\n#EXTINF:-1,Radio Name\nhttp://...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.btnCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.btnImport,
                style: const TextStyle(color: TuneColors.accent)),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final content = ctrl.text.trim();
      if (content.isNotEmpty) {
        final added =
            await context.read<AppState>().importM3UContent(content);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).radiosImportResult(added))),
          );
        }
      }
    }
  }

  Future<void> _showImportUrlDialog() async {
    final ctrl = TextEditingController();
    final l = AppLocalizations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.radiosImportUrl, style: TuneFonts.title3),
        content: TextField(
          controller: ctrl,
          style: TuneFonts.body,
          decoration: InputDecoration(
            hintText: 'https://example.com/radios.m3u',
            labelText: l.radiosImportUrlLabel,
          ),
          keyboardType: TextInputType.url,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.btnCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.btnDownload,
                style: const TextStyle(color: TuneColors.accent)),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final url = ctrl.text.trim();
      if (url.isNotEmpty) {
        try {
          final resp = await http
              .get(Uri.parse(url))
              .timeout(const Duration(seconds: 15));
          if (!mounted) return;
          if (resp.statusCode == 200) {
            final added =
                await context.read<AppState>().importM3UContent(resp.body);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context).radiosImportResult(added))),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context).radiosImportHttpError(resp.statusCode))),
            );
          }
        } catch (_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(AppLocalizations.of(context).radiosImportFailed)),
            );
          }
        }
      }
    }
  }
}

enum _MenuAction { importText, importUrl }

// ---------------------------------------------------------------------------
// _RadioList
// ---------------------------------------------------------------------------

class _RadioList extends StatelessWidget {
  final bool favoritesOnly;
  const _RadioList({required this.favoritesOnly});

  @override
  Widget build(BuildContext context) {
    final radios = context.select<LibraryState, List<Radio>>(
      (s) => favoritesOnly
          ? s.radios.where((r) => r.favorite).toList()
          : s.radios,
    );

    if (radios.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.radio_rounded,
                size: 56, color: TuneColors.textTertiary),
            const SizedBox(height: 12),
            Text(
              favoritesOnly ? 'Aucune radio favorite' : 'Aucune radio',
              style: TuneFonts.subheadline,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: radios.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 1, indent: 72, color: TuneColors.divider),
      itemBuilder: (_, i) => _RadioTile(radio: radios[i]),
    );
  }
}

// ---------------------------------------------------------------------------
// _RadioTile — métadonnées live via EventBus
// ---------------------------------------------------------------------------

class _RadioTile extends StatefulWidget {
  final Radio radio;
  const _RadioTile({required this.radio});

  @override
  State<_RadioTile> createState() => _RadioTileState();
}

class _RadioTileState extends State<_RadioTile> {
  String? _liveTitle;
  String? _liveArtist;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = EventBus.instance.subscribe<RadioMetadataEvent>(_onMeta);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _onMeta(RadioMetadataEvent e) {
    if (e.stationName == widget.radio.name && mounted) {
      setState(() {
        _liveTitle = e.title;
        _liveArtist = e.artist;
      });
    }
  }

  String? get _liveText {
    if (_liveTitle == null) return null;
    if (_liveArtist != null) return '$_liveArtist — $_liveTitle';
    return _liveTitle;
  }

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();

    return Dismissible(
      key: ValueKey(widget.radio.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (_) => app.deleteRadio(widget.radio.id),
      child: ListTile(
        onTap: () => app.playRadio(widget.radio),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: ArtworkView(url: widget.radio.logoUrl, size: 44),
        ),
        title: Text(widget.radio.name,
            style: TuneFonts.body,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        subtitle: _liveText != null
            ? Text(_liveText!,
                style: TuneFonts.footnote,
                maxLines: 1,
                overflow: TextOverflow.ellipsis)
            : widget.radio.genre != null
                ? Text(widget.radio.genre!,
                    style: TuneFonts.footnote,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis)
                : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                widget.radio.favorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size: 20,
                color: widget.radio.favorite
                    ? TuneColors.accent
                    : TuneColors.textTertiary,
              ),
              onPressed: () => app.toggleRadioFavorite(widget.radio),
            ),
            if (_liveTitle != null)
              IconButton(
                icon: const Icon(Icons.bookmark_add_rounded,
                    size: 20, color: TuneColors.textTertiary),
                tooltip: 'Sauvegarder le morceau',
                onPressed: () => _saveFavorite(app),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveFavorite(AppState app) async {
    if (_liveTitle == null) return;
    await app.saveRadioFavorite(
      title: _liveTitle!,
      artist: _liveArtist,
      radio: widget.radio,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).radiosFavSaved)),
      );
    }
  }
}
