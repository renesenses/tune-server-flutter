import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';

/// Spotify Connect receiver settings — drives /api/v1/spotify-connect/*.
/// Only meaningful when remote-connected to a Tune Server that bundles
/// librespot; the embedded Flutter server does not implement it.
class SpotifyConnectView extends StatefulWidget {
  const SpotifyConnectView({super.key});

  @override
  State<SpotifyConnectView> createState() => _SpotifyConnectViewState();
}

class _SpotifyConnectViewState extends State<SpotifyConnectView> {
  Map<String, dynamic>? _status;
  int? _zoneId;
  String _deviceName = '';
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    try {
      final s = await api.getSpotifyConnectStatus();
      if (!mounted) return;
      setState(() {
        _status = s;
        _zoneId = s['zone_id'] as int?;
        _deviceName = (s['device_name'] as String?) ?? '';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error =
          AppLocalizations.of(context).cfgStatusUnavailable(e.toString()));
    }
  }

  Future<void> _toggle() async {
    final api = context.read<AppState>().apiClient;
    final s = _status;
    if (api == null || s == null) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final next = (s['enabled'] == true)
          ? await api.disableSpotifyConnect()
          : await api.enableSpotifyConnect(
              zoneId: _zoneId ?? -1,
              deviceName: _deviceName.trim().isEmpty ? null : _deviceName.trim(),
            );
      if (!mounted) return;
      setState(() => _status = next);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = _status;
    final zones = context.watch<AppState>().zoneState.zones;
    return Scaffold(
      appBar: AppBar(title: const Text('Spotify Connect')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.cfgSpotifyIntro),
          const SizedBox(height: 16),
          if (s == null)
            const Center(child: CircularProgressIndicator())
          else if (s['binary_available'] != true)
            Card(
              color: Colors.orange.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.cfgSpotifyNoLibrespot,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(l.cfgSpotifyNoLibrespotHint),
                  ],
                ),
              ),
            )
          else ...[
            DropdownButtonFormField<int?>(
              decoration: InputDecoration(labelText: l.cfgTargetZone),
              initialValue: _zoneId,
              items: [
                const DropdownMenuItem<int?>(value: null, child: Text('—')),
                ...zones.map((z) => DropdownMenuItem<int?>(
                      value: z.id,
                      child: Text(z.name),
                    )),
              ],
              onChanged: (s['enabled'] == true || _busy)
                  ? null
                  : (v) => setState(() => _zoneId = v),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: l.cfgDeviceName,
                hintText: (s['device_name'] as String?) ?? 'Tune (...)',
              ),
              controller: TextEditingController(text: _deviceName)
                ..selection = TextSelection.collapsed(offset: _deviceName.length),
              onChanged: (v) => _deviceName = v,
              enabled: !(s['enabled'] == true) && !_busy,
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _busy ||
                          (s['enabled'] != true && _zoneId == null)
                      ? null
                      : _toggle,
                  child: _busy
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(s['enabled'] == true
                          ? l.streamingDisable
                          : l.streamingEnable),
                ),
                const SizedBox(width: 12),
                if (s['enabled'] == true && s['active'] == true)
                  Chip(
                    avatar: const Icon(Icons.circle,
                        color: Colors.green, size: 12),
                    label: Text(l.cfgPlaying),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
