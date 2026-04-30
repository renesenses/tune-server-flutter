import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'package:tune_server/services/tune_api_client.dart';

// ---------------------------------------------------------------------------
// SmartCollectionsView — v0.8.0
//
// List of rule-based collections served by /library/smart-collections.
// Sister of CollectionsView but membership is computed server-side from
// JSON-encoded rules. The full rule builder UI ships in this same file
// (SmartCollectionEditor) so we don't paginate the dev work across
// half a dozen partials.
// ---------------------------------------------------------------------------

class SmartCollectionsView extends StatefulWidget {
  const SmartCollectionsView({super.key});

  @override
  State<SmartCollectionsView> createState() => _SmartCollectionsViewState();
}

class _SmartCollectionsViewState extends State<SmartCollectionsView> {
  List<dynamic>? _collections;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final app = context.read<AppState>();
    if (app.apiClient == null) {
      if (mounted) setState(() { _loading = false; _error = 'Non connecté'; });
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final data = await app.apiClient!.listSmartCollections();
      if (!mounted) return;
      setState(() { _collections = data; _loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = '$e'; _loading = false; });
    }
  }

  Future<void> _delete(int id) async {
    final app = context.read<AppState>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer ?'),
        content: const Text('Cette Smart Collection sera supprimée définitivement.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer')),
        ],
      ),
    );
    if (ok != true || app.apiClient == null) return;
    try {
      await app.apiClient!.deleteSmartCollection(id);
      _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _openEditor({Map<String, dynamic>? collection}) async {
    final saved = await Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (_) => SmartCollectionEditor(collection: collection),
      fullscreenDialog: true,
    ));
    if (saved == true) _load();
  }

  Color _hexColor(String? hex) {
    if (hex == null || hex.isEmpty) return TuneColors.accent;
    var h = hex.startsWith('#') ? hex.substring(1) : hex;
    if (h.length == 6) h = 'FF$h';
    final parsed = int.tryParse(h, radix: 16);
    return parsed != null ? Color(parsed) : TuneColors.accent;
  }

  String _summary(dynamic raw) {
    try {
      final rules = jsonDecode(raw['rules'] as String? ?? '[]') as List;
      if (rules.isEmpty) return 'aucune règle';
      final parts = rules.take(2).map((r) {
        final field = r['field'] as String? ?? '';
        final op = r['op'] as String? ?? '';
        final value = r['value'];
        if (field == 'credit' && value is Map) {
          final role = value['role'] ?? '*';
          final artist = value['artist_name'] ?? '*';
          return 'crédit: $role=$artist';
        }
        return '$field $op ${value ?? ''}';
      });
      final glue = (raw['match_mode'] == 'all') ? ' ET ' : ' OU ';
      var summary = parts.join(glue);
      if (rules.length > 2) summary += ' + ${rules.length - 2}';
      return summary;
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text('Smart Collections', style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openEditor(),
            tooltip: 'Nouvelle Smart Collection',
          ),
        ],
      ),
      body: _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
          ? Center(child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(_error!, style: TextStyle(color: Colors.red[300])),
            ))
          : _collections == null || _collections!.isEmpty
            ? Center(child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.auto_awesome, size: 48, color: TuneColors.textSecondary),
                  const SizedBox(height: 12),
                  Text('Aucune Smart Collection', style: TuneFonts.body),
                  const SizedBox(height: 8),
                  Text('Le serveur seed normalement 7 collections par défaut au premier démarrage.',
                       style: TuneFonts.caption.copyWith(color: TuneColors.textSecondary),
                       textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => _openEditor(),
                    icon: const Icon(Icons.add),
                    label: const Text('Créer ma première Smart Collection'),
                  ),
                ]),
              ))
            : RefreshIndicator(
                onRefresh: _load,
                child: ListView.separated(
                  itemCount: _collections!.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0x22FFFFFF)),
                  itemBuilder: (_, i) {
                    final c = _collections![i];
                    final color = _hexColor(c['color'] as String?);
                    return Dismissible(
                      key: Key('sc-${c['id']}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) async {
                        await _delete(c['id'] as int);
                        return false;  // we reload manually
                      },
                      child: ListTile(
                        leading: Container(
                          width: 14, height: 14,
                          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                        ),
                        title: Text(c['name'] as String? ?? '', style: TuneFonts.body),
                        subtitle: Text(_summary(c),
                          style: TuneFonts.caption.copyWith(color: TuneColors.textSecondary),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () => _openEditor(collection: Map<String, dynamic>.from(c)),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => SmartCollectionDetailPage(collection: Map<String, dynamic>.from(c)),
                          ));
                        },
                      ),
                    );
                  },
                ),
              ),
    );
  }
}


// ---------------------------------------------------------------------------
// Detail page — list albums currently matching a Smart Collection's rules.
// ---------------------------------------------------------------------------

class SmartCollectionDetailPage extends StatefulWidget {
  final Map<String, dynamic> collection;
  const SmartCollectionDetailPage({super.key, required this.collection});

  @override
  State<SmartCollectionDetailPage> createState() => _SmartCollectionDetailPageState();
}

class _SmartCollectionDetailPageState extends State<SmartCollectionDetailPage> {
  List<dynamic>? _albums;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    try {
      final data = await app.apiClient!.getSmartCollectionAlbums(widget.collection['id'] as int);
      if (!mounted) return;
      setState(() { _albums = data; _loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = '$e'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(widget.collection['name'] as String? ?? '', style: TuneFonts.title3),
      ),
      body: _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
          ? Center(child: Text(_error!, style: TextStyle(color: Colors.red[300])))
          : _albums == null || _albums!.isEmpty
            ? Center(child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.inbox, size: 48, color: TuneColors.textSecondary),
                  const SizedBox(height: 12),
                  Text('Aucun album ne correspond', style: TuneFonts.body),
                  const SizedBox(height: 8),
                  Text(
                    "Pour les règles basées sur les crédits (engineer, performer, …), enrichis d'abord la bibliothèque depuis Settings.",
                    style: TuneFonts.caption.copyWith(color: TuneColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ]),
              ))
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 160, mainAxisExtent: 220,
                  mainAxisSpacing: 12, crossAxisSpacing: 12,
                ),
                itemCount: _albums!.length,
                itemBuilder: (_, i) {
                  final a = _albums![i];
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: ArtworkView(
                        url: a['cover_path'] as String?,
                        size: 140,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(a['title'] as String? ?? '',
                      style: TuneFonts.body.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(a['artist_name'] as String? ?? '—',
                      style: TuneFonts.caption.copyWith(color: TuneColors.textSecondary),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (a['year'] != null)
                      Text('${a['year']}',
                        style: TuneFonts.caption.copyWith(color: TuneColors.textTertiary)),
                  ]);
                },
              ),
    );
  }
}


// ---------------------------------------------------------------------------
// Editor — rule builder. Live preview count via debounced /preview call.
// ---------------------------------------------------------------------------

class SmartCollectionEditor extends StatefulWidget {
  final Map<String, dynamic>? collection;
  const SmartCollectionEditor({super.key, this.collection});

  @override
  State<SmartCollectionEditor> createState() => _SmartCollectionEditorState();
}

class _SmartCollectionEditorState extends State<SmartCollectionEditor> {
  final _nameCtrl = TextEditingController();
  String _color = '#6366f1';
  String _matchMode = 'all';
  List<Map<String, dynamic>> _rules = [];
  int? _previewCount;
  String? _previewError;
  Timer? _debounce;
  bool _saving = false;

  static const _colorOptions = [
    '#6366f1', '#ec4899', '#f59e0b', '#10b981',
    '#3b82f6', '#ef4444', '#8b5cf6', '#14b8a6', '#9333ea',
  ];

  // Mirrors tune_server.library.smart_collection field whitelist.
  static const _fields = [
    {'value': 'sample_rate', 'label': 'Sample rate', 'type': 'int'},
    {'value': 'bit_depth',   'label': 'Bit depth',   'type': 'int'},
    {'value': 'year',        'label': 'Année',       'type': 'int'},
    {'value': 'track_count', 'label': 'Nb pistes',   'type': 'int'},
    {'value': 'format',      'label': 'Format',      'type': 'text'},
    {'value': 'genre',       'label': 'Genre',       'type': 'text'},
    {'value': 'label',       'label': 'Label',       'type': 'text'},
    {'value': 'artist_name', 'label': 'Artiste',     'type': 'text'},
    {'value': 'title',       'label': "Titre album", 'type': 'text'},
    {'value': 'source',      'label': 'Source',      'type': 'text'},
    {'value': 'cover_path',  'label': 'Pochette',    'type': 'nullable'},
    {'value': 'added_at',    'label': "Date d'ajout",'type': 'timestamp'},
    {'value': 'credit',      'label': 'Crédit',      'type': 'credit'},
    {'value': 'play_count',  'label': 'Nb lectures', 'type': 'count'},
    {'value': 'last_played_at', 'label': 'Dernière lecture', 'type': 'timestamp'},
  ];

  static const _opsByType = {
    'int':       [['=','='], ['!=','≠'], ['>=','≥'], ['>','>'], ['<=','≤'], ['<','<'], ['between','entre']],
    'text':      [['=','='], ['!=','≠'], ['contains','contient'], ['starts_with','commence par'],
                  ['is_null','vide'], ['is_not_null','non vide']],
    'nullable':  [['is_null','vide'], ['is_not_null','non vide']],
    'timestamp': [['>','après'], ['<','avant'], ['is_null','jamais']],
    'credit':    [['has','contient']],
    'count':     [['>=','≥'], ['>','>'], ['=','='], ['<','<'], ['between','entre']],
  };

  @override
  void initState() {
    super.initState();
    if (widget.collection != null) {
      _nameCtrl.text = widget.collection!['name'] as String? ?? '';
      _color = widget.collection!['color'] as String? ?? '#6366f1';
      _matchMode = widget.collection!['match_mode'] as String? ?? 'all';
      try {
        final parsed = jsonDecode(widget.collection!['rules'] as String? ?? '[]') as List;
        _rules = parsed.map((r) => Map<String, dynamic>.from(r)).toList();
      } catch (_) {}
    } else {
      _rules = [
        {'field': 'sample_rate', 'op': '>=', 'value': 96000},
      ];
    }
    _refreshPreview();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  String _typeOf(String field) =>
      _fields.firstWhere((f) => f['value'] == field, orElse: () => _fields.first)['type']!;

  void _scheduleRefresh() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _refreshPreview);
  }

  Future<void> _refreshPreview() async {
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    try {
      final res = await app.apiClient!.previewSmartCollection(
        rules: _rules, matchMode: _matchMode, maxAlbums: 1,
      );
      if (!mounted) return;
      setState(() { _previewCount = res['count'] as int?; _previewError = null; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _previewError = '$e'; _previewCount = null; });
    }
  }

  void _addRule() {
    setState(() {
      _rules.add({'field': 'genre', 'op': 'contains', 'value': ''});
    });
    _scheduleRefresh();
  }

  void _removeRule(int idx) {
    setState(() => _rules.removeAt(idx));
    _scheduleRefresh();
  }

  Future<void> _save() async {
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    setState(() => _saving = true);
    try {
      final payload = {
        'name': _nameCtrl.text.trim().isEmpty ? 'Smart Collection' : _nameCtrl.text.trim(),
        'color': _color,
        'rules': _rules,
        'match_mode': _matchMode,
        'sort_by': 'added_at',
        'sort_order': 'desc',
        'max_albums': 500,
      };
      if (widget.collection != null && widget.collection!['id'] != null) {
        await app.apiClient!.updateSmartCollection(widget.collection!['id'] as int, payload);
      } else {
        await app.apiClient!.createSmartCollection(payload);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Color _hexColor(String hex) {
    var h = hex.startsWith('#') ? hex.substring(1) : hex;
    if (h.length == 6) h = 'FF$h';
    return Color(int.parse(h, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(widget.collection == null ? 'Nouvelle Smart Collection' : 'Modifier'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(widget.collection == null ? 'Créer' : 'Enregistrer'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Nom', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 8, children: _colorOptions.map((c) {
            final selected = c == _color;
            return GestureDetector(
              onTap: () => setState(() => _color = c),
              child: Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: _hexColor(c), shape: BoxShape.circle,
                  border: selected ? Border.all(color: Colors.white, width: 2) : null,
                ),
              ),
            );
          }).toList()),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _matchMode,
            decoration: const InputDecoration(labelText: 'Combinaison', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('Toutes les règles (ET)')),
              DropdownMenuItem(value: 'any', child: Text('Au moins une (OU)')),
            ],
            onChanged: (v) {
              if (v != null) {
                setState(() => _matchMode = v);
                _scheduleRefresh();
              }
            },
          ),
          const SizedBox(height: 16),
          ..._rules.asMap().entries.map((e) => _buildRule(e.key, e.value)),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _addRule,
            icon: const Icon(Icons.add),
            label: const Text('Ajouter une règle'),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _previewError != null ? Colors.red.withOpacity(0.1) : TuneColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: _previewError != null
              ? Row(children: [
                  Icon(Icons.warning_amber, color: Colors.red[300]),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_previewError!,
                    style: TuneFonts.caption.copyWith(color: Colors.red[300]))),
                ])
              : Row(children: [
                  Icon(Icons.album, color: TuneColors.accent),
                  const SizedBox(width: 8),
                  Text('${_previewCount ?? '…'} album${(_previewCount ?? 0) > 1 ? 's' : ''} correspondant${(_previewCount ?? 0) > 1 ? 's' : ''}',
                    style: TuneFonts.body.copyWith(fontWeight: FontWeight.w600)),
                ]),
          ),
        ],
      ),
    );
  }

  Widget _buildRule(int idx, Map<String, dynamic> rule) {
    final field = rule['field'] as String? ?? 'genre';
    final op = rule['op'] as String? ?? 'contains';
    final type = _typeOf(field);
    final ops = _opsByType[type] ?? _opsByType['text']!;

    return Card(
      color: TuneColors.surfaceVariant,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: DropdownButton<String>(
                isExpanded: true,
                value: field,
                items: _fields.map((f) => DropdownMenuItem(
                  value: f['value'], child: Text(f['label']!, overflow: TextOverflow.ellipsis),
                )).toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    rule['field'] = v;
                    final allowed = _opsByType[_typeOf(v)] ?? [['=','=']];
                    rule['op'] = allowed.first[0];
                    rule['value'] = _defaultValue(_typeOf(v), rule['op'] as String);
                  });
                  _scheduleRefresh();
                },
              ),
            ),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: ops.any((o) => o[0] == op) ? op : ops.first[0],
              items: ops.map((o) => DropdownMenuItem(value: o[0], child: Text(o[1]))).toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() {
                  rule['op'] = v;
                  rule['value'] = _defaultValue(type, v);
                });
                _scheduleRefresh();
              },
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
              onPressed: () => _removeRule(idx),
            ),
          ]),
          _buildValueEditor(idx, rule, type),
        ]),
      ),
    );
  }

  dynamic _defaultValue(String type, String op) {
    if (op == 'is_null' || op == 'is_not_null') return null;
    switch (type) {
      case 'credit': return {'role': 'engineer'};
      case 'int': case 'count': return 0;
      case 'timestamp': return 'now-30d';
      default: return '';
    }
  }

  Widget _buildValueEditor(int idx, Map<String, dynamic> rule, String type) {
    final op = rule['op'] as String? ?? '=';
    if (op == 'is_null' || op == 'is_not_null') return const SizedBox.shrink();
    if (type == 'credit') return _buildCreditEditor(rule);
    if (op == 'between') return _buildBetweenEditor(rule, type);
    if (op == 'in') return _buildInEditor(rule);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextField(
        controller: TextEditingController(text: '${rule['value'] ?? ''}'),
        decoration: InputDecoration(
          isDense: true,
          hintText: type == 'timestamp' ? 'now-30d ou 2024-01-01' : 'valeur',
          border: const OutlineInputBorder(),
        ),
        keyboardType: (type == 'int' || type == 'count') ? TextInputType.number : TextInputType.text,
        onChanged: (v) {
          rule['value'] = (type == 'int' || type == 'count') ? int.tryParse(v) ?? 0 : v;
          _scheduleRefresh();
        },
      ),
    );
  }

  Widget _buildBetweenEditor(Map<String, dynamic> rule, String type) {
    final list = (rule['value'] is List) ? List.from(rule['value']) : ['', ''];
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(children: [
        Expanded(child: TextField(
          controller: TextEditingController(text: '${list.elementAtOrNull(0) ?? ''}'),
          decoration: const InputDecoration(hintText: 'min', isDense: true, border: OutlineInputBorder()),
          keyboardType: (type == 'int' || type == 'count') ? TextInputType.number : TextInputType.text,
          onChanged: (v) {
            list.length = 2;
            list[0] = (type == 'int' || type == 'count') ? int.tryParse(v) ?? 0 : v;
            rule['value'] = list;
            _scheduleRefresh();
          },
        )),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('→')),
        Expanded(child: TextField(
          controller: TextEditingController(text: '${list.elementAtOrNull(1) ?? ''}'),
          decoration: const InputDecoration(hintText: 'max', isDense: true, border: OutlineInputBorder()),
          keyboardType: (type == 'int' || type == 'count') ? TextInputType.number : TextInputType.text,
          onChanged: (v) {
            list.length = 2;
            list[1] = (type == 'int' || type == 'count') ? int.tryParse(v) ?? 0 : v;
            rule['value'] = list;
            _scheduleRefresh();
          },
        )),
      ]),
    );
  }

  Widget _buildInEditor(Map<String, dynamic> rule) {
    final raw = (rule['value'] is List) ? (rule['value'] as List).join(',') : '';
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextField(
        controller: TextEditingController(text: raw),
        decoration: const InputDecoration(
          hintText: 'valeurs séparées par des virgules',
          isDense: true, border: OutlineInputBorder(),
        ),
        onChanged: (v) {
          rule['value'] = v.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
          _scheduleRefresh();
        },
      ),
    );
  }

  Widget _buildCreditEditor(Map<String, dynamic> rule) {
    final v = (rule['value'] is Map) ? Map<String, dynamic>.from(rule['value']) : <String, dynamic>{};
    Widget input(String key, String hint) => Padding(
      padding: const EdgeInsets.only(top: 6),
      child: TextField(
        controller: TextEditingController(text: '${v[key] ?? ''}'),
        decoration: InputDecoration(
          hintText: hint, isDense: true, border: const OutlineInputBorder(),
        ),
        onChanged: (s) {
          if (s.isEmpty) {
            v.remove(key);
          } else {
            v[key] = s;
          }
          rule['value'] = v;
          _scheduleRefresh();
        },
      ),
    );
    return Column(children: [
      input('role', 'rôle (engineer, performer, …)'),
      input('artist_name', 'artiste (Rudy Van Gelder, …)'),
      input('instrument', 'instrument (Piano, …) — optionnel'),
    ]);
  }
}
