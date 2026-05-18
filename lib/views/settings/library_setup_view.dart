import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/discovery/discovery_manager.dart';
import '../../services/tune_api_client.dart';
import '../../state/app_state.dart';
import '../../state/settings_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// LibrarySetupView — Onboarding wizard (4 pages)
//
// Step 1: Welcome — "Bienvenue sur Tune !" + description + "Commencer"
// Step 2: Configuration — Music directory path input (local) or server
//         connection (remote), depending on mode
// Step 3: Zone — Show discovered devices, tap to create zone
// Step 4: Terminé — Summary + "Accéder au tableau de bord"
//
// Shows on first launch (setupCompleted flag). Gated in RootView.
// ---------------------------------------------------------------------------

class LibrarySetupView extends StatefulWidget {
  const LibrarySetupView({super.key});

  @override
  State<LibrarySetupView> createState() => _LibrarySetupViewState();
}

class _LibrarySetupViewState extends State<LibrarySetupView> {
  final PageController _pageCtrl = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_page < 6) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _complete();
    }
  }

  Future<void> _complete() async {
    await context.read<SettingsState>().completeSetup();
    if (mounted) {
      // Si la vue a été poussée via Navigator (depuis SettingsView), pop.
      // Sinon (onboarding initial), la RootView réagit via setupCompleted.
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Indicateurs de page
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(7, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _page == i ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _page == i
                          ? TuneColors.accent
                          : TuneColors.surfaceHigh,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
            // Pages
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _WelcomePage(onNext: _goNext),
                  _ConfigPage(onNext: _goNext),
                  _StreamingAuthPage(onNext: _goNext),
                  _ZonePage(onNext: _goNext),
                  _AudioCheckPage(onNext: _goNext),
                  _ScanPage(onNext: _goNext),
                  _DonePage(onDone: _complete),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 1 — Bienvenue
// ---------------------------------------------------------------------------

class _WelcomePage extends StatelessWidget {
  final VoidCallback onNext;
  const _WelcomePage({required this.onNext});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_tethering_rounded,
              size: 84, color: TuneColors.accent),
          const SizedBox(height: 32),
          Text(
            l.onboardingWelcomeTitle,
            style: TuneFonts.largeTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l.onboardingWelcomeBody,
            style: TuneFonts.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 52),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onNext,
              style: FilledButton.styleFrom(
                backgroundColor: TuneColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(l.onboardingWelcomeStart,
                  style: const TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 2 — Configuration (dossier local ou serveur distant)
// ---------------------------------------------------------------------------

class _ConfigPage extends StatefulWidget {
  final VoidCallback onNext;
  const _ConfigPage({required this.onNext});

  @override
  State<_ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<_ConfigPage> {
  final _ctrl = TextEditingController();
  bool _adding = false;
  bool _added = false;
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _pickFolder() async {
    final path = await FilePicker.platform.getDirectoryPath();
    if (path != null && mounted) {
      setState(() {
        _ctrl.text = path;
        _error = null;
      });
    }
  }

  Future<void> _add() async {
    final path = _ctrl.text.trim();
    if (path.isEmpty) {
      setState(() => _error =
          AppLocalizations.of(context).setupFolderEmpty);
      return;
    }
    setState(() { _adding = true; _error = null; });
    await context.read<AppState>().addMusicFolder(path);
    if (mounted) setState(() { _adding = false; _added = true; });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final settings = context.watch<SettingsState>();
    final isRemote = settings.isRemoteMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Icon(isRemote ? Icons.wifi_tethering_rounded : Icons.dns_rounded,
                size: 64, color: TuneColors.accent),
            const SizedBox(height: 16),
            Text(l.onboardingConfigTitle, style: TuneFonts.title1),
            const SizedBox(height: 12),
            Text(
              isRemote
                  ? 'Connectez-vous a un serveur Tune sur votre reseau pour profiter de toutes les fonctionnalites.'
                  : l.onboardingConfigBody,
              style: TuneFonts.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Mode picker
            SegmentedButton<String>(
              expandedInsets: EdgeInsets.zero,
              segments: const [
                ButtonSegment(value: 'remote',
                    icon: Icon(Icons.wifi_tethering_rounded, size: 16),
                    label: Text('Serveur distant')),
                ButtonSegment(value: 'server',
                    icon: Icon(Icons.dns_rounded, size: 16),
                    label: Text('Autonome')),
              ],
              selected: {settings.appMode},
              onSelectionChanged: (v) => settings.setAppMode(v.first),
              style: ButtonStyle(
                textStyle: WidgetStatePropertyAll(TuneFonts.caption),
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(height: 12),
            if (!isRemote)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Mode autonome — Party, DJ, paroles synchronisees, EQ, recommandations sont absents. Recommande : utiliser un serveur Tune distant.',
                        style: TuneFonts.caption.copyWith(
                            color: TuneColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            if (isRemote) const _RemoteSetupBlock(),
            const SizedBox(height: 16),
            // Server-mode folder picker — only shown in standalone mode.
            if (!isRemote) ...[
              TextField(
                controller: _ctrl,
                style: TuneFonts.body,
                enabled: !_added,
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: TuneColors.surface,
                  hintText: l.setupFolderHint,
                  hintStyle: TuneFonts.footnote.copyWith(
                    color: TuneColors.textSecondary.withValues(alpha: 0.45),
                  ),
                  labelText: l.setupFolderPath,
                  border: const OutlineInputBorder(),
                  errorText: _error,
                  suffixIcon: _adding
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: TuneColors.accent),
                          ),
                        )
                      : _added
                          ? const Icon(Icons.check_circle_rounded,
                              color: TuneColors.success)
                          : null,
                ),
              ),
              const SizedBox(height: 8),
              if (!_added)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.folder_open_rounded, size: 18),
                    label: Text(l.btnAddFolder),
                    onPressed: _adding ? null : _pickFolder,
                  ),
                ),
              const SizedBox(height: 4),
              if (!_added)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: TuneColors.accent),
                    onPressed: _adding ? null : _add,
                    child: Text(l.setupAddFolder),
                  ),
                ),
              if (_added)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    l.setupFolderAdded,
                    style: TuneFonts.footnote
                        .copyWith(color: TuneColors.success),
                  ),
                ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: widget.onNext,
                style: FilledButton.styleFrom(
                  backgroundColor: TuneColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  isRemote ? l.btnNext : (_added ? l.btnNext : l.btnSkip),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// _RemoteSetupBlock — shown in onboarding remote mode: host/port + install link.
class _RemoteSetupBlock extends StatefulWidget {
  const _RemoteSetupBlock();

  @override
  State<_RemoteSetupBlock> createState() => _RemoteSetupBlockState();
}

class _RemoteSetupBlockState extends State<_RemoteSetupBlock> {
  late final TextEditingController _hostCtrl;
  late final TextEditingController _portCtrl;

  @override
  void initState() {
    super.initState();
    final s = context.read<SettingsState>();
    _hostCtrl = TextEditingController(text: s.remoteHost);
    _portCtrl = TextEditingController(text: s.remotePort.toString());
  }

  @override
  void dispose() {
    _hostCtrl.dispose();
    _portCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsState>();
    return Column(
      children: [
        TextField(
          controller: _hostCtrl,
          style: TuneFonts.body,
          keyboardType: TextInputType.url,
          autocorrect: false,
          onChanged: (v) => settings.setRemoteHost(v.trim()),
          decoration: const InputDecoration(
            filled: true,
            fillColor: TuneColors.surface,
            labelText: 'Adresse du serveur',
            hintText: '192.168.1.50',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.network_check_rounded),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _portCtrl,
          style: TuneFonts.body,
          keyboardType: TextInputType.number,
          onChanged: (v) {
            final p = int.tryParse(v.trim());
            if (p != null) settings.setRemotePort(p);
          },
          decoration: const InputDecoration(
            filled: true,
            fillColor: TuneColors.surface,
            labelText: 'Port',
            hintText: '8888',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        // "No server? Install one" — instructional, no url_launcher dep yet.
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: TuneColors.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.download_rounded,
                  size: 18, color: TuneColors.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pas encore de serveur ?',
                        style: TuneFonts.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: TuneColors.textPrimary)),
                    const SizedBox(height: 2),
                    SelectableText(
                      'Telechargez Tune Server : mozaiklabs.fr/download (Mac, Linux, Windows, Raspberry Pi, Docker NAS).',
                      style: TuneFonts.caption.copyWith(
                          color: TuneColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Page 3 — Streaming Services Auth
// ---------------------------------------------------------------------------

class _StreamingAuthPage extends StatefulWidget {
  final VoidCallback onNext;
  const _StreamingAuthPage({required this.onNext});

  @override
  State<_StreamingAuthPage> createState() => _StreamingAuthPageState();
}

class _StreamingAuthPageState extends State<_StreamingAuthPage> {
  Map<String, dynamic> _services = {};
  bool _loading = true;

  static const _serviceNames = ['qobuz', 'tidal', 'spotify', 'deezer', 'youtube'];
  static const _serviceColors = {
    'qobuz': Color(0xFFE91E63),
    'tidal': Color(0xFF000000),
    'spotify': Color(0xFF1DB954),
    'deezer': Color(0xFFA238FF),
    'youtube': Color(0xFFFF0000),
  };

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final data = await api.getStreamingServices();
      if (mounted) {
        setState(() {
          _services = data;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggleService(String name, bool enable) async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    try {
      if (enable) {
        await api.enableStreamingService(name);
      } else {
        await api.disableStreamingService(name);
      }
      await _loadServices();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: TuneColors.error),
        );
      }
    }
  }

  int get _enabledCount =>
      _services.entries.where((e) {
        final v = e.value;
        return v is Map && v['enabled'] == true;
      }).length;

  int get _authenticatedCount =>
      _services.entries.where((e) {
        final v = e.value;
        return v is Map && v['authenticated'] == true;
      }).length;

  @override
  Widget build(BuildContext context) {
    final isRemote = context.watch<SettingsState>().isRemoteMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            const Icon(Icons.cloud_rounded, size: 64, color: TuneColors.accent),
            const SizedBox(height: 24),
            const Text('Services de streaming', style: TuneFonts.title1),
            const SizedBox(height: 12),
            Text(
              'Activez les services de streaming que vous souhaitez utiliser avec Tune.',
              style: TuneFonts.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            if (!isRemote)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'En mode autonome, les services de streaming ne sont pas disponibles. Passez en mode serveur distant pour les activer.',
                        style: TuneFonts.caption.copyWith(color: TuneColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),

            if (_loading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(color: TuneColors.accent),
              )
            else if (_services.isEmpty && isRemote)
              Text(
                'Aucun service disponible. Verifiez la connexion au serveur.',
                style: TuneFonts.footnote.copyWith(color: TuneColors.textTertiary),
                textAlign: TextAlign.center,
              )
            else ...[
              // Service list
              Container(
                decoration: BoxDecoration(
                  color: TuneColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < _serviceNames.length; i++) ...[
                      if (i > 0)
                        const Divider(height: 1, indent: 56, color: TuneColors.divider),
                      _buildServiceRow(_serviceNames[i]),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 12),
              // Summary
              if (_enabledCount > 0)
                Text(
                  '$_enabledCount service${_enabledCount > 1 ? "s" : ""} active${_enabledCount > 1 ? "s" : ""}'
                  '${_authenticatedCount > 0 ? ", $_authenticatedCount connecte${_authenticatedCount > 1 ? "s" : ""}" : ""}',
                  style: TuneFonts.footnote.copyWith(color: TuneColors.textSecondary),
                ),
            ],

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: widget.onNext,
                style: FilledButton.styleFrom(
                  backgroundColor: TuneColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Suivant', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceRow(String name) {
    final serviceData = _services[name];
    final enabled = serviceData is Map ? serviceData['enabled'] == true : false;
    final authenticated = serviceData is Map ? serviceData['authenticated'] == true : false;
    final color = _serviceColors[name] ?? TuneColors.accent;

    return ListTile(
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Container(
            width: 14, height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
      title: Text(
        name[0].toUpperCase() + name.substring(1),
        style: TuneFonts.body.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: enabled
          ? Text(
              authenticated ? 'Connecte' : 'Active, non connecte',
              style: TuneFonts.caption.copyWith(
                color: authenticated ? TuneColors.success : TuneColors.textTertiary,
              ),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (authenticated)
            Container(
              width: 8, height: 8,
              margin: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(
                color: TuneColors.success,
                shape: BoxShape.circle,
              ),
            ),
          Switch(
            value: enabled,
            onChanged: (v) => _toggleService(name, v),
            activeColor: TuneColors.accent,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 4 — Zone (discovered devices)
// ---------------------------------------------------------------------------

class _ZonePage extends StatefulWidget {
  final VoidCallback onNext;
  const _ZonePage({required this.onNext});

  @override
  State<_ZonePage> createState() => _ZonePageState();
}

class _ZonePageState extends State<_ZonePage> {
  bool _zoneCreated = false;
  String? _createdZoneName;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final zoneState = context.watch<ZoneState>();
    final renderers = zoneState.renderers;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.speaker_group_rounded,
              size: 64, color: TuneColors.accent),
          const SizedBox(height: 24),
          Text(l.onboardingZoneTitle, style: TuneFonts.title1),
          const SizedBox(height: 12),
          Text(
            l.onboardingZoneBody,
            style: TuneFonts.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Device list or empty state
          if (renderers.isEmpty && !_zoneCreated)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: TuneColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l.onboardingZoneEmpty,
                style: TuneFonts.footnote.copyWith(
                    color: TuneColors.textTertiary),
                textAlign: TextAlign.center,
              ),
            )
          else if (!_zoneCreated)
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: TuneColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: renderers.length,
                separatorBuilder: (_, __) => const Divider(
                    height: 1, indent: 56, color: TuneColors.divider),
                itemBuilder: (ctx, i) {
                  final device = renderers[i];
                  return ListTile(
                    leading: const Icon(Icons.cast_rounded,
                        color: TuneColors.textSecondary),
                    title: Text(device.name,
                        style: const TextStyle(
                            color: TuneColors.textPrimary)),
                    subtitle: Text('${device.host}:${device.port}',
                        style: TuneFonts.caption),
                    trailing: const Icon(Icons.add_circle_rounded,
                        color: TuneColors.accent),
                    onTap: () => _createZone(device),
                  );
                },
              ),
            ),

          // Success state
          if (_zoneCreated) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TuneColors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: TuneColors.accent.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: TuneColors.accent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l.onboardingZoneCreated(_createdZoneName ?? ''),
                      style: TuneFonts.body
                          .copyWith(color: TuneColors.accent),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: widget.onNext,
              style: FilledButton.styleFrom(
                backgroundColor: TuneColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                _zoneCreated ? l.btnNext : l.btnSkip,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createZone(DiscoveredDevice device) async {
    final appState = context.read<AppState>();
    await appState.createZoneFromDevice(device);
    if (mounted) {
      setState(() {
        _zoneCreated = true;
        _createdZoneName = device.name;
      });
    }
  }
}

// ---------------------------------------------------------------------------
// Page 4 — Audio Check
// ---------------------------------------------------------------------------

class _AudioCheckPage extends StatefulWidget {
  final VoidCallback onNext;
  const _AudioCheckPage({required this.onNext});

  @override
  State<_AudioCheckPage> createState() => _AudioCheckPageState();
}

class _AudioCheckPageState extends State<_AudioCheckPage> {
  Map<String, dynamic>? _audioData;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAudioCheck();
  }

  Future<void> _loadAudioCheck() async {
    setState(() { _loading = true; _error = null; });
    final app = context.read<AppState>();
    final api = app.apiClient;
    if (api != null) {
      try {
        final data = await api.audioCheck();
        if (mounted) setState(() { _audioData = data; _loading = false; });
        return;
      } catch (e) {
        if (mounted) setState(() { _error = '$e'; _loading = false; });
        return;
      }
    }
    // No remote API — build local summary from state
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final zoneState = context.watch<ZoneState>();
    final zones = zoneState.zones;
    final devices = zoneState.devices;

    final dlnaDevices = devices.where((d) => d.type == 'renderer').toList();
    final bluosDevices = devices.where((d) => d.type == 'bluos').toList();
    final chromecastDevices = devices.where((d) => d.type == 'chromecast').toList();
    final networkDeviceCount = dlnaDevices.length + bluosDevices.length + chromecastDevices.length;

    final outputs = _audioData?['outputs'] as List<dynamic>? ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            const Icon(Icons.tune_rounded, size: 64, color: TuneColors.accent),
            const SizedBox(height: 24),
            Text('Diagnostic audio', style: TuneFonts.title1),
            const SizedBox(height: 12),
            Text(
              'Verification de la configuration audio de votre systeme.',
              style: TuneFonts.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            if (_loading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(color: TuneColors.accent),
              )
            else ...[
              // Diagnostic cards
              Container(
                decoration: BoxDecoration(
                  color: TuneColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Zones
                    _DiagRow(
                      icon: Icons.speaker_group_rounded,
                      label: 'Zones configurees',
                      value: '${zones.length}',
                      status: zones.isNotEmpty
                          ? _DiagStatus.ok
                          : _DiagStatus.warning,
                    ),
                    const Divider(height: 1, indent: 56, color: TuneColors.divider),
                    // Audio outputs
                    _DiagRow(
                      icon: Icons.headphones_rounded,
                      label: 'Sorties audio',
                      value: outputs.isNotEmpty
                          ? '${outputs.length} detectee${outputs.length != 1 ? "s" : ""}'
                          : 'Local',
                      status: _DiagStatus.ok,
                    ),
                    const Divider(height: 1, indent: 56, color: TuneColors.divider),
                    // Network devices
                    _DiagRow(
                      icon: Icons.cast_rounded,
                      label: 'Appareils reseau',
                      value: networkDeviceCount > 0
                          ? [
                              if (dlnaDevices.isNotEmpty) '${dlnaDevices.length} DLNA',
                              if (bluosDevices.isNotEmpty) '${bluosDevices.length} BluOS',
                              if (chromecastDevices.isNotEmpty) '${chromecastDevices.length} Chromecast',
                            ].join(', ')
                          : 'Aucun',
                      status: networkDeviceCount > 0
                          ? _DiagStatus.ok
                          : _DiagStatus.warning,
                    ),
                  ],
                ),
              ),

              // Warnings
              if (zones.isEmpty) ...[
                const SizedBox(height: 12),
                _WarningCard(
                  text: 'Aucune zone configuree. Vous pouvez en creer une depuis les parametres Zones.',
                ),
              ],

              if (_error != null) ...[
                const SizedBox(height: 12),
                _WarningCard(text: 'Audio-check indisponible : $_error'),
              ],
            ],

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: widget.onNext,
                style: FilledButton.styleFrom(
                  backgroundColor: TuneColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Suivant', style: TextStyle(fontSize: 16)),
              ),
            ),
            if (!_loading) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _loadAudioCheck,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Reverifier'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum _DiagStatus { ok, warning }

class _DiagRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final _DiagStatus status;

  const _DiagRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final color = status == _DiagStatus.ok
        ? TuneColors.success
        : TuneColors.warning;
    return ListTile(
      leading: Icon(icon, color: TuneColors.accent, size: 22),
      title: Text(label, style: TuneFonts.body),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 140),
            child: Text(
              value,
              style: TuneFonts.caption.copyWith(
                color: TuneColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  final String text;
  const _WarningCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TuneColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: TuneColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded,
              size: 18, color: TuneColors.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TuneFonts.caption.copyWith(color: TuneColors.warning),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 6 — Scan Library
// ---------------------------------------------------------------------------

class _ScanPage extends StatefulWidget {
  final VoidCallback onNext;
  const _ScanPage({required this.onNext});

  @override
  State<_ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<_ScanPage> {
  bool _scanning = false;
  bool _scanComplete = false;
  String? _scanError;
  int _scannedCount = 0;
  int _addedCount = 0;
  int _updatedCount = 0;
  Timer? _pollTimer;

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _startScan() async {
    final app = context.read<AppState>();
    setState(() {
      _scanning = true;
      _scanComplete = false;
      _scanError = null;
      _scannedCount = 0;
      _addedCount = 0;
      _updatedCount = 0;
    });

    // For embedded server mode, trigger local scan
    if (!app.settingsState.isRemoteMode) {
      try {
        await app.engine.scanLibrary();
        if (mounted) {
          setState(() {
            _scanning = false;
            _scanComplete = true;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _scanning = false;
            _scanError = '$e';
          });
        }
      }
      return;
    }

    // Remote mode: trigger scan via API and poll for progress
    final api = app.apiClient;
    if (api == null) {
      setState(() { _scanning = false; _scanError = 'Non connecte'; });
      return;
    }

    try {
      await api.triggerScan();
    } catch (e) {
      // 409 = already scanning, just poll
      if (!e.toString().contains('409') && !e.toString().contains('already')) {
        if (mounted) {
          setState(() { _scanning = false; _scanError = '$e'; });
        }
        return;
      }
    }

    // Start polling for scan status
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      try {
        final status = await api.getScanStatus();
        if (mounted) {
          setState(() {
            _scannedCount = status['scanned'] as int? ?? _scannedCount;
            _addedCount = status['added'] as int? ?? _addedCount;
            _updatedCount = status['updated'] as int? ?? _updatedCount;
            if (status['running'] == false || status['status'] == 'completed') {
              _scanning = false;
              _scanComplete = true;
              _pollTimer?.cancel();
            }
          });
        }
      } catch (_) {
        // silently continue polling
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!_scanning && !_scanComplete) ...[
            // Pre-scan state
            const Icon(Icons.library_music_rounded, size: 64, color: TuneColors.accent),
            const SizedBox(height: 24),
            const Text('Analyser la bibliotheque', style: TuneFonts.title1),
            const SizedBox(height: 12),
            Text(
              'Lancez une analyse pour indexer vos fichiers musicaux et recuperer les metadonnees.',
              style: TuneFonts.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _startScan,
                icon: const Icon(Icons.search_rounded, size: 18),
                label: const Text('Lancer l\'analyse', style: TextStyle(fontSize: 16)),
                style: FilledButton.styleFrom(
                  backgroundColor: TuneColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: widget.onNext,
              child: Text('Passer', style: TuneFonts.footnote.copyWith(color: TuneColors.textTertiary)),
            ),
          ] else if (_scanning) ...[
            // Scanning in progress
            const SizedBox(
              width: 48, height: 48,
              child: CircularProgressIndicator(strokeWidth: 3, color: TuneColors.accent),
            ),
            const SizedBox(height: 24),
            const Text('Analyse en cours...', style: TuneFonts.title2),
            const SizedBox(height: 24),
            // Progress stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ScanStat(label: 'Analyses', value: _scannedCount),
                _ScanStat(label: 'Ajoutees', value: _addedCount),
                if (_updatedCount > 0)
                  _ScanStat(label: 'Mises a jour', value: _updatedCount),
              ],
            ),
            const SizedBox(height: 24),
            // Indeterminate progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: const LinearProgressIndicator(
                minHeight: 6,
                color: TuneColors.accent,
                backgroundColor: TuneColors.surfaceHigh,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Cela peut prendre quelques minutes...',
              style: TuneFonts.footnote.copyWith(color: TuneColors.textTertiary),
            ),
          ] else if (_scanComplete) ...[
            // Scan complete
            const Icon(Icons.check_circle_outline_rounded,
                size: 72, color: TuneColors.success),
            const SizedBox(height: 24),
            const Text('Analyse terminee !', style: TuneFonts.title1),
            const SizedBox(height: 16),
            // Final stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TuneColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ScanStat(label: 'Ajoutees', value: _addedCount, color: TuneColors.success),
                  if (_updatedCount > 0)
                    _ScanStat(label: 'Mises a jour', value: _updatedCount, color: TuneColors.success),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: widget.onNext,
                style: FilledButton.styleFrom(
                  backgroundColor: TuneColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Suivant', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],

          if (_scanError != null) ...[
            const SizedBox(height: 16),
            _WarningCard(text: _scanError!),
            const SizedBox(height: 12),
            TextButton(
              onPressed: widget.onNext,
              child: const Text('Passer'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ScanStat extends StatelessWidget {
  final String label;
  final int value;
  final Color? color;

  const _ScanStat({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 28, fontWeight: FontWeight.w700,
            color: color ?? TuneColors.accent,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TuneFonts.caption.copyWith(
            color: TuneColors.textTertiary,
            letterSpacing: 0.5,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Page 7 — Terminé
// ---------------------------------------------------------------------------

class _DonePage extends StatelessWidget {
  final VoidCallback onDone;
  const _DonePage({required this.onDone});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              size: 84, color: TuneColors.success),
          const SizedBox(height: 32),
          Text(
            l.onboardingDoneTitle,
            style: TuneFonts.largeTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l.onboardingDoneBody,
            style: TuneFonts.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),

          // Summary
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: TuneColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _SummaryRow(
                  icon: Icons.wifi_find_rounded,
                  text: l.setupFeatureSsdp,
                ),
                const SizedBox(height: 12),
                _SummaryRow(
                  icon: Icons.folder_open_rounded,
                  text: l.setupFeatureContentDir,
                ),
                const SizedBox(height: 12),
                _SummaryRow(
                  icon: Icons.play_circle_outline_rounded,
                  text: l.setupFeaturePlayback,
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onDone,
              style: FilledButton.styleFrom(
                backgroundColor: TuneColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(l.onboardingDoneButton,
                  style: const TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _SummaryRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: TuneColors.accent, size: 22),
        const SizedBox(width: 14),
        Expanded(
          child: Text(text, style: TuneFonts.body),
        ),
      ],
    );
  }
}
