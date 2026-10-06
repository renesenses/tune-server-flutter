// ignore_for_file: invalid_use_of_protected_member

part of 'metadata_view.dart';

// Extension _MetadataViewState — actions :
// - _runAction : wrapper avec loading state + snackbar (utilisé par
//   tous les boutons de la section Enrichir)
// - Inline edit (start/cancel/save + writeAlbumTags)
// - Cover upload via FilePicker
// - Merge duplicate group (confirm dialog + api.mergeAlbums)
// - Cover URL helper (résout cover_path → URL artwork)
// - Actions « historiques » : addFolder, confirmCleanup, confirmClear,
//   formatBytes, formatDate

extension _MetadataViewStateActions on _MetadataViewState {

  // ---------------------------------------------------------------------------
  // Run a metadata action with loading state + snackbar result
  // ---------------------------------------------------------------------------

  Future<void> _runAction(
    String key,
    String label,
    Future<Map<String, dynamic>> Function() action,
  ) async {
    if (_actionLoading[key] == true) return;
    setState(() => _actionLoading[key] = true);
    try {
      final result = await action();
      if (mounted) {
        final msg = _formatResult(label, result);
        setState(() => _statusMessage = msg);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: TuneColors.surfaceHigh,
          ),
        );
        _loadCompleteness();
        _loadSuggestionsCount();
        _loadAlbums();
      }
    } catch (e) {
      if (mounted) {
        final msg = AppLocalizations.of(context)
            .cfgMetaActionError(label, e.toString());
        setState(() => _statusMessage = msg);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: TuneColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _actionLoading[key] = false);
    }
  }

  String _formatResult(String label, Map<String, dynamic> result) {
    final l = AppLocalizations.of(context);
    final fixed = result['fixed'] ?? result['updated'] ?? result['merged'];
    final total = result['total'] ?? result['scanned'];
    final accepted = result['accepted'];
    if (accepted != null) return l.cfgMetaResultAccepted(label, '$accepted');
    if (fixed != null && total != null) return l.cfgMetaResultFixedOfTotal(label, '$fixed', '$total');
    if (fixed != null) return l.cfgMetaResultFixed(label, '$fixed');
    if (total != null) return l.cfgMetaResultProcessed(label, '$total');
    return l.cfgMetaResultDone(label);
  }

  // ---------------------------------------------------------------------------
  // Inline edit actions
  // ---------------------------------------------------------------------------

  void _startEdit(Map<String, dynamic> album) {
    setState(() {
      _editingAlbumId = album['id'] as int;
      _editArtist.text = album['artist_name'] ?? '';
      _editTitle.text = album['title'] ?? '';
      _editGenre.text = album['genre'] ?? '';
      _editYear.text =
          (album['year'] != null && album['year'] != 0) ? '${album['year']}' : '';
      _savedAlbumId = null;
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingAlbumId = null;
      _savedAlbumId = null;
    });
  }

  Future<void> _saveEdit() async {
    if (_editingAlbumId == null) return;
    final api = context.read<AppState>().apiClient;
    if (api == null) return;

    final albumId = _editingAlbumId!;
    final updates = <String, dynamic>{};

    // Find the current album
    final album = _allAlbums.firstWhere(
      (a) => a['id'] == albumId,
      orElse: () => _doubtfulAlbums.firstWhere(
        (a) => a['id'] == albumId,
        orElse: () => <String, dynamic>{},
      ),
    );
    if (album.isEmpty) return;

    if (_editArtist.text != (album['artist_name'] ?? '')) {
      updates['artist_name'] = _editArtist.text;
    }
    if (_editTitle.text != (album['title'] ?? '')) {
      updates['title'] = _editTitle.text;
    }
    if (_editGenre.text != (album['genre'] ?? '')) {
      updates['genre'] = _editGenre.text;
    }
    final newYear = _editYear.text.isNotEmpty ? int.tryParse(_editYear.text) : null;
    if (newYear != album['year']) {
      updates['year'] = newYear;
    }

    if (updates.isNotEmpty) {
      try {
        await api.updateAlbumMetadata(albumId, updates);
        // Update local state
        setState(() {
          _allAlbums = _allAlbums.map((a) {
            if (a['id'] == albumId) {
              return {...a, ...updates};
            }
            return a;
          }).toList();
          _doubtfulAlbums = _doubtfulAlbums.map((a) {
            if (a['id'] == albumId) {
              return {...a, ...updates};
            }
            return a;
          }).toList();
          _savedAlbumId = albumId;
        });
        _loadCompleteness();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).metadataAlbumSaved),
              backgroundColor: TuneColors.surfaceHigh,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).errorWith(e.toString())),
              backgroundColor: TuneColors.error,
            ),
          );
        }
      }
    } else {
      setState(() => _editingAlbumId = null);
    }
  }

  Future<void> _writeAlbumTags(int albumId) async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    try {
      final r = await api.writeAlbumTags(albumId);
      final count = r['updated'] ?? r['tracks_processed'] ?? 0;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                .metadataWriteTagsSuccess(int.tryParse('$count') ?? 0)),
            backgroundColor: TuneColors.surfaceHigh,
          ),
        );
        setState(() {
          _editingAlbumId = null;
          _savedAlbumId = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                .cfgMetaWriteTagsError(e.toString())),
            backgroundColor: TuneColors.error,
          ),
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Cover upload
  // ---------------------------------------------------------------------------

  Future<void> _uploadCover(int albumId) async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;
    final path = result.files.first.path;
    if (path == null) return;

    try {
      final updated = await api.uploadAlbumArtwork(albumId, path);
      final coverPath = updated['cover_path'];
      setState(() {
        _allAlbums = _allAlbums.map((a) {
          if (a['id'] == albumId) return {...a, 'cover_path': coverPath};
          return a;
        }).toList();
        _doubtfulAlbums = _doubtfulAlbums.map((a) {
          if (a['id'] == albumId) return {...a, 'cover_path': coverPath};
          return a;
        }).toList();
        _savedAlbumId = albumId;
        if (_editingAlbumId == null) _startEdit(_allAlbums.firstWhere((a) => a['id'] == albumId, orElse: () => <String, dynamic>{}));
      });
      _loadCompleteness();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).metadataCoverUploaded),
            backgroundColor: TuneColors.surfaceHigh,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                .cfgMetaUploadError(e.toString())),
            backgroundColor: TuneColors.error,
          ),
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Merge duplicate group
  // ---------------------------------------------------------------------------

  Future<void> _mergeGroup(List<Map<String, dynamic>> group) async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;

    final ids = group.map((a) => a['id'] as int).toList();
    final l = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.cfgMetaMergeTitle(group.length),
            style: TuneFonts.title3),
        content: Text(
          l.cfgMetaMergeBody,
          style: TuneFonts.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.btnCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.metadataMergeGroup,
                style: const TextStyle(color: TuneColors.warning)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      final result = await api.mergeAlbums(ids);
      final masterId = result['master_id'];
      final mergedIds = ids.where((id) => id != masterId).toSet();
      setState(() {
        _allAlbums = _allAlbums.where((a) => !mergedIds.contains(a['id'])).toList();
        _allAlbums = _allAlbums.map((a) {
          if (a['id'] == masterId) {
            return {...a, 'track_count': result['total_tracks']};
          }
          return a;
        }).toList();
        _computeDuplicateGroups();
      });
      _loadCompleteness();
      if (mounted) {
        final moved = result['tracks_moved'] ?? 0;
        final total = result['total_tracks'] ?? 0;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.metadataMergeSuccess(
                int.tryParse('$moved') ?? 0, int.tryParse('$total') ?? 0)),
            backgroundColor: TuneColors.surfaceHigh,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.cfgMetaMergeError(e.toString())),
            backgroundColor: TuneColors.error,
          ),
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Cover URL helper
  // ---------------------------------------------------------------------------

  String? _coverUrl(Map<String, dynamic> album) {
    final api = context.read<AppState>().apiClient;
    if (api == null) return null;
    final cover = album['cover_path']?.toString() ?? '';
    if (cover.isEmpty) return null;
    return api.artworkUrl(cover);
  }

  // ---------------------------------------------------------------------------
  // Actions (existing, preserved)
  // ---------------------------------------------------------------------------

  Future<void> _addFolder(BuildContext context, AppState app) async {
    final l = AppLocalizations.of(context);
    final ctrl = TextEditingController();

    final picked = await FilePicker.platform.getDirectoryPath();
    if (picked != null) {
      ctrl.text = picked;
    }

    if (!mounted) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.metadataAddFolder, style: TuneFonts.title3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ctrl,
              style: TuneFonts.body,
              decoration: InputDecoration(
                labelText: l.metadataFolderPath,
                hintText: l.metadataFolderHint,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.folder_open_rounded, size: 16),
                label: Text(l.btnAddFolder),
                onPressed: () async {
                  final p = await FilePicker.platform.getDirectoryPath();
                  if (p != null) ctrl.text = p;
                },
              ),
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
      final path = ctrl.text.trim();
      if (path.isNotEmpty) {
        await app.addMusicFolder(path);
        await _loadFolders();
        await _loadStats();
      }
    }
  }

  Future<void> _confirmCleanup(BuildContext context, AppState app) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title:
            Text(l.metadataCleanupOrphansTitle, style: TuneFonts.title3),
        content:
            Text(l.metadataCleanupOrphansBody, style: TuneFonts.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.btnCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.metadataDeleteBtn,
                style: const TextStyle(color: TuneColors.warning)),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      await app.cleanupOrphans();
      await _loadStats();
      _loadAlbums();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context).metadataOrphansDeleted)),
        );
      }
    }
  }

  Future<void> _confirmClear(BuildContext context, AppState app) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title:
            Text(l.metadataClearLibraryTitle, style: TuneFonts.title3),
        content:
            Text(l.metadataClearLibraryBody, style: TuneFonts.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.btnCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.metadataClearBtn,
                style: const TextStyle(color: TuneColors.error)),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      await app.clearLibrary();
      await _loadStats();
      _loadAlbums();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context).metadataLibraryCleared)),
        );
      }
    }
  }

  String _formatBytes(int bytes) {
    final l = AppLocalizations.of(context);
    if (bytes < 1024) return l.cfgSizeBytes('$bytes');
    if (bytes < 1024 * 1024) {
      return l.cfgSizeKilobytes((bytes / 1024).toStringAsFixed(1));
    }
    return l.cfgSizeMegabytes((bytes / (1024 * 1024)).toStringAsFixed(1));
  }

  String _formatDate(String iso) {
    try {
      return iso.split('T').first;
    } catch (_) {
      return iso;
    }
  }
}
