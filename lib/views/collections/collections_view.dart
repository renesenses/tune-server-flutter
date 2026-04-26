import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/domain_models.dart';
import '../../state/app_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// CollectionsView — List of user collections with CRUD
// v0.7.13
// ---------------------------------------------------------------------------

class CollectionsView extends StatefulWidget {
  const CollectionsView({super.key});

  @override
  State<CollectionsView> createState() => _CollectionsViewState();
}

class _CollectionsViewState extends State<CollectionsView> {
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
      if (mounted) setState(() { _loading = false; _error = 'Not connected'; });
      return;
    }
    try {
      final data = await app.apiClient!.getCollections();
      if (mounted) setState(() { _collections = data; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = 'Failed to load collections'; });
    }
  }

  Future<void> _createCollection() async {
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          backgroundColor: TuneColors.surface,
          title: Text('New Collection', style: TuneFonts.title3),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: TuneFonts.body,
            decoration: const InputDecoration(
              hintText: 'Collection name',
              hintStyle: TextStyle(color: TuneColors.textTertiary),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
              child: const Text('Create'),
            ),
          ],
        );
      },
    );

    if (name == null || name.isEmpty) return;
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    try {
      await app.apiClient!.createCollection(name);
      _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Create error: $e')),
        );
      }
    }
  }

  Future<void> _deleteCollection(int id) async {
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    try {
      await app.apiClient!.deleteCollection(id);
      _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text('Collections', style: TuneFonts.title2),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TuneColors.accent,
        onPressed: _createCollection,
        child: const Icon(Icons.add_rounded),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: TuneFonts.subheadline))
              : _collections == null || _collections!.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.collections_bookmark_outlined,
                              size: 56, color: TuneColors.textTertiary),
                          const SizedBox(height: 12),
                          Text('No collections yet',
                              style: TuneFonts.subheadline),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _collections!.length,
                      separatorBuilder: (_, __) => const Divider(
                          height: 1,
                          color: TuneColors.divider,
                          indent: 56),
                      itemBuilder: (_, i) {
                        final col =
                            _collections![i] as Map<String, dynamic>;
                        final name = col['name'] as String? ?? '';
                        final colorHex =
                            col['color'] as String? ?? '#6366f1';
                        final colId = col['id'] as int;
                        final albumCount =
                            (col['album_count'] as num?)?.toInt() ?? 0;
                        final color = Color(int.parse(
                            colorHex.replaceFirst('#', '0xFF')));

                        return Dismissible(
                          key: ValueKey(colId),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: TuneColors.error,
                            alignment: Alignment.centerRight,
                            padding:
                                const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.delete_rounded,
                                color: Colors.white),
                          ),
                          confirmDismiss: (_) async {
                            return await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: TuneColors.surface,
                                title: const Text('Delete collection?'),
                                content: Text(
                                    'This will delete "$name" permanently.'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(ctx, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(ctx, true),
                                    child: const Text('Delete',
                                        style: TextStyle(
                                            color: TuneColors.error)),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDismissed: (_) =>
                              _deleteCollection(colId),
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.15),
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(name,
                                style: TuneFonts.body),
                            subtitle: Text(
                              '$albumCount album${albumCount != 1 ? "s" : ""}',
                              style: TuneFonts.caption,
                            ),
                            trailing: const Icon(
                                Icons.chevron_right_rounded,
                                color: TuneColors.textTertiary),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    _CollectionDetailView(
                                  collectionId: colId,
                                  name: name,
                                  color: color,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}

// ---------------------------------------------------------------------------
// Collection Detail — album grid
// ---------------------------------------------------------------------------

class _CollectionDetailView extends StatefulWidget {
  final int collectionId;
  final String name;
  final Color color;

  const _CollectionDetailView({
    required this.collectionId,
    required this.name,
    required this.color,
  });

  @override
  State<_CollectionDetailView> createState() =>
      _CollectionDetailViewState();
}

class _CollectionDetailViewState
    extends State<_CollectionDetailView> {
  List<dynamic>? _albums;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    try {
      final data =
          await app.apiClient!.getCollectionAlbums(widget.collectionId);
      if (mounted) setState(() { _albums = data; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(widget.name, style: TuneFonts.title3),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _albums == null || _albums!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.album_outlined,
                          size: 56,
                          color: widget.color.withValues(alpha: 0.5)),
                      const SizedBox(height: 12),
                      Text('No albums in this collection',
                          style: TuneFonts.subheadline),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: _albums!.length,
                  itemBuilder: (_, i) {
                    final item =
                        _albums![i] as Map<String, dynamic>;
                    final title =
                        item['title'] as String? ?? '';
                    final artist =
                        item['artist_name'] as String? ?? '';
                    final coverPath =
                        item['cover_path'] as String?;
                    final albumId = item['id'] as int?;

                    return GestureDetector(
                      onTap: () {
                        if (albumId != null &&
                            app.apiClient != null) {
                          app.apiClient!
                              .getAlbumTracks(albumId)
                              .then((data) {
                            final tracks = data
                                .map((t) => trackFromJson(
                                    t as Map<String, dynamic>))
                                .toList();
                            if (tracks.isNotEmpty) {
                              app.playTracks(tracks);
                            }
                          }).catchError((_) {});
                        }
                      },
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: LayoutBuilder(
                              builder: (_, c) => ArtworkView(
                                filePath: coverPath,
                                size: c.maxWidth,
                                cornerRadius: 8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(title,
                              style: TuneFonts.callout,
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis),
                          Text(artist,
                              style: TuneFonts.footnote,
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
