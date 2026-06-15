import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    setState(() => _error = null);
    try {
      final data = await api.addMusicDir(result);
      final dirs = data['dirs'] as List<dynamic>? ?? [];
      if (mounted) {
        setState(() => _musicDirs = dirs.map((d) => d.toString()).toList());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dossier ajoute: $result'),
            backgroundColor: TuneColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: TuneColors.error,
          ),
        );
      }
    }
  }

  Future<void> _removeMusicDir(String path) async {
    final api = _api;
    if (api == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: const Text('Supprimer ce dossier ?', style: TuneFonts.title3),
        content: Text(path, style: TuneFonts.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer',
                style: TextStyle(color: TuneColors.error)),
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
          SnackBar(content: Text('Erreur: $e'), backgroundColor: TuneColors.error),
        );
      }
    }
  }

  Future<void> _scanPath(String path) async {
    final api = _api;
    if (api == null) return;
    setState(() => _scanning = true);
    try {
      await api.triggerScan(path: path);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scan lance: $path'),
            backgroundColor: TuneColors.accent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: TuneColors.error),
        );
      }
    }
    if (mounted) setState(() => _scanning = false);
  }

  Future<void> _scanAll() async {
    final api = _api;
    if (api == null) return;
    setState(() => _scanning = true);
    try {
      await api.triggerScan();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Scan complet lance'),
            backgroundColor: TuneColors.accent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: TuneColors.error),
        );
      }
    }
    if (mounted) setState(() => _scanning = false);
  }

  Future<void> _restartServer() async {
    final api = _api;
    if (api == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: const Text('Redemarrer le serveur ?', style: TuneFonts.title3),
        content: Text(
          'Le serveur sera arrete puis relance. La lecture en cours sera interrompue.',
          style: TuneFonts.body.copyWith(color: TuneColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Redemarrer',
                style: TextStyle(color: TuneColors.error)),
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
          const SnackBar(
            content: Text('Serveur en cours de redemarrage...'),
            backgroundColor: TuneColors.accent,
          ),
        );
      }
    } catch (e) {
      // Connection error is expected after restart
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Redemarrage en cours...'),
            backgroundColor: TuneColors.accent,
          ),
        );
      }
    }
    if (mounted) setState(() => _restarting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Configuration serveur', style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: TuneColors.textSecondary),
            tooltip: 'Recharger',
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
                      Text('Erreur de chargement',
                          style: TuneFonts.body.copyWith(color: TuneColors.textSecondary)),
                      const SizedBox(height: 8),
                      Text(_error!, style: TuneFonts.caption.copyWith(color: TuneColors.error)),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _loadData,
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('Reessayer'),
                        style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.only(bottom: 80),
                  children: [
                    // ---- Music Directories ----
                    _buildMusicDirsSection(),

                    // ---- Server Info ----
                    _buildServerInfoSection(),

                    // ---- Actions ----
                    _buildActionsSection(),
                  ],
                ),
    );
  }

  Widget _buildMusicDirsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader('DOSSIERS MUSICAUX'),
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
                        'Aucun dossier configure',
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
                              tooltip: 'Scanner ce dossier',
                              onPressed: _scanning ? null : () => _scanPath(dir),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded,
                                  size: 20, color: TuneColors.error),
                              tooltip: 'Supprimer',
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
                title: Text('Ajouter un dossier',
                    style: TuneFonts.body.copyWith(color: TuneColors.accent)),
                onTap: _addMusicDir,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServerInfoSection() {
    final version = _config['server_version'] ?? '—';
    final engine = _config['server_engine'] ?? '—';
    final port = _config['api_port'] ?? _config['stream_port'] ?? '—';
    final dbEngine = _config['db_engine'] ?? 'sqlite';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader('INFORMATIONS SERVEUR'),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: [
              _InfoTile(label: 'Version', value: 'v$version'),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _InfoTile(label: 'Moteur', value: engine.toString()),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _InfoTile(label: 'Port', value: port.toString()),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _InfoTile(label: 'Base de donnees', value: dbEngine.toString()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader('ACTIONS'),
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
                title: Text('Scanner la bibliotheque', style: TuneFonts.body),
                subtitle: Text(
                  'Analyse tous les dossiers configures',
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
                title: Text('Redemarrer le serveur', style: TuneFonts.body),
                subtitle: Text(
                  'Arrete et relance le processus serveur',
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
    return AlertDialog(
      backgroundColor: TuneColors.surface,
      title: const Text('Ajouter un dossier', style: TuneFonts.title3),
      content: SizedBox(
        width: 360,
        child: _browsing ? _buildBrowser() : _buildPathInput(),
      ),
      actions: _browsing
          ? [
              TextButton(
                onPressed: () => setState(() => _browsing = false),
                child: const Text('Saisie manuelle'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, _currentPath),
                child: Text('Selectionner "$_currentPath"',
                    style: const TextStyle(color: TuneColors.accent),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
            ]
          : [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: _startBrowse,
                child: const Text('Parcourir...'),
              ),
              TextButton(
                onPressed: _pathCtrl.text.trim().isEmpty
                    ? null
                    : () => Navigator.pop(context, _pathCtrl.text.trim()),
                child: const Text('Ajouter',
                    style: TextStyle(color: TuneColors.accent)),
              ),
            ],
    );
  }

  Widget _buildPathInput() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _pathCtrl,
          autofocus: true,
          style: TuneFonts.body,
          decoration: const InputDecoration(
            labelText: 'Chemin du dossier',
            hintText: '/chemin/vers/musique',
            hintStyle: TextStyle(color: TuneColors.textTertiary),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        Text(
          'Entrez le chemin absolu du dossier sur le serveur.',
          style: TuneFonts.caption.copyWith(color: TuneColors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildBrowser() {
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
                      'Aucun sous-dossier',
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
