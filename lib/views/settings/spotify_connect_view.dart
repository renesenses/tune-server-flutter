import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      setState(() => _error = 'Statut indisponible: $e');
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
    final s = _status;
    final zones = context.watch<AppState>().zoneState.zones;
    return Scaffold(
      appBar: AppBar(title: const Text('Spotify Connect')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Tune apparaît comme un récepteur Spotify Connect sur le réseau '
            'local. Depuis l\'app Spotify, sélectionnez « Tune (…) » dans la '
            'liste des appareils. Compte Spotify Premium requis côté client.',
          ),
          const SizedBox(height: 16),
          if (s == null)
            const Center(child: CircularProgressIndicator())
          else if (s['binary_available'] != true)
            Card(
              color: Colors.orange.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('librespot non détecté sur le serveur',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(
                      'Réinstallez Tune Server depuis le tarball/zip officiel '
                      'pour que le binaire soit livré, ou installez-le '
                      'séparément (apt install librespot / brew install librespot).',
                    ),
                  ],
                ),
              ),
            )
          else ...[
            DropdownButtonFormField<int?>(
              decoration: const InputDecoration(labelText: 'Zone cible'),
              value: _zoneId,
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
                labelText: 'Nom du device',
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
                      : Text(s['enabled'] == true ? 'Désactiver' : 'Activer'),
                ),
                const SizedBox(width: 12),
                if (s['enabled'] == true && s['active'] == true)
                  const Chip(
                    avatar: Icon(Icons.circle, color: Colors.green, size: 12),
                    label: Text('En lecture'),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
