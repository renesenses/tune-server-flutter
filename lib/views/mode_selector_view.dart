import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../server/embedded_server_service.dart';
import '../server/tune_native_server.dart';
import '../state/app_state.dart';

/// First screen: choose between embedded server mode and remote mode.
class ModeSelectorView extends StatefulWidget {
  const ModeSelectorView({super.key});

  @override
  State<ModeSelectorView> createState() => _ModeSelectorViewState();
}

class _ModeSelectorViewState extends State<ModeSelectorView> {
  bool _starting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkAutoStart();
  }

  Future<void> _checkAutoStart() async {
    // If server was running before, auto-start
    if (await EmbeddedServerService.wasRunning()) {
      _startEmbedded();
    }
  }

  Future<void> _startEmbedded() async {
    setState(() {
      _starting = true;
      _error = null;
    });

    TuneNativeServer.initialize();
    await EmbeddedServerService.init();

    final ok = await EmbeddedServerService.start();
    if (!mounted) return;

    if (ok) {
      // Connect the API client to localhost
      final appState = context.read<AppState>();
      appState.connectToServer('127.0.0.1', 8888);
    } else {
      setState(() {
        _starting = false;
        _error = 'Failed to start server';
      });
    }
  }

  void _connectRemote() {
    showDialog(
      context: context,
      builder: (ctx) => _RemoteConnectDialog(
        onConnect: (host, port) {
          final appState = context.read<AppState>();
          appState.connectToServer(host, port);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nativeAvailable = TuneNativeServer.isAvailable ||
        // On Android the lib loads lazily, so show the option anyway
        (Theme.of(context).platform == TargetPlatform.android);

    if (_starting) {
      return Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFF6366F1)),
              const SizedBox(height: 24),
              Text(
                'Starting Tune Server...',
                style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.music_note, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 24),
                Text(
                  'Tune',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Multi-room music server',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white54),
                ),
                const SizedBox(height: 48),

                // Embedded server mode
                if (nativeAvailable) ...[
                  _ModeCard(
                    icon: Icons.dns_rounded,
                    title: 'Serveur local',
                    subtitle: 'Lancez Tune sur cet appareil.\nVotre musique, vos regles.',
                    accentColor: const Color(0xFF6366F1),
                    onTap: _startEmbedded,
                  ),
                  const SizedBox(height: 16),
                ],

                // Remote mode
                _ModeCard(
                  icon: Icons.wifi_rounded,
                  title: 'Telecommande',
                  subtitle: 'Connectez-vous a un serveur\nTune sur votre reseau.',
                  accentColor: const Color(0xFF10B981),
                  onTap: _connectRemote,
                ),

                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: accentColor.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(16),
            color: accentColor.withValues(alpha: 0.05),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accentColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: accentColor.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RemoteConnectDialog extends StatefulWidget {
  final void Function(String host, int port) onConnect;
  const _RemoteConnectDialog({required this.onConnect});

  @override
  State<_RemoteConnectDialog> createState() => _RemoteConnectDialogState();
}

class _RemoteConnectDialogState extends State<_RemoteConnectDialog> {
  final _hostController = TextEditingController(text: '192.168.1.');
  final _portController = TextEditingController(text: '8888');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Connexion distante'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _hostController,
            decoration: const InputDecoration(labelText: 'Adresse IP'),
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _portController,
            decoration: const InputDecoration(labelText: 'Port'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () {
            final host = _hostController.text.trim();
            final port = int.tryParse(_portController.text.trim()) ?? 8888;
            Navigator.pop(context);
            widget.onConnect(host, port);
          },
          child: const Text('Connecter'),
        ),
      ],
    );
  }
}
