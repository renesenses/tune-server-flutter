import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/domain_models.dart';
import '../../state/app_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// SmartPlaylistsView — List of smart playlists with rules, tracks, delete,
// create/edit rules builder, and preview
// ---------------------------------------------------------------------------

class SmartPlaylistsView extends StatefulWidget {
  const SmartPlaylistsView({super.key});

  @override
  State<SmartPlaylistsView> createState() => _SmartPlaylistsViewState();
}

class _SmartPlaylistsViewState extends State<SmartPlaylistsView> {
  List<Map<String, dynamic>> _playlists = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final data = await api.getSmartPlaylists();
      if (!mounted) return;
      setState(() {
        _playlists = data.cast<Map<String, dynamic>>();
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).plSmartLoadError(e.toString()))),
        );
      }
    }
  }

  Future<void> _delete(int id, int index) async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    try {
      await api.deleteSmartPlaylist(id);
      if (mounted) {
        setState(() => _playlists.removeAt(index));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).plDeleteError(e.toString()))),
        );
      }
    }
  }

  Future<void> _openEditor({Map<String, dynamic>? playlist}) async {
    final saved = await Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (_) => _SmartPlaylistEditor(playlist: playlist),
      fullscreenDialog: true,
    ));
    if (saved == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(l.plSmartTitle, style: TuneFonts.title2),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TuneColors.accent,
        onPressed: () => _openEditor(),
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _playlists.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome_rounded,
                          size: 56, color: TuneColors.textTertiary),
                      const SizedBox(height: 12),
                      Text(l.plSmartEmpty,
                          style: TuneFonts.subheadline),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => _openEditor(),
                        icon: const Icon(Icons.add),
                        label: Text(l.btnCreate),
                        style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _playlists.length,
                    itemBuilder: (_, i) {
                      final pl = _playlists[i];
                      final id = pl['id'] as int;
                      final name = pl['name'] as String? ?? l.plUntitled;
                      final rules = pl['rules'] as List? ?? [];
                      final trackCount = pl['track_count'] as int? ?? 0;

                      return Dismissible(
                        key: ValueKey(id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: TuneColors.error,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete_rounded,
                              color: Colors.white),
                        ),
                        confirmDismiss: (_) async {
                          return await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: TuneColors.surface,
                              title: Text(l.plSmartDeleteTitle),
                              content: Text(l.plDeleteNamed(name)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: Text(l.btnCancel),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: Text(l.btnDelete,
                                      style: const TextStyle(color: TuneColors.error)),
                                ),
                              ],
                            ),
                          ) ?? false;
                        },
                        onDismissed: (_) => _delete(id, i),
                        child: ListTile(
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: TuneColors.accent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.auto_awesome_rounded,
                                color: TuneColors.accent),
                          ),
                          title: Text(name,
                              style: TuneFonts.body,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          subtitle: Wrap(
                            spacing: 4,
                            runSpacing: 2,
                            children: [
                              Text(l.plTracksCount(trackCount),
                                  style: TuneFonts.caption),
                              for (final rule in rules.take(3))
                                Chip(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  label: Text(
                                    _ruleLabel(l, rule),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  backgroundColor:
                                      TuneColors.surfaceVariant,
                                  side: BorderSide.none,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_rounded, size: 18, color: TuneColors.textSecondary),
                                tooltip: l.btnEdit,
                                onPressed: () => _openEditor(playlist: pl),
                              ),
                              const Icon(Icons.chevron_right_rounded,
                                  color: TuneColors.textTertiary),
                            ],
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => _SmartPlaylistDetailView(
                                playlistId: id,
                                playlistName: name,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  String _ruleLabel(AppLocalizations l, dynamic rule) {
    if (rule is Map<String, dynamic>) {
      final field = rule['field'] as String? ?? '';
      final op = rule['operator'] as String? ?? '';
      final value = rule['value']?.toString() ?? '';
      return '${_fieldLabel(l, field)} ${_operatorLabel(l, op)} $value';
    }
    return rule.toString();
  }
}

/// Libellé affiché d'un champ de règle (la valeur envoyée au serveur reste l'identifiant).
String _fieldLabel(AppLocalizations l, String field) => switch (field) {
      'genre' => l.plFieldGenre,
      'artist' => l.plFieldArtist,
      'album' => l.plFieldAlbum,
      'title' => l.plFieldTitle,
      'year' => l.plFieldYear,
      'rating' => l.plFieldRating,
      'play_count' => l.plFieldPlayCount,
      'duration_ms' => l.plFieldDuration,
      'date_added' => l.plFieldDateAdded,
      'favorite' => l.plFieldFavorite,
      _ => field,
    };

/// Libellé affiché d'un opérateur de règle (la valeur envoyée au serveur reste l'identifiant).
String _operatorLabel(AppLocalizations l, String op) => switch (op) {
      'contains' => l.plOpContains,
      'equals' => l.plOpEquals,
      'starts_with' => l.plOpStartsWith,
      'ends_with' => l.plOpEndsWith,
      'greater_than' => l.plOpGreaterThan,
      'less_than' => l.plOpLessThan,
      'is' => l.plOpIs,
      'is_not' => l.plOpIsNot,
      _ => op,
    };

// ---------------------------------------------------------------------------
// Smart Playlist Editor — create/edit with rules builder + preview
// ---------------------------------------------------------------------------

const _availableFields = ['genre', 'artist', 'album', 'title', 'year', 'rating', 'play_count', 'duration_ms', 'date_added', 'favorite'];
const _availableOperators = ['contains', 'equals', 'starts_with', 'ends_with', 'greater_than', 'less_than', 'is', 'is_not'];

class _SmartPlaylistEditor extends StatefulWidget {
  final Map<String, dynamic>? playlist;
  const _SmartPlaylistEditor({this.playlist});

  @override
  State<_SmartPlaylistEditor> createState() => _SmartPlaylistEditorState();
}

class _SmartPlaylistEditorState extends State<_SmartPlaylistEditor> {
  final _nameCtrl = TextEditingController();
  String _matchMode = 'all';
  List<Map<String, dynamic>> _rules = [];
  int? _limit;

  // Preview
  List<dynamic> _previewTracks = [];
  bool _previewing = false;
  bool _saving = false;

  bool get _isEditing => widget.playlist != null;

  @override
  void initState() {
    super.initState();
    if (widget.playlist != null) {
      _nameCtrl.text = widget.playlist!['name'] as String? ?? '';
      _matchMode = widget.playlist!['match_mode'] as String? ?? 'all';
      _limit = widget.playlist!['limit'] as int?;
      final rawRules = widget.playlist!['rules'];
      if (rawRules is List) {
        _rules = rawRules.map((r) {
          if (r is Map<String, dynamic>) return Map<String, dynamic>.from(r);
          return <String, dynamic>{};
        }).where((r) => r.isNotEmpty).toList();
      }
    }
    if (_rules.isEmpty) {
      _rules.add({'field': 'genre', 'operator': 'contains', 'value': ''});
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _addRule() {
    setState(() {
      _rules.add({'field': 'genre', 'operator': 'contains', 'value': ''});
    });
  }

  void _removeRule(int index) {
    if (_rules.length <= 1) return;
    setState(() => _rules.removeAt(index));
  }

  Future<void> _preview() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    setState(() => _previewing = true);
    try {
      final tracks = await api.previewSmartPlaylistTracks(
        rules: _rules,
        matchMode: _matchMode,
        limit: _limit ?? 50,
      );
      if (!mounted) return;
      setState(() {
        _previewTracks = tracks;
        _previewing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _previewing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).plPreviewError(e.toString()))),
      );
    }
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).plEnterName)),
      );
      return;
    }
    final api = context.read<AppState>().apiClient;
    if (api == null) return;

    setState(() => _saving = true);
    try {
      final body = {
        'name': name,
        'rules': _rules,
        'match_mode': _matchMode,
        if (_limit != null) 'limit': _limit,
      };
      if (_isEditing) {
        await api.updateSmartPlaylist(widget.playlist!['id'] as int, body);
      } else {
        await api.createSmartPlaylist(body);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).plSaveError(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(_isEditing ? l.plSmartEditTitle : l.plSmartNewTitle, style: TuneFonts.title3),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: TuneColors.accent))
                : Text(l.btnSave, style: const TextStyle(color: TuneColors.accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Name
          TextField(
            controller: _nameCtrl,
            style: TuneFonts.body,
            decoration: InputDecoration(
              labelText: l.plNameLabel,
              filled: true,
              fillColor: TuneColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: TuneColors.divider)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: TuneColors.divider)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: TuneColors.accent)),
            ),
          ),
          const SizedBox(height: 16),

          // Match mode
          Row(
            children: [
              Text(l.plMatchLabel, style: TuneFonts.body),
              const SizedBox(width: 12),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: 'all', label: Text(l.plMatchAll)),
                  ButtonSegment(value: 'any', label: Text(l.plMatchAny)),
                ],
                selected: {_matchMode},
                onSelectionChanged: (v) => setState(() => _matchMode = v.first),
                style: ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TuneFonts.caption),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Rules
          Text(l.plSectionRules, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TuneColors.textTertiary, letterSpacing: 1)),
          const SizedBox(height: 8),
          for (int i = 0; i < _rules.length; i++) _RuleRow(
            rule: _rules[i],
            canRemove: _rules.length > 1,
            onChanged: (r) => setState(() => _rules[i] = r),
            onRemove: () => _removeRule(i),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _addRule,
              icon: const Icon(Icons.add_circle_outline, size: 18, color: TuneColors.accent),
              label: Text(l.plAddRule, style: const TextStyle(color: TuneColors.accent)),
            ),
          ),
          const SizedBox(height: 16),

          // Limit
          TextField(
            style: TuneFonts.body,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l.plMaxTracksLabel,
              hintText: l.plNoLimit,
              filled: true,
              fillColor: TuneColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: TuneColors.divider)),
            ),
            controller: TextEditingController(text: _limit?.toString() ?? ''),
            onChanged: (v) => _limit = int.tryParse(v),
          ),
          const SizedBox(height: 20),

          // Preview button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _previewing ? null : _preview,
              icon: _previewing
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: TuneColors.accent))
                  : const Icon(Icons.visibility_rounded, size: 18),
              label: Text(_previewing ? l.loading : l.plPreviewMatching),
              style: OutlinedButton.styleFrom(
                foregroundColor: TuneColors.accent,
                side: const BorderSide(color: TuneColors.accent),
                minimumSize: const Size.fromHeight(44),
              ),
            ),
          ),

          // Preview results
          if (_previewTracks.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(l.plMatchingTracks(_previewTracks.length), style: TuneFonts.footnote),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: TuneColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < _previewTracks.length && i < 20; i++) ...[
                    if (i > 0) const Divider(height: 1, indent: 12, color: TuneColors.divider),
                    _PreviewTrackTile(track: _previewTracks[i] as Map<String, dynamic>),
                  ],
                  if (_previewTracks.length > 20)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(l.plMoreCount(_previewTracks.length - 20), style: TuneFonts.caption),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  final Map<String, dynamic> rule;
  final bool canRemove;
  final ValueChanged<Map<String, dynamic>> onChanged;
  final VoidCallback onRemove;

  const _RuleRow({
    required this.rule,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final field = rule['field'] as String? ?? 'genre';
    final operator = rule['operator'] as String? ?? 'contains';
    final value = rule['value']?.toString() ?? '';
    final l = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: TuneColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: TuneColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: DropdownButton<String>(
              value: _availableFields.contains(field) ? field : _availableFields.first,
              isExpanded: true,
              dropdownColor: TuneColors.surfaceVariant,
              underline: const SizedBox(),
              style: TuneFonts.caption.copyWith(color: TuneColors.textPrimary),
              items: _availableFields.map((f) => DropdownMenuItem(value: f, child: Text(_fieldLabel(l, f)))).toList(),
              onChanged: (v) => onChanged({...rule, 'field': v}),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 2,
            child: DropdownButton<String>(
              value: _availableOperators.contains(operator) ? operator : _availableOperators.first,
              isExpanded: true,
              dropdownColor: TuneColors.surfaceVariant,
              underline: const SizedBox(),
              style: TuneFonts.caption.copyWith(color: TuneColors.textPrimary),
              items: _availableOperators.map((o) => DropdownMenuItem(value: o, child: Text(_operatorLabel(l, o)))).toList(),
              onChanged: (v) => onChanged({...rule, 'operator': v}),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 3,
            child: TextField(
              controller: TextEditingController(text: value)
                ..selection = TextSelection.collapsed(offset: value.length),
              style: TuneFonts.caption.copyWith(color: TuneColors.textPrimary),
              decoration: InputDecoration(
                hintText: l.plValueHint,
                hintStyle: TuneFonts.caption,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: TuneColors.divider)),
                filled: true,
                fillColor: TuneColors.surfaceVariant,
              ),
              onChanged: (v) => onChanged({...rule, 'value': v}),
            ),
          ),
          if (canRemove) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onRemove,
              child: const Icon(Icons.remove_circle_outline, size: 18, color: TuneColors.error),
            ),
          ],
        ],
      ),
    );
  }
}

class _PreviewTrackTile extends StatelessWidget {
  final Map<String, dynamic> track;
  const _PreviewTrackTile({required this.track});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track['title'] as String? ?? AppLocalizations.of(context).plUnknownTitle,
                  style: TuneFonts.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${track['artist_name'] ?? ''} - ${track['album_title'] ?? ''}',
                  style: TuneFonts.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Smart Playlist Detail — shows tracks, play all FAB
// ---------------------------------------------------------------------------

class _SmartPlaylistDetailView extends StatefulWidget {
  final int playlistId;
  final String playlistName;

  const _SmartPlaylistDetailView({
    required this.playlistId,
    required this.playlistName,
  });

  @override
  State<_SmartPlaylistDetailView> createState() =>
      _SmartPlaylistDetailViewState();
}

class _SmartPlaylistDetailViewState extends State<_SmartPlaylistDetailView> {
  List<dynamic> _tracks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTracks();
  }

  Future<void> _loadTracks() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final data = await api.getSmartPlaylistTracks(widget.playlistId);
      if (!mounted) return;
      setState(() {
        _tracks = data;
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).plTracksLoadError(e.toString()))),
        );
      }
    }
  }

  void _playAll() {
    if (_tracks.isEmpty) return;
    final app = context.read<AppState>();
    final tracks = _tracks
        .map((t) => trackFromJson(t as Map<String, dynamic>))
        .toList();
    app.playTracks(tracks);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(widget.playlistName,
            style: TuneFonts.title3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ),
      floatingActionButton: _tracks.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: TuneColors.accent,
              onPressed: _playAll,
              child: const Icon(Icons.play_arrow_rounded),
            )
          : null,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _tracks.isEmpty
              ? Center(
                  child: Text(l.plSmartNoTracks,
                      style: TuneFonts.subheadline),
                )
              : ListView.builder(
                  itemCount: _tracks.length,
                  itemBuilder: (_, i) {
                    final t = _tracks[i] as Map<String, dynamic>;
                    final title = t['title'] as String? ?? l.plUnknownTitle;
                    final artist = t['artist_name'] as String?;
                    final cover = t['cover_path'] as String?;

                    return ListTile(
                      leading: ArtworkView(
                          filePath: cover, size: 44, cornerRadius: 6),
                      title: Text(title,
                          style: TuneFonts.body,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      subtitle: artist != null
                          ? Text(artist,
                              style: TuneFonts.footnote,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis)
                          : null,
                      onTap: () {
                        final app = context.read<AppState>();
                        final tracks = _tracks
                            .map((tr) =>
                                trackFromJson(tr as Map<String, dynamic>))
                            .toList();
                        app.playTracks(tracks, startIndex: i);
                      },
                    );
                  },
                ),
    );
  }
}
