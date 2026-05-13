import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/tune_api_client.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// GenreTreeView
// Displays the server-side genre hierarchy (parent -> children, expandable).
// Allows adding/removing genres from the tree.
// Remote mode only (requires GET/PUT /api/v1/library/genre-tree).
// ---------------------------------------------------------------------------

class GenreTreeView extends StatefulWidget {
  const GenreTreeView({super.key});

  @override
  State<GenreTreeView> createState() => _GenreTreeViewState();
}

class _GenreTreeViewState extends State<GenreTreeView> {
  Map<String, dynamic>? _tree;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTree();
  }

  TuneApiClient? get _api => context.read<AppState>().apiClient;

  Future<void> _loadTree() async {
    final api = _api;
    if (api == null) return;
    setState(() { _loading = true; _error = null; });
    try {
      final data = await api.getGenreTree();
      if (mounted) setState(() { _tree = data; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = '$e'; _loading = false; });
    }
  }

  Future<void> _saveTree(Map<String, dynamic> tree) async {
    final api = _api;
    if (api == null) return;
    try {
      await api.updateGenreTree(tree);
      if (mounted) {
        setState(() => _tree = tree);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Genre tree saved'),
            backgroundColor: TuneColors.accent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving: $e'),
            backgroundColor: TuneColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final api = _api;

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Genre Tree', style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: TuneColors.textSecondary),
            tooltip: 'Refresh',
            onPressed: _loadTree,
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded, color: TuneColors.accent),
            tooltip: 'Add root genre',
            onPressed: _tree != null
                ? () => _showAddGenreDialog(null)
                : null,
          ),
        ],
      ),
      body: api == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off_rounded,
                        size: 48, color: TuneColors.textTertiary),
                    const SizedBox(height: 16),
                    Text(
                      'Genre Tree requires a remote server connection.',
                      textAlign: TextAlign.center,
                      style: TuneFonts.body
                          .copyWith(color: TuneColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          : _loading
              ? const Center(
                  child:
                      CircularProgressIndicator(color: TuneColors.accent))
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              size: 48, color: TuneColors.error),
                          const SizedBox(height: 12),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(_error!,
                                style: TuneFonts.subheadline,
                                textAlign: TextAlign.center),
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: _loadTree,
                            style: FilledButton.styleFrom(
                                backgroundColor: TuneColors.accent),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _buildTree(),
    );
  }

  Widget _buildTree() {
    final tree = _tree;
    if (tree == null || tree.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_tree_rounded,
                size: 56, color: TuneColors.textTertiary),
            const SizedBox(height: 12),
            Text('No genre hierarchy defined',
                style: TuneFonts.subheadline),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add root genre'),
              style: FilledButton.styleFrom(
                  backgroundColor: TuneColors.accent),
              onPressed: () => _showAddGenreDialog(null),
            ),
          ],
        ),
      );
    }

    // tree is expected as { "genre_name": { "children": [...] }, ... }
    // or { "genre_name": ["child1", "child2"], ... }
    final entries = tree.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: entries.length,
      itemBuilder: (_, i) {
        final entry = entries[i];
        return _GenreNode(
          name: entry.key,
          value: entry.value,
          depth: 0,
          onDelete: () => _removeGenre(entry.key, null),
          onAddChild: () => _showAddGenreDialog(entry.key),
        );
      },
    );
  }

  void _showAddGenreDialog(String? parentGenre) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(
          parentGenre != null
              ? 'Add sub-genre to "$parentGenre"'
              : 'Add root genre',
          style: TuneFonts.title3,
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: const TextStyle(color: TuneColors.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Genre name',
            hintStyle: TextStyle(color: TuneColors.textTertiary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
            onPressed: () {
              final name = ctrl.text.trim();
              if (name.isNotEmpty) {
                Navigator.pop(ctx);
                _addGenre(name, parentGenre);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addGenre(String name, String? parent) {
    if (_tree == null) return;
    final tree = Map<String, dynamic>.from(_tree!);
    if (parent == null) {
      // Add root genre
      tree[name] = <String>[];
    } else {
      // Add child to existing parent
      final existing = tree[parent];
      if (existing is List) {
        tree[parent] = [...existing, name];
      } else if (existing is Map) {
        final children = existing['children'] as List<dynamic>? ?? [];
        tree[parent] = {
          ...existing,
          'children': [...children, name],
        };
      } else {
        tree[parent] = [name];
      }
    }
    _saveTree(tree);
  }

  void _removeGenre(String name, String? parent) {
    if (_tree == null) return;
    final tree = Map<String, dynamic>.from(_tree!);
    if (parent == null) {
      tree.remove(name);
    } else {
      final existing = tree[parent];
      if (existing is List) {
        tree[parent] = existing.where((e) => e != name).toList();
      } else if (existing is Map) {
        final children = existing['children'] as List<dynamic>? ?? [];
        tree[parent] = {
          ...existing,
          'children': children.where((e) => e != name).toList(),
        };
      }
    }
    _saveTree(tree);
  }
}

// ---------------------------------------------------------------------------
// _GenreNode — recursive expandable genre node
// ---------------------------------------------------------------------------

class _GenreNode extends StatefulWidget {
  final String name;
  final dynamic value;
  final int depth;
  final VoidCallback onDelete;
  final VoidCallback onAddChild;

  const _GenreNode({
    required this.name,
    required this.value,
    required this.depth,
    required this.onDelete,
    required this.onAddChild,
  });

  @override
  State<_GenreNode> createState() => _GenreNodeState();
}

class _GenreNodeState extends State<_GenreNode> {
  bool _expanded = false;

  List<String> get _children {
    final v = widget.value;
    if (v is List) return v.map((e) => e.toString()).toList();
    if (v is Map) {
      final c = v['children'];
      if (c is List) return c.map((e) => e.toString()).toList();
    }
    return [];
  }

  bool get _hasChildren => _children.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final indent = 16.0 + widget.depth * 24.0;

    return Column(
      children: [
        Container(
          color: widget.depth == 0
              ? TuneColors.surface
              : TuneColors.surface.withValues(alpha: 0.5),
          child: ListTile(
            contentPadding:
                EdgeInsets.only(left: indent, right: 8),
            leading: _hasChildren
                ? GestureDetector(
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: Icon(
                      _expanded
                          ? Icons.expand_more_rounded
                          : Icons.chevron_right_rounded,
                      color: TuneColors.accent,
                      size: 24,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: TuneColors.accent.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
            title: Text(
              widget.name,
              style: TuneFonts.body.copyWith(
                fontWeight: widget.depth == 0
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
            subtitle: _hasChildren
                ? Text(
                    '${_children.length} sub-genre${_children.length > 1 ? "s" : ""}',
                    style: TuneFonts.caption,
                  )
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.add_rounded,
                      size: 20, color: TuneColors.accent),
                  tooltip: 'Add sub-genre',
                  onPressed: widget.onAddChild,
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline_rounded,
                      size: 20, color: TuneColors.error),
                  tooltip: 'Remove',
                  onPressed: () => _confirmDelete(context),
                ),
              ],
            ),
            onTap: _hasChildren
                ? () => setState(() => _expanded = !_expanded)
                : null,
          ),
        ),
        if (widget.depth == 0)
          const Divider(height: 1, indent: 16, color: TuneColors.divider),
        if (_expanded)
          ..._children.map((child) => _GenreNode(
                name: child,
                value: const <String>[],
                depth: widget.depth + 1,
                onDelete: () {
                  // This is a leaf deletion -- parent handles it
                  widget.onDelete();
                },
                onAddChild: widget.onAddChild,
              )),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text('Remove "${widget.name}"?', style: TuneFonts.title3),
        content: Text(
          _hasChildren
              ? 'This will also remove all ${_children.length} sub-genres.'
              : 'This genre will be removed from the tree.',
          style: TuneFonts.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onDelete();
            },
            child: const Text('Remove',
                style: TextStyle(color: TuneColors.error)),
          ),
        ],
      ),
    );
  }
}
