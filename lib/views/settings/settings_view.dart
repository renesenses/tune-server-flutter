import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../../services/server_discovery.dart';
import '../../services/tune_api_client.dart';
import '../../state/app_state.dart';
import '../../state/settings_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'config_export_view.dart';
import 'database_view.dart';
import 'equalizer_view.dart';
import 'lastfm_view.dart';
import 'network_diagnostics_view.dart';
import 'plugins_view.dart';
import 'smb_browser_view.dart';
import 'spotify_connect_view.dart';
import 'library_setup_view.dart';
import 'metadata_view.dart';
import 'smb_setup_view.dart';
import 'sources_view.dart';

// ---------------------------------------------------------------------------
// T16.1 — SettingsView
// Paramètres app : thème, langue, zone par défaut, port serveur, about.
// Miroir de SettingsView.swift (iOS)
// ---------------------------------------------------------------------------

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(AppLocalizations.of(context).settingsTitle, style: TuneFonts.title3),
      ),
      body: const _SettingsList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Liste des paramètres
// ---------------------------------------------------------------------------

class _SettingsList extends StatelessWidget {
  const _SettingsList();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();
    final app = context.watch<AppState>();

    final l = AppLocalizations.of(context);
    final updateInfo = app.updateInfo;
    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        if (updateInfo != null && updateInfo.updateAvailable) ...[
          Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.system_update, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mise à jour disponible : v${updateInfo.latestVersion}',
                        style: TuneFonts.body.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Version actuelle : v${updateInfo.currentVersion}',
                        style: TuneFonts.caption.copyWith(color: TuneColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                if (updateInfo.releaseUrl != null)
                  TextButton(
                    onPressed: () async {
                      final url = Uri.parse(updateInfo.releaseUrl!);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: const Text('Ouvrir'),
                  ),
              ],
            ),
          ),
        ],
        // ---- Audio Diagnostic ----
        const _AudioDiagnosticSection(),

        // ---- Mode ----
        const _SectionHeader('Mode'),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mode', style: TuneFonts.body),
                    const SizedBox(height: 4),
                    Text(
                      settings.isRemoteMode
                          ? app.isRemoteConnected
                              ? 'Connecté à ${settings.remoteHost}:${settings.remotePort}'
                              : 'Non connecté'
                          : 'Serveur embarqué',
                      style: TuneFonts.footnote.copyWith(
                        color: settings.isRemoteMode && app.isRemoteConnected
                            ? TuneColors.accent
                            : TuneColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SegmentedButton<String>(
                      expandedInsets: EdgeInsets.zero,
                      segments: const [
                        ButtonSegment(value: 'server', icon: Icon(Icons.dns_rounded, size: 16), label: Text('Serveur')),
                        ButtonSegment(value: 'remote', icon: Icon(Icons.wifi_tethering_rounded, size: 16), label: Text('Remote')),
                      ],
                      selected: {settings.appMode},
                      onSelectionChanged: (v) => app.switchMode(v.first),
                      style: ButtonStyle(
                        textStyle: WidgetStatePropertyAll(TuneFonts.caption),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    // Standalone lacks the v0.6+/v0.7.x features (Party,
                    // DJ, lyrics, EQ, album bios...) that only the Python
                    // server provides. Be explicit so the user doesn't
                    // expect parity with remote mode.
                    if (!settings.isRemoteMode) ...[
                      const SizedBox(height: 10),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Mode standalone — fonctionnalités limitées',
                                      style: TuneFonts.caption.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: TuneColors.textPrimary)),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Party, DJ, paroles synchronisées, EQ, bios d\'album, recommandations… requièrent un serveur Tune distant.',
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
                  ],
                ),
              ),
              if (settings.isRemoteMode) ...[
                const Divider(height: 1, indent: 16, color: TuneColors.divider),
                _SettingsTile(
                  title: 'Adresse serveur',
                  trailing: Text(
                    settings.remoteHost.isEmpty ? 'Non configuré' : settings.remoteHost,
                    style: const TextStyle(color: TuneColors.textSecondary),
                  ),
                  onTap: app.isRemoteConnected ? null : () => _editRemoteHost(context, settings),
                ),
                const Divider(height: 1, indent: 16, color: TuneColors.divider),
                _SettingsTile(
                  title: 'Port',
                  trailing: Text(
                    settings.remotePort.toString(),
                    style: const TextStyle(color: TuneColors.textSecondary),
                  ),
                  onTap: app.isRemoteConnected ? null : () => _editRemotePort(context, settings),
                ),
                if (!app.isRemoteConnected) ...[
                  const Divider(height: 1, indent: 16, color: TuneColors.divider),
                  _SettingsTile(
                    title: 'Scanner le réseau',
                    trailing: const Icon(Icons.radar_rounded, color: TuneColors.accent),
                    onTap: () => _scanForServers(context, settings),
                  ),
                ],
                const Divider(height: 1, indent: 16, color: TuneColors.divider),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: app.isRemoteConnected
                      ? FilledButton.icon(
                          onPressed: () => app.disconnectRemote(),
                          icon: const Icon(Icons.link_off_rounded, size: 16),
                          label: const Text('Déconnecter'),
                          style: FilledButton.styleFrom(
                            backgroundColor: TuneColors.error,
                            minimumSize: const Size.fromHeight(40),
                          ),
                        )
                      : FilledButton.icon(
                          onPressed: settings.remoteHost.isEmpty
                              ? null
                              : () => app.connectRemote(),
                          icon: const Icon(Icons.link_rounded, size: 16),
                          label: const Text('Connecter'),
                          style: FilledButton.styleFrom(
                            backgroundColor: TuneColors.accent,
                            minimumSize: const Size.fromHeight(40),
                          ),
                        ),
                ),
              ],
            ],
          ),
        ),

        // ---- Apparence ----
        _SectionHeader(l.settingsSectionAppearance),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: [
              _SettingsTile(
                title: l.settingsTheme,
                trailing: DropdownButton<String>(
                  value: settings.theme,
                  dropdownColor: TuneColors.surfaceVariant,
                  underline: const SizedBox(),
                  style: TuneFonts.body,
                  items: [
                    DropdownMenuItem(value: 'system', child: Text(l.settingsThemeSystem)),
                    DropdownMenuItem(value: 'light', child: Text(l.settingsThemeLight)),
                    DropdownMenuItem(value: 'dark', child: Text(l.settingsThemeDark)),
                  ],
                  onChanged: (v) {
                    if (v != null) settings.setTheme(v);
                  },
                ),
              ),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _SettingsTile(
                title: l.settingsLanguage,
                trailing: DropdownButton<String?>(
                  value: settings.language,
                  dropdownColor: TuneColors.surfaceVariant,
                  underline: const SizedBox(),
                  style: TuneFonts.body,
                  items: [
                    DropdownMenuItem<String?>(value: null, child: Text(l.settingsLangSystem)),
                    // Les noms de langues restent dans leur propre langue (pas localisés)
                    const DropdownMenuItem(value: 'fr', child: Text('Français')),
                    const DropdownMenuItem(value: 'en', child: Text('English')),
                    const DropdownMenuItem(value: 'de', child: Text('Deutsch')),
                    const DropdownMenuItem(value: 'es', child: Text('Español')),
                    const DropdownMenuItem(value: 'it', child: Text('Italiano')),
                    const DropdownMenuItem(value: 'zh', child: Text('中文')),
                    const DropdownMenuItem(value: 'ja', child: Text('日本語')),
                  ],
                  onChanged: (v) => settings.setLanguage(v),
                ),
              ),
            ],
          ),
        ),

        // ---- Serveur ----
        _SectionHeader(l.settingsSectionServer),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: [
              _SettingsTile(
                title: l.settingsHttpPort,
                subtitle: l.settingsHttpPortDesc,
                trailing: Text(
                  settings.serverPort.toString(),
                  style: const TextStyle(color: TuneColors.textSecondary),
                ),
                onTap: () => _editPort(context, settings),
              ),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _SettingsTile(
                title: l.settingsLocalIp,
                trailing: Text(
                  app.engine.localIp ?? '—',
                  style: const TextStyle(
                      color: TuneColors.textSecondary, fontSize: 13),
                ),
              ),
            ],
          ),
        ),

        // ---- Lecture ----
        const _SectionHeader('LECTURE'),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: [
              _SettingsTile(
                title: 'Crossfade',
                trailing: Switch(
                  value: settings.crossfadeEnabled,
                  onChanged: (v) => settings.setCrossfadeEnabled(v),
                  activeThumbColor: TuneColors.accent,
                ),
              ),
              if (settings.crossfadeEnabled) ...[
                const Divider(height: 1, indent: 16, color: TuneColors.divider),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Text('${settings.crossfadeDuration.toInt()}s', style: TuneFonts.caption),
                      Expanded(
                        child: Slider(
                          value: settings.crossfadeDuration,
                          min: 1,
                          max: 12,
                          divisions: 11,
                          activeColor: TuneColors.accent,
                          onChanged: (v) => settings.setCrossfadeDuration(v),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 8),
        Container(
          color: TuneColors.surface,
          child: _SettingsTile(
            title: 'Mode Exclusif (bit-perfect)',
            subtitle: 'WASAPI Exclusive — acces direct au DAC USB',
            trailing: Switch(
              value: settings.exclusiveModeEnabled,
              onChanged: (v) => settings.setExclusiveModeEnabled(v),
              activeThumbColor: TuneColors.accent,
            ),
          ),
        ),

        // ---- Audiophile / Qualite / EQ ----
        if (app.apiClient != null) ...[
          const _SectionHeader('AUDIO AVANCE'),
          Container(
            color: TuneColors.surface,
            child: Column(
              children: [
                const _AudiophileToggle(),
                const Divider(height: 1, indent: 16, color: TuneColors.divider),
                const _StreamingQualitySelector(),
                const Divider(height: 1, indent: 16, color: TuneColors.divider),
                _SettingsTile(
                  title: 'Equalizer 10 bandes',
                  subtitle: 'Reglage fin par frequence',
                  trailing: const Icon(Icons.chevron_right_rounded, color: TuneColors.textTertiary),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EqualizerView()),
                  ),
                ),
              ],
            ),
          ),
        ],

        // ---- Bibliothèque ----
        _SectionHeader(l.settingsSectionLibrary),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: [
              _SettingsTile(
                title: l.settingsSources,
                subtitle: l.settingsSourcesDesc,
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: TuneColors.textTertiary),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SourcesView()),
                ),
              ),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _SettingsTile(
                title: l.settingsMetadata,
                subtitle: l.settingsMetadataDesc,
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: TuneColors.textTertiary),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MetadataView()),
                ),
              ),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _SettingsTile(
                title: l.settingsSmb,
                subtitle: l.settingsSmbDesc,
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: TuneColors.textTertiary),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SMBSetupView()),
                ),
              ),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _SettingsTile(
                title: l.settingsSetupWizard,
                subtitle: l.settingsSetupWizardDesc,
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: TuneColors.textTertiary),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LibrarySetupView()),
                ),
              ),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _SettingsTile(
                title: 'Spotify Connect',
                subtitle: 'Tune comme récepteur (Premium requis côté client)',
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: TuneColors.textTertiary),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SpotifyConnectView()),
                ),
              ),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _SettingsTile(
                title: 'Last.fm Scrobble',
                subtitle: 'Scrobble listening history',
                trailing: const _LastfmStatusIndicator(),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LastfmView()),
                ),
              ),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _SettingsTile(
                title: 'Base de données',
                subtitle: 'Import / Export',
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: TuneColors.textTertiary),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DatabaseView()),
                ),
              ),
            ],
          ),
        ),

        // ---- Profiles ----
        if (app.apiClient != null) ...[
          const _SectionHeader('PROFILES'),
          _ProfilesSection(api: app.apiClient!),
        ],

        // ---- Systeme (Network Diagnostics, Config, Plugins) ----
        if (app.apiClient != null) ...[
          const _SectionHeader('SYSTEME'),
          Container(
            color: TuneColors.surface,
            child: Column(
              children: [
                _SettingsTile(
                  title: 'Diagnostics reseau',
                  subtitle: 'Multicast, DNS, connectivite',
                  trailing: const Icon(Icons.chevron_right_rounded, color: TuneColors.textTertiary),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NetworkDiagnosticsView()),
                  ),
                ),
                const Divider(height: 1, indent: 16, color: TuneColors.divider),
                _SettingsTile(
                  title: 'Configuration',
                  subtitle: 'Exporter / Importer',
                  trailing: const Icon(Icons.chevron_right_rounded, color: TuneColors.textTertiary),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ConfigExportView()),
                  ),
                ),
                const Divider(height: 1, indent: 16, color: TuneColors.divider),
                _SettingsTile(
                  title: 'Plugins',
                  subtitle: 'Extensions installees',
                  trailing: const Icon(Icons.chevron_right_rounded, color: TuneColors.textTertiary),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PluginsView()),
                  ),
                ),
                const Divider(height: 1, indent: 16, color: TuneColors.divider),
                _SettingsTile(
                  title: 'Partages reseau (SMB)',
                  subtitle: 'Decouvrir et monter des partages',
                  trailing: const Icon(Icons.chevron_right_rounded, color: TuneColors.textTertiary),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SMBBrowserView()),
                  ),
                ),
              ],
            ),
          ),
        ],

        // ---- À propos ----
        _SectionHeader(l.settingsSectionAbout),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: [
              _SettingsTile(
                title: 'Tune Server',
                subtitle: l.settingsVersion,
                trailing: const Icon(Icons.wifi_tethering_rounded,
                    color: TuneColors.accent),
              ),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _SettingsTile(
                title: l.settingsResetConfig,
                trailing: const Icon(Icons.restart_alt_rounded,
                    color: TuneColors.error),
                onTap: () => _confirmReset(context, settings),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _editPort(
      BuildContext context, SettingsState settings) async {
    final ctrl =
        TextEditingController(text: settings.serverPort.toString());
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(AppLocalizations.of(context).settingsPortTitle,
            style: TuneFonts.title3),
        content: TextField(
          controller: ctrl,
          style: TuneFonts.body,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).settingsPortHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context).btnCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('OK',
                style: TextStyle(color: TuneColors.accent)),
          ),
        ],
      ),
    );
    if (result == true) {
      final port = int.tryParse(ctrl.text.trim());
      if (port != null && port >= 1024 && port <= 65535) {
        await settings.setServerPort(port);
      }
    }
  }

  Future<void> _editRemoteHost(
      BuildContext context, SettingsState settings) async {
    final ctrl = TextEditingController(text: settings.remoteHost);
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text('Adresse serveur', style: TuneFonts.title3),
        content: TextField(
          controller: ctrl,
          style: TuneFonts.body,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(
              labelText: 'IP ou hostname (ex: 192.168.1.18)'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('OK',
                  style: TextStyle(color: TuneColors.accent))),
        ],
      ),
    );
    if (result == true && ctrl.text.trim().isNotEmpty) {
      await settings.setRemoteHost(ctrl.text.trim());
    }
  }

  Future<void> _editRemotePort(
      BuildContext context, SettingsState settings) async {
    final ctrl = TextEditingController(text: settings.remotePort.toString());
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text('Port serveur', style: TuneFonts.title3),
        content: TextField(
          controller: ctrl,
          style: TuneFonts.body,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Port (défaut: 8085)'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('OK',
                  style: TextStyle(color: TuneColors.accent))),
        ],
      ),
    );
    if (result == true) {
      final port = int.tryParse(ctrl.text.trim());
      if (port != null && port >= 1 && port <= 65535) {
        await settings.setRemotePort(port);
      }
    }
  }

  Future<void> _confirmReset(
      BuildContext context, SettingsState settings) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(AppLocalizations.of(context).settingsResetTitle,
            style: TuneFonts.title3),
        content: Text(AppLocalizations.of(context).settingsResetBody,
            style: TuneFonts.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context).btnCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context).btnReset,
                style: const TextStyle(color: TuneColors.error)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await settings.resetSetup();
    }
  }

  Future<void> _scanForServers(
      BuildContext context, SettingsState settings) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ServerScanDialog(settings: settings),
    );
  }
}

// ---------------------------------------------------------------------------
// Audio Diagnostic Section — zone count, outputs, network devices
// ---------------------------------------------------------------------------

class _AudioDiagnosticSection extends StatefulWidget {
  const _AudioDiagnosticSection();

  @override
  State<_AudioDiagnosticSection> createState() => _AudioDiagnosticSectionState();
}

class _AudioDiagnosticSectionState extends State<_AudioDiagnosticSection> {
  Map<String, dynamic>? _audioData;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadAudioCheck();
  }

  Future<void> _loadAudioCheck() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    setState(() => _loading = true);
    try {
      final data = await api.audioCheck();
      if (mounted) setState(() { _audioData = data; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final zoneState = context.watch<ZoneState>();
    final zones = zoneState.zones;
    final devices = zoneState.devices;

    // Categorize network devices
    final dlnaDevices = devices.where((d) => d.type == 'renderer').toList();
    final bluosDevices = devices.where((d) => d.type == 'bluos').toList();
    final chromecastDevices = devices.where((d) => d.type == 'chromecast').toList();
    final networkDeviceCount = dlnaDevices.length + bluosDevices.length + chromecastDevices.length;

    // Audio outputs from audio-check response
    final outputs = _audioData?['outputs'] as List<dynamic>? ?? [];
    final warnings = <String>[];

    if (zones.isEmpty) {
      warnings.add('Aucune zone configuree. Creez-en une pour commencer la lecture.');
    }
    if (networkDeviceCount == 0 && !app.isRemoteMode) {
      warnings.add('Aucun appareil reseau detecte (DLNA/BluOS/Chromecast).');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader('AUDIO'),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: [
              // Zone count
              ListTile(
                leading: Icon(
                  Icons.speaker_group_rounded,
                  color: zones.isNotEmpty ? TuneColors.success : TuneColors.warning,
                  size: 22,
                ),
                title: Text('Zones', style: TuneFonts.body),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${zones.length}',
                      style: TuneFonts.callout.copyWith(
                        color: zones.isNotEmpty
                            ? TuneColors.success
                            : TuneColors.warning,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (zones.isEmpty) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showCreateZoneDialog(context, app),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: TuneColors.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Creer',
                            style: TuneFonts.caption.copyWith(
                              color: TuneColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Divider(height: 1, indent: 56, color: TuneColors.divider),
              // Audio outputs (from server audio-check)
              ListTile(
                leading: Icon(
                  Icons.headphones_rounded,
                  color: outputs.isNotEmpty || !app.isRemoteConnected
                      ? TuneColors.accent
                      : TuneColors.warning,
                  size: 22,
                ),
                title: Text('Sorties audio', style: TuneFonts.body),
                trailing: _loading
                    ? const SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2, color: TuneColors.accent),
                      )
                    : Text(
                        app.isRemoteConnected
                            ? '${outputs.length} detectee${outputs.length != 1 ? "s" : ""}'
                            : 'Local',
                        style: TuneFonts.callout.copyWith(
                          color: TuneColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
              const Divider(height: 1, indent: 56, color: TuneColors.divider),
              // Network devices
              ListTile(
                leading: Icon(
                  Icons.cast_rounded,
                  color: networkDeviceCount > 0 ? TuneColors.success : TuneColors.textTertiary,
                  size: 22,
                ),
                title: Text('Appareils reseau', style: TuneFonts.body),
                subtitle: networkDeviceCount > 0
                    ? Text(
                        [
                          if (dlnaDevices.isNotEmpty) '${dlnaDevices.length} DLNA',
                          if (bluosDevices.isNotEmpty) '${bluosDevices.length} BluOS',
                          if (chromecastDevices.isNotEmpty) '${chromecastDevices.length} Chromecast',
                        ].join(' / '),
                        style: TuneFonts.caption,
                      )
                    : null,
                trailing: Text(
                  '$networkDeviceCount',
                  style: TuneFonts.callout.copyWith(
                    color: networkDeviceCount > 0
                        ? TuneColors.success
                        : TuneColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Warnings
              if (warnings.isNotEmpty) ...[
                const Divider(height: 1, indent: 16, color: TuneColors.divider),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: warnings.map((w) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              size: 16, color: TuneColors.warning),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              w,
                              style: TuneFonts.caption.copyWith(
                                color: TuneColors.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showCreateZoneDialog(BuildContext context, AppState app) async {
    final nameCtrl = TextEditingController(text: 'Zone 1');
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: const Text('Nouvelle zone', style: TuneFonts.title3),
        content: TextField(
          controller: nameCtrl,
          autofocus: true,
          style: TuneFonts.body,
          decoration: const InputDecoration(
            labelText: 'Nom de la zone',
            hintText: 'ex: Salon, Bureau',
            hintStyle: TextStyle(color: TuneColors.textTertiary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Creer'),
          ),
        ],
      ),
    );
    if (result == true && nameCtrl.text.trim().isNotEmpty) {
      await app.createZone(nameCtrl.text.trim());
    }
  }
}

// ---------------------------------------------------------------------------
// Composants UI partagés (utilisés aussi dans MetadataView)
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

class _SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: TuneColors.surface,
      title: Text(title, style: TuneFonts.body),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TuneFonts.footnote)
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}

// ---------------------------------------------------------------------------
// Profiles section — server-side profiles (GET/POST/PUT/DELETE /api/v1/profiles)
// ---------------------------------------------------------------------------

class _ProfilesSection extends StatefulWidget {
  final TuneApiClient api;
  const _ProfilesSection({required this.api});

  @override
  State<_ProfilesSection> createState() => _ProfilesSectionState();
}

class _ProfilesSectionState extends State<_ProfilesSection> {
  List<dynamic> _profiles = [];
  int? _activeProfileId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    setState(() => _loading = true);
    try {
      final data = await widget.api.getProfiles();
      if (mounted) {
        setState(() {
          _profiles = data;
          // Find active profile
          for (final p in data) {
            if (p is Map<String, dynamic> && p['active'] == true) {
              _activeProfileId = p['id'] as int?;
              break;
            }
          }
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _selectProfile(int id) async {
    try {
      await widget.api.updateProfile(id, {'active': true});
      setState(() => _activeProfileId = id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile activated'),
            backgroundColor: TuneColors.accent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: TuneColors.error,
          ),
        );
      }
    }
  }

  Future<void> _createProfile() async {
    final nameCtrl = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: const Text('New profile', style: TuneFonts.title3),
        content: TextField(
          controller: nameCtrl,
          autofocus: true,
          style: TuneFonts.body,
          decoration: const InputDecoration(
            labelText: 'Profile name',
            hintText: 'e.g. Evening, Morning',
            hintStyle: TextStyle(color: TuneColors.textTertiary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (result == true && nameCtrl.text.trim().isNotEmpty) {
      try {
        await widget.api.createProfile({'name': nameCtrl.text.trim()});
        _loadProfiles();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: TuneColors.error),
          );
        }
      }
    }
  }

  Future<void> _deleteProfile(int id) async {
    try {
      await widget.api.deleteProfile(id);
      _loadProfiles();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: TuneColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TuneColors.surface,
      child: Column(
        children: [
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: TuneColors.accent),
                ),
              ),
            )
          else if (_profiles.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No profiles',
                style: TuneFonts.footnote
                    .copyWith(color: TuneColors.textTertiary),
              ),
            )
          else
            ..._profiles.asMap().entries.map((entry) {
              final idx = entry.key;
              final p = entry.value as Map<String, dynamic>;
              final id = p['id'] as int? ?? 0;
              final name = p['name'] as String? ?? 'Profile';
              final isActive = id == _activeProfileId;
              return Column(
                children: [
                  if (idx > 0)
                    const Divider(
                        height: 1, indent: 56, color: TuneColors.divider),
                  ListTile(
                    leading: Icon(
                      isActive
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      color: isActive
                          ? TuneColors.accent
                          : TuneColors.textTertiary,
                    ),
                    title: Text(
                      name,
                      style: TuneFonts.body.copyWith(
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.normal,
                        color: isActive
                            ? TuneColors.accent
                            : TuneColors.textPrimary,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          size: 20, color: TuneColors.error),
                      onPressed: () => _deleteProfile(id),
                    ),
                    onTap: () => _selectProfile(id),
                  ),
                ],
              );
            }),
          const Divider(height: 1, indent: 16, color: TuneColors.divider),
          ListTile(
            leading: const Icon(Icons.add_rounded, color: TuneColors.accent),
            title: Text('New profile',
                style: TuneFonts.body.copyWith(color: TuneColors.accent)),
            onTap: _createProfile,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Server scan dialog — discovers Tune servers on the local subnet
// ---------------------------------------------------------------------------

class _ServerScanDialog extends StatefulWidget {
  final SettingsState settings;
  const _ServerScanDialog({required this.settings});

  @override
  State<_ServerScanDialog> createState() => _ServerScanDialogState();
}

class _ServerScanDialogState extends State<_ServerScanDialog> {
  bool _scanning = true;
  List<DiscoveredServer> _servers = [];
  String _statusText = 'Scan du réseau en cours...';

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  Future<void> _startScan() async {
    setState(() {
      _scanning = true;
      _servers = [];
      _statusText = 'Scan du réseau en cours...';
    });

    try {
      final servers = await ServerDiscovery.scan(
        onProgress: (scanned, total) {
          if (mounted) {
            setState(() {
              _statusText = 'Vérification $scanned/$total...';
            });
          }
        },
      );
      if (mounted) {
        setState(() {
          _scanning = false;
          _servers = servers;
          _statusText = servers.isEmpty
              ? 'Aucun serveur Tune trouvé'
              : '${servers.length} serveur${servers.length > 1 ? "s" : ""} trouvé${servers.length > 1 ? "s" : ""}';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _scanning = false;
          _statusText = 'Erreur: $e';
        });
      }
    }
  }

  void _selectServer(DiscoveredServer server) {
    widget.settings.setRemoteHost(server.host);
    widget.settings.setRemotePort(server.port);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: TuneColors.surface,
      title: Row(
        children: [
          const Icon(Icons.radar_rounded, color: TuneColors.accent, size: 24),
          const SizedBox(width: 10),
          Text('Serveurs Tune', style: TuneFonts.title3),
        ],
      ),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_scanning) ...[
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: TuneColors.accent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _statusText,
                      style: TuneFonts.footnote.copyWith(
                        color: TuneColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Text(
                _statusText,
                style: TuneFonts.footnote.copyWith(
                  color: _servers.isEmpty
                      ? TuneColors.textTertiary
                      : TuneColors.textSecondary,
                ),
              ),
            ],
            if (_servers.isNotEmpty) ...[
              const SizedBox(height: 12),
              ..._servers.map((server) => Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: TuneColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: TuneColors.divider,
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 2,
                      ),
                      leading: const Icon(
                        Icons.dns_rounded,
                        color: TuneColors.accent,
                        size: 22,
                      ),
                      title: Text(
                        server.displayName,
                        style: TuneFonts.body.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        '${server.host}:${server.port}'
                        '${server.version != null ? " — v${server.version}" : ""}',
                        style: TuneFonts.caption.copyWith(
                          color: TuneColors.textTertiary,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: TuneColors.textTertiary,
                      ),
                      onTap: () => _selectServer(server),
                    ),
                  )),
            ],
          ],
        ),
      ),
      actions: [
        if (!_scanning)
          TextButton.icon(
            onPressed: _startScan,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Rescanner'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fermer'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Last.fm status indicator — shows connection status inline in settings
// ---------------------------------------------------------------------------

class _LastfmStatusIndicator extends StatefulWidget {
  const _LastfmStatusIndicator();

  @override
  State<_LastfmStatusIndicator> createState() => _LastfmStatusIndicatorState();
}

class _LastfmStatusIndicatorState extends State<_LastfmStatusIndicator> {
  bool? _connected;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    try {
      final s = await api.getLastfmStatus();
      if (mounted) setState(() => _connected = s['connected'] == true);
    } catch (_) {
      // Silently fail — indicator stays hidden
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_connected != null)
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _connected! ? TuneColors.success : TuneColors.textTertiary,
              shape: BoxShape.circle,
            ),
          ),
        const Icon(Icons.chevron_right_rounded, color: TuneColors.textTertiary),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Audiophile Mode toggle — GET/POST /zones/{zoneId}/audiophile
// ---------------------------------------------------------------------------

class _AudiophileToggle extends StatefulWidget {
  const _AudiophileToggle();

  @override
  State<_AudiophileToggle> createState() => _AudiophileToggleState();
}

class _AudiophileToggleState extends State<_AudiophileToggle> {
  bool _enabled = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final api = context.read<AppState>().apiClient;
    final zoneId = context.read<ZoneState>().currentZoneId;
    if (api == null || zoneId == null) return;
    try {
      final data = await api.getAudiophileMode(zoneId);
      if (mounted) setState(() { _enabled = data['enabled'] == true; _loaded = true; });
    } catch (_) {
      if (mounted) setState(() => _loaded = true);
    }
  }

  Future<void> _toggle(bool value) async {
    final api = context.read<AppState>().apiClient;
    final zoneId = context.read<ZoneState>().currentZoneId;
    if (api == null || zoneId == null) return;
    setState(() => _enabled = value);
    try {
      await api.setAudiophileMode(zoneId, value);
    } catch (e) {
      if (mounted) {
        setState(() => _enabled = !value);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: TuneColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: TuneColors.surface,
      title: Text('Mode Audiophile', style: TuneFonts.body),
      subtitle: Text(
        'Bypass DSP, EQ desactive, bit-perfect',
        style: TuneFonts.footnote,
      ),
      trailing: Switch(
        value: _enabled,
        onChanged: _loaded ? _toggle : null,
        activeThumbColor: TuneColors.accent,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Streaming Quality selector — GET/POST /zones/{zoneId}/quality
// ---------------------------------------------------------------------------

class _StreamingQualitySelector extends StatefulWidget {
  const _StreamingQualitySelector();

  @override
  State<_StreamingQualitySelector> createState() => _StreamingQualitySelectorState();
}

class _StreamingQualitySelectorState extends State<_StreamingQualitySelector> {
  String _quality = 'maximum';
  bool _loaded = false;

  static const _qualities = [
    ('maximum', 'Maximum'),
    ('hires', 'Hi-Res'),
    ('cd', 'CD (16/44)'),
    ('economy', 'Economique'),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final api = context.read<AppState>().apiClient;
    final zoneId = context.read<ZoneState>().currentZoneId;
    if (api == null || zoneId == null) return;
    try {
      final data = await api.getStreamingQuality(zoneId);
      if (mounted) {
        setState(() {
          _quality = data['quality'] as String? ?? 'maximum';
          _loaded = true;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loaded = true);
    }
  }

  Future<void> _setQuality(String? value) async {
    if (value == null) return;
    final api = context.read<AppState>().apiClient;
    final zoneId = context.read<ZoneState>().currentZoneId;
    if (api == null || zoneId == null) return;
    final prev = _quality;
    setState(() => _quality = value);
    try {
      await api.setStreamingQuality(zoneId, value);
    } catch (e) {
      if (mounted) {
        setState(() => _quality = prev);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: TuneColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: TuneColors.surface,
      title: Text('Qualite streaming', style: TuneFonts.body),
      trailing: DropdownButton<String>(
        value: _quality,
        dropdownColor: TuneColors.surfaceVariant,
        underline: const SizedBox(),
        style: TuneFonts.body,
        items: _qualities.map((q) => DropdownMenuItem(
          value: q.$1,
          child: Text(q.$2),
        )).toList(),
        onChanged: _loaded ? _setQuality : null,
      ),
    );
  }
}
