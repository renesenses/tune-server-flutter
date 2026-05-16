import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// NetworkDiagnosticsView — Multicast, DNS, Internet status
// API: GET /system/diagnostics/network
// ---------------------------------------------------------------------------

class NetworkDiagnosticsView extends StatefulWidget {
  const NetworkDiagnosticsView({super.key});

  @override
  State<NetworkDiagnosticsView> createState() => _NetworkDiagnosticsViewState();
}

class _NetworkDiagnosticsViewState extends State<NetworkDiagnosticsView> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) {
      setState(() { _loading = false; _error = 'Non connecte'; });
      return;
    }
    setState(() => _loading = true);
    try {
      final data = await api.getNetworkDiagnostics();
      if (mounted) setState(() { _data = data; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = '$e'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Diagnostics reseau', style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: TuneColors.accent),
            onPressed: _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: TuneColors.accent))
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: TuneColors.error)))
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_data == null) return const SizedBox.shrink();

    final multicast = _data!['multicast'] as Map<String, dynamic>? ?? {};
    final dns = _data!['dns'] as Map<String, dynamic>? ?? {};
    final internet = _data!['internet'] as Map<String, dynamic>? ?? {};
    final interfaces = _data!['interfaces'] as List<dynamic>? ?? [];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _StatusCard(
          title: 'Multicast / SSDP',
          icon: Icons.cast_connected_rounded,
          status: multicast['status'] as String? ?? 'unknown',
          details: {
            'SSDP actif': '${multicast['ssdp_active'] ?? '-'}',
            'Multicast joignable': '${multicast['reachable'] ?? '-'}',
            if (multicast['error'] != null) 'Erreur': multicast['error'] as String,
          },
        ),
        const SizedBox(height: 12),
        _StatusCard(
          title: 'DNS',
          icon: Icons.dns_rounded,
          status: dns['status'] as String? ?? 'unknown',
          details: {
            'Resolution': '${dns['resolution_ms'] ?? '-'} ms',
            'Serveur': dns['server'] as String? ?? '-',
            if (dns['error'] != null) 'Erreur': dns['error'] as String,
          },
        ),
        const SizedBox(height: 12),
        _StatusCard(
          title: 'Internet',
          icon: Icons.language_rounded,
          status: internet['status'] as String? ?? 'unknown',
          details: {
            'Latence': '${internet['latency_ms'] ?? '-'} ms',
            'IP publique': internet['public_ip'] as String? ?? '-',
            if (internet['error'] != null) 'Erreur': internet['error'] as String,
          },
        ),
        if (interfaces.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('INTERFACES RESEAU',
              style: TuneFonts.footnote.copyWith(
                color: TuneColors.textTertiary,
                letterSpacing: 0.8,
              )),
          const SizedBox(height: 8),
          ...interfaces.map((iface) {
            final m = iface as Map<String, dynamic>;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TuneColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.settings_ethernet_rounded,
                      color: TuneColors.textSecondary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m['name'] as String? ?? '-',
                            style: TuneFonts.body.copyWith(fontWeight: FontWeight.w500)),
                        Text(m['address'] as String? ?? '-',
                            style: TuneFonts.caption.copyWith(color: TuneColors.textSecondary)),
                      ],
                    ),
                  ),
                  if (m['up'] == true)
                    const Icon(Icons.check_circle_rounded, color: TuneColors.success, size: 16)
                  else
                    const Icon(Icons.cancel_rounded, color: TuneColors.error, size: 16),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Status card
// ---------------------------------------------------------------------------

class _StatusCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String status;
  final Map<String, String> details;

  const _StatusCard({
    required this.title,
    required this.icon,
    required this.status,
    required this.details,
  });

  Color get _statusColor {
    switch (status) {
      case 'ok': return TuneColors.success;
      case 'warning': return TuneColors.warning;
      case 'error': return TuneColors.error;
      default: return TuneColors.textTertiary;
    }
  }

  String get _statusLabel {
    switch (status) {
      case 'ok': return 'OK';
      case 'warning': return 'Attention';
      case 'error': return 'Erreur';
      default: return 'Inconnu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TuneColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _statusColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _statusColor, size: 22),
              const SizedBox(width: 10),
              Text(title, style: TuneFonts.body.copyWith(fontWeight: FontWeight.w600)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(color: _statusColor, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...details.entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Text('${e.key}: ', style: TuneFonts.caption.copyWith(color: TuneColors.textTertiary)),
                Expanded(
                  child: Text(e.value, style: TuneFonts.caption.copyWith(color: TuneColors.textSecondary)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
