import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/tune_api_client.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// TagChipsWidget — displays tag chips for a track/album/artist.
// Long-press opens add/remove dialog. Requires remote API.
// Usage: TagChipsWidget(itemType: 'track', itemId: 42)
// ---------------------------------------------------------------------------

class TagChipsWidget extends StatefulWidget {
  final String itemType; // 'track', 'album', 'artist'
  final int itemId;

  const TagChipsWidget({
    super.key,
    required this.itemType,
    required this.itemId,
  });

  @override
  State<TagChipsWidget> createState() => _TagChipsWidgetState();
}

class _TagChipsWidgetState extends State<TagChipsWidget> {
  List<Map<String, dynamic>> _itemTags = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  TuneApiClient? get _api => context.read<AppState>().apiClient;

  Future<void> _loadTags() async {
    final api = _api;
    if (api == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final data = await api.getItemTags(widget.itemType, widget.itemId);
      if (mounted) {
        setState(() {
          _itemTags = data.cast<Map<String, dynamic>>();
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _removeTag(int tagId) async {
    final api = _api;
    if (api == null) return;
    try {
      await api.removeTagFromItem(tagId, widget.itemType, widget.itemId);
      await _loadTags();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: TuneColors.error),
        );
      }
    }
  }

  Future<void> _showAddTagDialog() async {
    final api = _api;
    if (api == null) return;

    List<Map<String, dynamic>> allTags = [];
    try {
      final data = await api.getTags();
      allTags = data.cast<Map<String, dynamic>>();
    } catch (_) {}

    if (!mounted) return;

    final existingIds = _itemTags.map((t) => t['id'] as int).toSet();

    await showModalBottomSheet(
      context: context,
      backgroundColor: TuneColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _TagPickerSheet(
        allTags: allTags,
        existingTagIds: existingIds,
        onAddTag: (tagId) async {
          try {
            await api.addTagToItem(tagId, widget.itemType, widget.itemId);
            await _loadTags();
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erreur: $e'), backgroundColor: TuneColors.error),
              );
            }
          }
        },
        onCreateTag: (name) async {
          try {
            final newTag = await api.createTag(name);
            final tagId = newTag['id'] as int;
            await api.addTagToItem(tagId, widget.itemType, widget.itemId);
            await _loadTags();
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erreur: $e'), backgroundColor: TuneColors.error),
              );
            }
          }
        },
        onRemoveTag: (tagId) async {
          await _removeTag(tagId);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final api = _api;
    if (api == null) return const SizedBox.shrink();

    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 1.5, color: TuneColors.accent),
        ),
      );
    }

    return GestureDetector(
      onLongPress: _showAddTagDialog,
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        children: [
          ..._itemTags.map((tag) {
            final name = tag['name'] as String? ?? '';
            final color = _parseColor(tag['color'] as String?);
            return Chip(
              label: Text(
                name,
                style: TuneFonts.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: color,
              deleteIcon: const Icon(Icons.close_rounded, size: 14, color: Colors.white70),
              onDeleted: () => _removeTag(tag['id'] as int),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 4),
            );
          }),
          ActionChip(
            label: const Icon(Icons.add_rounded, size: 14, color: TuneColors.accent),
            backgroundColor: TuneColors.accent.withValues(alpha: 0.12),
            onPressed: _showAddTagDialog,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 2),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return TuneColors.accent;
    try {
      final cleaned = hex.replaceFirst('#', '');
      return Color(int.parse('FF$cleaned', radix: 16));
    } catch (_) {
      return TuneColors.accent;
    }
  }
}

// ---------------------------------------------------------------------------
// Tag picker bottom sheet
// ---------------------------------------------------------------------------

class _TagPickerSheet extends StatefulWidget {
  final List<Map<String, dynamic>> allTags;
  final Set<int> existingTagIds;
  final Future<void> Function(int tagId) onAddTag;
  final Future<void> Function(String name) onCreateTag;
  final Future<void> Function(int tagId) onRemoveTag;

  const _TagPickerSheet({
    required this.allTags,
    required this.existingTagIds,
    required this.onAddTag,
    required this.onCreateTag,
    required this.onRemoveTag,
  });

  @override
  State<_TagPickerSheet> createState() => _TagPickerSheetState();
}

class _TagPickerSheetState extends State<_TagPickerSheet> {
  late Set<int> _selected;
  final _newTagCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = Set<int>.from(widget.existingTagIds);
  }

  @override
  void dispose() {
    _newTagCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.label_rounded, color: TuneColors.accent),
              const SizedBox(width: 10),
              Text('Tags', style: TuneFonts.title3),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: TuneColors.textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Existing tags
          if (widget.allTags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: widget.allTags.map((tag) {
                final id = tag['id'] as int;
                final name = tag['name'] as String? ?? '';
                final isSelected = _selected.contains(id);
                return FilterChip(
                  label: Text(name),
                  selected: isSelected,
                  selectedColor: TuneColors.accent,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : TuneColors.textPrimary,
                  ),
                  onSelected: (selected) async {
                    if (selected) {
                      await widget.onAddTag(id);
                      setState(() => _selected.add(id));
                    } else {
                      await widget.onRemoveTag(id);
                      setState(() => _selected.remove(id));
                    }
                  },
                );
              }).toList(),
            ),

          const SizedBox(height: 16),

          // Create new tag
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newTagCtrl,
                  style: TuneFonts.body,
                  decoration: InputDecoration(
                    hintText: 'Nouveau tag...',
                    hintStyle: TuneFonts.body.copyWith(color: TuneColors.textTertiary),
                    filled: true,
                    fillColor: TuneColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: TuneColors.divider),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () async {
                  final name = _newTagCtrl.text.trim();
                  if (name.isEmpty) return;
                  await widget.onCreateTag(name);
                  _newTagCtrl.clear();
                  if (mounted) Navigator.pop(context);
                },
                style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
                child: const Text('Creer'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
