import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/tune_api_client.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// DiagnosticsView
// System health, version, uptime, memory, database stats, streaming status,
// zones list, and scrollable logs viewer.
// Remote mode only (requires /api/v1/system/diagnostics + /api/v1/system/logs).
// ---------------------------------------------------------------------------

class DiagnosticsView extends StatefulWidget {
  const DiagnosticsView({super.key});

  @override
  State<DiagnosticsView> createState() => _DiagnosticsViewState();
}

class _DiagnosticsViewState extends State<DiagnosticsView> {
  Map<String, dynamic>? _diagnostics;
  List<String> _logs = [];
  bool _loadingDiag = true;
  bool _loadingLogs = true;
  String? _error;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadAll();
    // Auto-refresh every 15s
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _loadAll(silent: true),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  TuneApiClient? get _api => context.read<AppState>().apiClient;

  Future<void> _loadAll({bool silent = false}) async {
    _loadDiagnostics(silent: silent);
    _loadLogs(silent: silent);
  }

  Future<void> _loadDiagnostics({bool silent = false}) async {
    final api = _api;
    if (api == null) return;
    if (!silent) setState(() => _loadingDiag = true);
    try {
      final data = await api.getDiagnostics();
      if (mounted) setState(() { _diagnostics = data; _error = null; });
    } catch (e) {
      if (mounted && !silent) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _loadingDiag = false);
    }
  }

  Future<void> _loadLogs({bool silent = false}) async {
    final api = _api;
    if (api == null) return;
    if (!silent) setState(() => _loadingLogs = true);
    try {
      final data = await api.getSystemLogs();
      if (mounted) {
        setState(() {
          if (data is List) {
            _logs = data.map((e) => e.toString()).toList();
          } else if (data is Map && data['lines'] is List) {
            _logs = (data['lines'] as List).map((e) => e.toString()).toList();
          } else {
            _logs = [data.toString()];
          }
        });
      }
    } catch (_) {
      // Logs endpoint might not exist -- silently ignore
    } finally {
      if (mounted) setState(() => _loadingLogs = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final api = _api;

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Diagnostics', style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: TuneColors.textSecondary),
            tooltip: 'Rafraichir',
            onPressed: () => _loadAll(),
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
                      'Diagnostics requires a remote server connection.',
                      textAlign: TextAlign.center,
                      style: TuneFonts.body
                          .copyWith(color: TuneColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          : _loadingDiag && _diagnostics == null
              ? const Center(
                  child:
                      CircularProgressIndicator(color: TuneColors.accent))
              : _error != null && _diagnostics == null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              size: 48, color: TuneColors.error),
                          const SizedBox(height: 12),
                          Text(_error!,
                              style: TuneFonts.subheadline,
                              textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: () => _loadAll(),
                            style: FilledButton.styleFrom(
                                backgroundColor: TuneColors.accent),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _buildContent(),
    );
  }

  Widget _buildContent() {
    final diag = _diagnostics ?? {};
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSystemSection(diag),
          _buildDatabaseSection(diag),
          _buildStreamingSection(diag),
          _buildZonesSection(diag),
          _buildLogsSection(),
        ],
      ),
    );
  }

  // ---- System ----

  Widget _buildSystemSection(Map<String, dynamic> diag) {
    final system = diag['system'] as Map<String, dynamic>? ?? diag;
    final version = system['version'] ?? diag['version'] ?? '-';
    final uptime = system['uptime'] ?? diag['uptime'] ?? '-';
    final memory = system['memory'] ?? diag['memory'];
    final health = system['health'] ?? diag['health'] ?? diag['status'] ?? '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader('SYSTEM'),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: [
              _InfoTile(
                icon: Icons.verified_rounded,
                label: 'Health',
                value: health.toString(),
                valueColor: health.toString().toLowerCase() == 'ok' ||
                        health.toString().toLowerCase() == 'healthy'
                    ? TuneColors.success
                    : TuneColors.warning,
              ),
              const Divider(height: 1, indent: 56, color: TuneColors.divider),
              _InfoTile(
                icon: Icons.info_outline_rounded,
                label: 'Version',
                value: version.toString(),
              ),
              const Divider(height: 1, indent: 56, color: TuneColors.divider),
              _InfoTile(
                icon: Icons.timer_rounded,
                label: 'Uptime',
                value: _formatUptime(uptime),
              ),
              if (memory != null) ...[
                const Divider(
                    height: 1, indent: 56, color: TuneColors.divider),
                _InfoTile(
                  icon: Icons.memory_rounded,
                  label: 'Memory',
                  value: _formatMemory(memory),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ---- Database ----

  Widget _buildDatabaseSection(Map<String, dynamic> diag) {
    final db = diag['database'] as Map<String, dynamic>? ??
        diag['library'] as Map<String, dynamic>? ??
        {};
    final tracks = db['tracks'] ?? db['track_count'] ?? '-';
    final albums = db['albums'] ?? db['album_count'] ?? '-';
    final artists = db['artists'] ?? db['artist_count'] ?? '-';
    final playlists = db['playlists'] ?? db['playlist_count'];
    final radios = db['radios'] ?? db['radio_count'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader('DATABASE'),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: [
              _InfoTile(
                  icon: Icons.music_note_rounded,
                  label: 'Tracks',
                  value: '$tracks'),
              const Divider(height: 1, indent: 56, color: TuneColors.divider),
              _InfoTile(
                  icon: Icons.album_rounded,
                  label: 'Albums',
                  value: '$albums'),
              const Divider(height: 1, indent: 56, color: TuneColors.divider),
              _InfoTile(
                  icon: Icons.person_rounded,
                  label: 'Artists',
                  value: '$artists'),
              if (playlists != null) ...[
                const Divider(
                    height: 1, indent: 56, color: TuneColors.divider),
                _InfoTile(
                    icon: Icons.playlist_play_rounded,
                    label: 'Playlists',
                    value: '$playlists'),
              ],
              if (radios != null) ...[
                const Divider(
                    height: 1, indent: 56, color: TuneColors.divider),
                _InfoTile(
                    icon: Icons.radio_rounded,
                    label: 'Radios',
                    value: '$radios'),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ---- Streaming ----

  Widget _buildStreamingSection(Map<String, dynamic> diag) {
    final streaming = diag['streaming'] as Map<String, dynamic>? ?? {};
    if (streaming.isEmpty) {
      // Try top-level services
      final services = diag['services'] as Map<String, dynamic>? ?? {};
      if (services.isEmpty) return const SizedBox.shrink();
      return _buildStreamingFromMap(services);
    }
    return _buildStreamingFromMap(streaming);
  }

  Widget _buildStreamingFromMap(Map<String, dynamic> services) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader('STREAMING SERVICES'),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: services.entries.map((entry) {
              final name = entry.key;
              final value = entry.value;
              String status;
              bool connected;
              if (value is Map<String, dynamic>) {
                connected = value['authenticated'] == true ||
                    value['enabled'] == true ||
                    value['connected'] == true;
                status = connected ? 'Connected' : 'Disconnected';
              } else {
                connected = value == true ||
                    value.toString().toLowerCase() == 'connected';
                status = connected ? 'Connected' : 'Disconnected';
              }
              return Column(
                children: [
                  _InfoTile(
                    icon: Icons.cloud_rounded,
                    label: name[0].toUpperCase() + name.substring(1),
                    value: status,
                    valueColor:
                        connected ? TuneColors.success : TuneColors.textTertiary,
                  ),
                  const Divider(
                      height: 1, indent: 56, color: TuneColors.divider),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ---- Zones ----

  Widget _buildZonesSection(Map<String, dynamic> diag) {
    final zones = diag['zones'] as List<dynamic>? ?? [];
    if (zones.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader('ZONES'),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: zones.asMap().entries.map((entry) {
              final idx = entry.key;
              final z = entry.value as Map<String, dynamic>;
              final name = z['name'] ?? 'Zone ${z['id']}';
              final state = z['state'] ?? z['playback_state'] ?? z['status'] ?? '-';
              final output = z['output_type'] ?? z['output'] ?? 'local';
              return Column(
                children: [
                  if (idx > 0)
                    const Divider(
                        height: 1, indent: 56, color: TuneColors.divider),
                  ListTile(
                    leading: Icon(
                      _zoneIcon(output.toString()),
                      color: TuneColors.accent,
                    ),
                    title: Text(name.toString(), style: TuneFonts.body),
                    subtitle: Text(
                      '$output - $state',
                      style: TuneFonts.caption,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  IconData _zoneIcon(String output) {
    switch (output) {
      case 'dlna':
        return Icons.cast_rounded;
      case 'airplay':
        return Icons.airplay_rounded;
      case 'bluetooth':
        return Icons.bluetooth_rounded;
      default:
        return Icons.speaker_phone_rounded;
    }
  }

  // ---- Logs ----

  Widget _buildLogsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader('LOGS'),
        Container(
          color: TuneColors.surface,
          constraints: const BoxConstraints(maxHeight: 400),
          child: _loadingLogs && _logs.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(
                        color: TuneColors.accent),
                  ),
                )
              : _logs.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No logs available',
                        style: TuneFonts.footnote
                            .copyWith(color: TuneColors.textTertiary),
                      ),
                    )
                  : Scrollbar(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        shrinkWrap: true,
                        itemCount: _logs.length,
                        itemBuilder: (_, i) {
                          final line = _logs[i];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 1),
                            child: Text(
                              line,
                              style: const TextStyle(
                                fontSize: 11,
                                fontFamily: 'monospace',
                                color: TuneColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  // ---- Formatters ----

  String _formatUptime(dynamic uptime) {
    if (uptime is num) {
      final seconds = uptime.toInt();
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      if (hours > 0) return '${hours}h ${minutes}m';
      return '${minutes}m ${seconds % 60}s';
    }
    return uptime.toString();
  }

  String _formatMemory(dynamic memory) {
    if (memory is Map<String, dynamic>) {
      final rss = memory['rss_mb'] ?? memory['rss'];
      if (rss != null) return '${rss} MB';
      return memory.toString();
    }
    if (memory is num) {
      return '${(memory / 1048576).toStringAsFixed(1)} MB';
    }
    return memory.toString();
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
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: TuneColors.accent, size: 22),
      title: Text(label, style: TuneFonts.body),
      trailing: Text(
        value,
        style: TuneFonts.callout.copyWith(
          color: valueColor ?? TuneColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
