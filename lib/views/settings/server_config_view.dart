import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../services/tune_api_client.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// ServerConfigView — Server Configuration
//
// Mirrors the web client's Settings → Music Directories + Restart.
// API: GET/POST /system/music-dirs, POST /system/music-dirs/remove,
//      GET /system/config, POST /system/restart, POST /system/scan
// ---------------------------------------------------------------------------

class ServerConfigView extends StatefulWidget {
  const ServerConfigView({super.key});

  @override
  State<ServerConfigView> createState() => _ServerConfigViewState();
}

class _ServerConfigViewState extends State<ServerConfigView> {
  List<String> _musicDirs = [];
  Map<String, dynamic> _config = {};
  bool _loading = true;
  bool _restarting = false;
  bool _scanning = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  TuneApiClient? get _api => context.read<AppState>().apiClient;

  Future<void> _loadData() async {
    final api = _api;
    if (api == null) return;
    setState(() { _loading = true; _error = null; });
    try {
      final results = await Future.wait([
        api.getMusicDirs(),
        api.getSystemConfig(),
      ]);
      if (mounted) {
        final dirsData = results[0];
        final dirs = dirsData['dirs'] as List<dynamic>? ?? [];
        setState(() {
          _musicDirs = dirs.map((d) => d.toString()).toList();
          _config = results[1];
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() { _loading = false; _error = e.toString(); });
      }
    }
  }

  Future<void> _addMusicDir() async {
    final api = _api;
    if (api == null) return;

    // Show a dialog to either type a path or browse directories
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => _AddMusicDirDialog(api: api),
    );
    if (result == null || result.isEmpty) return;
    if (!mounted) return;
    final l = AppLocalizations.of(context);

    setState(() => _error = null);
    try {
      final data = await api.addMusicDir(result);
      final dirs = data['dirs'] as List<dynamic>? ?? [];
      if (mounted) {
        setState(() => _musicDirs = dirs.map((d) => d.toString()).toList());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.srvFolderAdded(result)),
            backgroundColor: TuneColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.errorWith(e.toString())),
            backgroundColor: TuneColors.error,
          ),
        );
      }
    }
  }

  Future<void> _removeMusicDir(String path) async {
    final api = _api;
    if (api == null) return;
    final l = AppLocalizations.of(context);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.srvRemoveFolderTitle, style: TuneFonts.title3),
        content: Text(path, style: TuneFonts.body),
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
    );
    if (confirm != true) return;

    try {
      final data = await api.removeMusicDir(path);
      final dirs = data['dirs'] as List<dynamic>? ?? [];
      if (mounted) {
        setState(() => _musicDirs = dirs.map((d) => d.toString()).toList());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.errorWith(e.toString())), backgroundColor: TuneColors.error),
        );
      }
    }
  }

  Future<void> _scanPath(String path) async {
    final api = _api;
    if (api == null) return;
    final l = AppLocalizations.of(context);
    setState(() => _scanning = true);
    try {
      await api.triggerScan(path: path);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.srvScanStarted(path)),
            backgroundColor: TuneColors.accent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.errorWith(e.toString())), backgroundColor: TuneColors.error),
        );
      }
    }
    if (mounted) setState(() => _scanning = false);
  }

  Future<void> _scanAll() async {
    final api = _api;
    if (api == null) return;
    final l = AppLocalizations.of(context);
    setState(() => _scanning = true);
    try {
      await api.triggerScan();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.srvFullScanStarted),
            backgroundColor: TuneColors.accent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.errorWith(e.toString())), backgroundColor: TuneColors.error),
        );
      }
    }
    if (mounted) setState(() => _scanning = false);
  }

  Future<void> _restartServer() async {
    final api = _api;
    if (api == null) return;
    final l = AppLocalizations.of(context);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.srvRestartTitle, style: TuneFonts.title3),
        content: Text(
          l.srvRestartBody,
          style: TuneFonts.body.copyWith(color: TuneColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.btnCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.srvRestartBtn,
                style: const TextStyle(color: TuneColors.error)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _restarting = true);
    try {
      await api.restartServer();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.srvRestarting),
            backgroundColor: TuneColors.accent,
          ),
        );
      }
    } catch (e) {
      // Connection error is expected after restart
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.srvRestartInProgress),
            backgroundColor: TuneColors.accent,
          ),
        );
      }
    }
    if (mounted) setState(() => _restarting = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(l.srvConfigTitle, style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: TuneColors.textSecondary),
            tooltip: l.btnRefresh,
            onPressed: _loadData,
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: TuneColors.accent),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          size: 48, color: TuneColors.error),
                      const SizedBox(height: 12),
                      Text(l.srvLoadError,
                          style: TuneFonts.body.copyWith(color: TuneColors.textSecondary)),
                      const SizedBox(height: 8),
                      Text(_error!, style: TuneFonts.caption.copyWith(color: TuneColors.error)),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _loadData,
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: Text(l.btnRetry),
                        style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.only(bottom: 80),
                  children: [
                    // ---- Music Directories ----
                    _buildMusicDirsSection(l),

                    // ---- Server Info ----
                    _buildServerInfoSection(l),

                    // ---- Actions ----
                    _buildActionsSection(l),
                  ],
                ),
    );
  }

  Widget _buildMusicDirsSection(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(l.metadataSectionFolders),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: [
              if (_musicDirs.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(Icons.folder_off_rounded,
                          size: 40, color: TuneColors.textTertiary),
                      const SizedBox(height: 8),
                      Text(
                        l.metadataFoldersNone,
                        style: TuneFonts.body.copyWith(color: TuneColors.textSecondary),
                      ),
                    ],
                  ),
                )
              else
                ...List.generate(_musicDirs.length, (i) {
                  final dir = _musicDirs[i];
                  return Column(
                    children: [
                      if (i > 0)
                        const Divider(height: 1, indent: 56, color: TuneColors.divider),
                      ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: TuneColors.accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.folder_rounded,
                              color: TuneColors.accent, size: 22),
                        ),
                        title: Text(
                          dir.split('/').last.isNotEmpty ? dir.split('/').last : dir,
                          style: TuneFonts.body,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          dir,
                          style: TuneFonts.caption.copyWith(color: TuneColors.textTertiary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.refresh_rounded,
                                size: 20,
                                color: _scanning
                                    ? TuneColors.textTertiary
                                    : TuneColors.accent,
                              ),
                              tooltip: l.srvScanFolderTooltip,
                              onPressed: _scanning ? null : () => _scanPath(dir),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded,
                                  size: 20, color: TuneColors.error),
                              tooltip: l.btnDelete,
                              onPressed: _musicDirs.length <= 1
                                  ? null
                                  : () => _removeMusicDir(dir),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              ListTile(
                leading: const Icon(Icons.add_rounded, color: TuneColors.accent),
                title: Text(l.btnAddFolder,
                    style: TuneFonts.body.copyWith(color: TuneColors.accent)),
                onTap: _addMusicDir,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServerInfoSection(AppLocalizations l) {
    final version = _config['server_version'] ?? '—';
    final engine = _config['server_engine'] ?? '—';
    final port = _config['api_port'] ?? _config['stream_port'] ?? '—';
    final dbEngine = _config['db_engine'] ?? 'sqlite';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(l.srvSectionServerInfo),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: [
              _InfoTile(label: l.srvInfoVersion, value: 'v$version'),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _InfoTile(label: l.srvInfoEngine, value: engine.toString()),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _InfoTile(label: l.port, value: port.toString()),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _InfoTile(label: l.srvInfoDatabase, value: dbEngine.toString()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(l.srvSectionActions),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: [
              // Scan all
              ListTile(
                leading: Icon(
                  Icons.radar_rounded,
                  color: _scanning ? TuneColors.textTertiary : TuneColors.accent,
                ),
                title: Text(l.metadataScanBtn, style: TuneFonts.body),
                subtitle: Text(
                  l.metadataScanDesc,
                  style: TuneFonts.footnote.copyWith(color: TuneColors.textSecondary),
                ),
                trailing: _scanning
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2, color: TuneColors.accent),
                      )
                    : const Icon(Icons.chevron_right_rounded,
                        color: TuneColors.textTertiary),
                onTap: _scanning ? null : _scanAll,
              ),
              const Divider(height: 1, indent: 56, color: TuneColors.divider),
              // Restart
              ListTile(
                leading: Icon(
                  Icons.restart_alt_rounded,
                  color: _restarting ? TuneColors.textTertiary : TuneColors.warning,
                ),
                title: Text(l.srvRestartServer, style: TuneFonts.body),
                subtitle: Text(
                  l.srvRestartServerDesc,
                  style: TuneFonts.footnote.copyWith(color: TuneColors.textSecondary),
                ),
                trailing: _restarting
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2, color: TuneColors.warning),
                      )
                    : const Icon(Icons.chevron_right_rounded,
                        color: TuneColors.textTertiary),
                onTap: _restarting ? null : _restartServer,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Add Music Dir dialog — type path or browse server filesystem
// ---------------------------------------------------------------------------

class _AddMusicDirDialog extends StatefulWidget {
  final TuneApiClient api;
  const _AddMusicDirDialog({required this.api});

  @override
  State<_AddMusicDirDialog> createState() => _AddMusicDirDialogState();
}

class _AddMusicDirDialogState extends State<_AddMusicDirDialog> {
  final _pathCtrl = TextEditingController();
  bool _browsing = false;
  bool _browseLoading = false;
  String _currentPath = '/';
  String? _parentPath;
  List<Map<String, dynamic>> _browseDirs = [];

  Future<void> _startBrowse() async {
    setState(() { _browsing = true; _browseLoading = true; });
    await _loadBrowseDirs('/');
  }

  Future<void> _loadBrowseDirs(String path) async {
    setState(() => _browseLoading = true);
    try {
      final data = await widget.api.browseDirs(path: path);
      if (mounted) {
        final dirs = (data['dirs'] as List<dynamic>?)
            ?.map((d) => d as Map<String, dynamic>)
            .toList() ?? [];
        setState(() {
          _currentPath = data['current'] as String? ?? path;
          _parentPath = data['parent'] as String?;
          _browseDirs = dirs;
          _browseLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _browseLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      backgroundColor: TuneColors.surface,
      title: Text(l.btnAddFolder, style: TuneFonts.title3),
      content: SizedBox(
        width: 360,
        child: _browsing ? _buildBrowser(l) : _buildPathInput(l),
      ),
      actions: _browsing
          ? [
              TextButton(
                onPressed: () => setState(() => _browsing = false),
                child: Text(l.srvManualEntry),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, _currentPath),
                child: Text(l.srvSelectPath(_currentPath),
                    style: const TextStyle(color: TuneColors.accent),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
            ]
          : [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: Text(l.btnCancel),
              ),
              TextButton(
                onPressed: _startBrowse,
                child: Text(l.srvBrowse),
              ),
              TextButton(
                onPressed: _pathCtrl.text.trim().isEmpty
                    ? null
                    : () => Navigator.pop(context, _pathCtrl.text.trim()),
                child: Text(l.btnAdd,
                    style: const TextStyle(color: TuneColors.accent)),
              ),
            ],
    );
  }

  Widget _buildPathInput(AppLocalizations l) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _pathCtrl,
          autofocus: true,
          style: TuneFonts.body,
          decoration: InputDecoration(
            labelText: l.metadataFolderPath,
            hintText: l.srvFolderPathHint,
            hintStyle: const TextStyle(color: TuneColors.textTertiary),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        Text(
          l.srvFolderPathHelp,
          style: TuneFonts.caption.copyWith(color: TuneColors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildBrowser(AppLocalizations l) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Current path
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: TuneColors.background,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            _currentPath,
            style: TuneFonts.caption.copyWith(color: TuneColors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 8),
        if (_browseLoading)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: SizedBox(
                width: 24, height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2, color: TuneColors.accent),
              ),
            ),
          )
        else
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView(
              shrinkWrap: true,
              children: [
                // Parent directory
                if (_parentPath != null)
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.arrow_upward_rounded,
                        size: 20, color: TuneColors.textSecondary),
                    title: Text('..', style: TuneFonts.body),
                    onTap: () => _loadBrowseDirs(_parentPath!),
                  ),
                // Sub-directories
                if (_browseDirs.isEmpty && _parentPath == null)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      l.srvNoSubfolders,
                      style: TuneFonts.body.copyWith(color: TuneColors.textTertiary),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  ..._browseDirs.map((dir) {
                    final name = dir['name'] as String? ?? '';
                    final path = dir['path'] as String? ?? '';
                    final hasChildren = dir['has_children'] as bool? ?? false;
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        hasChildren ? Icons.folder_rounded : Icons.folder_outlined,
                        size: 20,
                        color: TuneColors.accent,
                      ),
                      title: Text(name, style: TuneFonts.body, maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      trailing: hasChildren
                          ? const Icon(Icons.chevron_right_rounded,
                              size: 18, color: TuneColors.textTertiary)
                          : null,
                      onTap: () => _loadBrowseDirs(path),
                    );
                  }),
              ],
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _pathCtrl.dispose();
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// Shared widgets
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        title.toUpperCase(),
        style: TuneFonts.footnote.copyWith(
          color: TuneColors.textTertiary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: TuneColors.surface,
      title: Text(label, style: TuneFonts.body),
      trailing: Text(
        value,
        style: TuneFonts.body.copyWith(color: TuneColors.textSecondary),
      ),
    );
  }
}
