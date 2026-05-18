import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/tune_api_client.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// AdminDashboardView — CPU/RAM/disk/uptime, zones status, recent errors,
// discovery devices. Auto-refreshes every 5s. Remote mode only.
// ---------------------------------------------------------------------------

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  Map<String, dynamic>? _health;
  List<dynamic> _zones = [];
  List<dynamic> _errors = [];
  List<dynamic> _discovery = [];
  bool _loading = true;
  String? _error;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadAll();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 5),
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
    final api = _api;
    if (api == null) {
      if (!silent) {
        setState(() {
          _error = 'Non connecte a un serveur distant';
          _loading = false;
        });
      }
      return;
    }
    if (!silent) setState(() => _loading = true);

    try {
      final results = await Future.wait([
        api.getAdminHealth().catchError((_) => <String, dynamic>{}),
        api.getAdminZones().catchError((_) => <dynamic>[]),
        api.getAdminErrors(limit: 20).catchError((_) => <dynamic>[]),
        api.getAdminDiscovery().catchError((_) => <dynamic>[]),
      ]);
      if (mounted) {
        setState(() {
          _health = results[0] as Map<String, dynamic>;
          _zones = results[1] as List<dynamic>;
          _errors = results[2] as List<dynamic>;
          _discovery = results[3] as List<dynamic>;
          _loading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted && !silent) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Admin Dashboard', style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: TuneColors.textSecondary),
            onPressed: () => _loadAll(),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading && _health == null) {
      return const Center(
        child: CircularProgressIndicator(color: TuneColors.accent),
      );
    }
    if (_error != null && _health == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: TuneColors.error),
            const SizedBox(height: 12),
            Text(_error!, style: TuneFonts.footnote, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => _loadAll(),
              style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
              child: const Text('Reessayer'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadAll(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHealthSection(),
            _buildZonesSection(),
            _buildDiscoverySection(),
            _buildErrorsSection(),
          ],
        ),
      ),
    );
  }

  // ---- Health ----

  Widget _buildHealthSection() {
    final h = _health ?? {};
    final cpu = h['cpu_percent'] ?? h['cpu'] ?? h['cpu_usage'];
    final ram = h['memory_percent'] ?? h['memory'] ?? h['ram'];
    final disk = h['disk_percent'] ?? h['disk'] ?? h['disk_usage'];
    final uptime = h['uptime'] ?? h['uptime_seconds'];
    final status = h['status'] ?? h['health'] ?? 'unknown';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader('SANTE SYSTEME'),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: [
              _InfoTile(
                icon: Icons.verified_rounded,
                label: 'Status',
                value: status.toString(),
                valueColor: status.toString().toLowerCase() == 'ok' ||
                        status.toString().toLowerCase() == 'healthy'
                    ? TuneColors.success
                    : TuneColors.warning,
              ),
              if (cpu != null) ...[
                const Divider(height: 1, indent: 56, color: TuneColors.divider),
                _GaugeTile(
                  icon: Icons.memory_rounded,
                  label: 'CPU',
                  value: _toPercent(cpu),
                ),
              ],
              if (ram != null) ...[
                const Divider(height: 1, indent: 56, color: TuneColors.divider),
                _GaugeTile(
                  icon: Icons.developer_board_rounded,
                  label: 'RAM',
                  value: _toPercent(ram),
                ),
              ],
              if (disk != null) ...[
                const Divider(height: 1, indent: 56, color: TuneColors.divider),
                _GaugeTile(
                  icon: Icons.storage_rounded,
                  label: 'Disque',
                  value: _toPercent(disk),
                ),
              ],
              if (uptime != null) ...[
                const Divider(height: 1, indent: 56, color: TuneColors.divider),
                _InfoTile(
                  icon: Icons.timer_rounded,
                  label: 'Uptime',
                  value: _formatUptime(uptime),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ---- Zones ----

  Widget _buildZonesSection() {
    if (_zones.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader('ZONES (${_zones.length})'),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: _zones.asMap().entries.map((entry) {
              final idx = entry.key;
              final z = entry.value as Map<String, dynamic>;
              final name = z['name'] ?? 'Zone ${z['id']}';
              final state = z['state'] ?? z['playback_state'] ?? z['status'] ?? 'idle';
              final output = z['output_type'] ?? z['output'] ?? 'local';
              final track = z['current_track'] ?? z['track'];

              return Column(
                children: [
                  if (idx > 0)
                    const Divider(height: 1, indent: 56, color: TuneColors.divider),
                  ListTile(
                    leading: Icon(
                      _zoneIcon(output.toString()),
                      color: state.toString() == 'playing'
                          ? TuneColors.success
                          : TuneColors.accent,
                      size: 22,
                    ),
                    title: Text(name.toString(), style: TuneFonts.body),
                    subtitle: Text(
                      track != null
                          ? '${track is Map ? track['title'] ?? '' : track} - $state'
                          : '$output - $state',
                      style: TuneFonts.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: state.toString() == 'playing'
                            ? TuneColors.success
                            : state.toString() == 'paused'
                                ? TuneColors.warning
                                : TuneColors.textTertiary,
                        shape: BoxShape.circle,
                      ),
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

  // ---- Discovery ----

  Widget _buildDiscoverySection() {
    if (_discovery.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader('APPAREILS DECOUVERTS (${_discovery.length})'),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: _discovery.asMap().entries.map((entry) {
              final idx = entry.key;
              final d = entry.value as Map<String, dynamic>;
              final name = d['name'] ?? d['friendly_name'] ?? 'Unknown';
              final type = d['type'] ?? d['protocol'] ?? '';
              final ip = d['ip'] ?? d['host'] ?? d['address'] ?? '';

              return Column(
                children: [
                  if (idx > 0)
                    const Divider(height: 1, indent: 56, color: TuneColors.divider),
                  ListTile(
                    leading: Icon(
                      _deviceIcon(type.toString()),
                      color: TuneColors.accent,
                      size: 22,
                    ),
                    title: Text(name.toString(), style: TuneFonts.body),
                    subtitle: Text(
                      '$type${ip.toString().isNotEmpty ? " - $ip" : ""}',
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

  // ---- Errors ----

  Widget _buildErrorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader('ERREURS RECENTES (${_errors.length})'),
        Container(
          color: TuneColors.surface,
          child: _errors.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          size: 18, color: TuneColors.success),
                      const SizedBox(width: 10),
                      Text('Aucune erreur recente',
                          style: TuneFonts.footnote.copyWith(color: TuneColors.success)),
                    ],
                  ),
                )
              : Column(
                  children: _errors.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final e = entry.value;
                    String message;
                    String? timestamp;

                    if (e is Map<String, dynamic>) {
                      message = e['message'] ?? e['error'] ?? e.toString();
                      timestamp = e['timestamp'] as String? ?? e['time'] as String?;
                    } else {
                      message = e.toString();
                    }

                    return Column(
                      children: [
                        if (idx > 0)
                          const Divider(height: 1, indent: 16, color: TuneColors.divider),
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.error_outline_rounded,
                              size: 18, color: TuneColors.error),
                          title: Text(
                            message,
                            style: TuneFonts.caption.copyWith(color: TuneColors.textPrimary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: timestamp != null
                              ? Text(timestamp, style: TuneFonts.caption)
                              : null,
                        ),
                      ],
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  // ---- Helpers ----

  double _toPercent(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }

  String _formatUptime(dynamic uptime) {
    if (uptime is num) {
      final seconds = uptime.toInt();
      final days = seconds ~/ 86400;
      final hours = (seconds % 86400) ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      if (days > 0) return '${days}j ${hours}h ${minutes}m';
      if (hours > 0) return '${hours}h ${minutes}m';
      return '${minutes}m ${seconds % 60}s';
    }
    return uptime.toString();
  }

  IconData _zoneIcon(String output) => switch (output) {
        'dlna' => Icons.cast_rounded,
        'airplay' => Icons.airplay_rounded,
        'bluetooth' => Icons.bluetooth_rounded,
        'chromecast' => Icons.cast_connected_rounded,
        'bluos' => Icons.speaker_rounded,
        _ => Icons.speaker_phone_rounded,
      };

  IconData _deviceIcon(String type) => switch (type) {
        'renderer' || 'dlna' => Icons.cast_rounded,
        'chromecast' => Icons.cast_connected_rounded,
        'bluos' => Icons.speaker_rounded,
        'tune' => Icons.wifi_tethering_rounded,
        _ => Icons.devices_rounded,
      };
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

class _GaugeTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;

  const _GaugeTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  Color _gaugeColor(double v) {
    if (v > 90) return TuneColors.error;
    if (v > 70) return TuneColors.warning;
    return TuneColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: TuneColors.accent, size: 22),
      title: Text(label, style: TuneFonts.body),
      trailing: SizedBox(
        width: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: value / 100,
                  backgroundColor: TuneColors.surfaceHigh,
                  valueColor: AlwaysStoppedAnimation(_gaugeColor(value)),
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${value.toStringAsFixed(0)}%',
              style: TuneFonts.callout.copyWith(
                color: _gaugeColor(value),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
