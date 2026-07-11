import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../../services/auth_service.dart';
import '../../services/server_discovery.dart';
import '../../services/tune_api_client.dart';
import '../../state/app_state.dart';
import '../../state/settings_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'auto_fix_view.dart';
import 'config_export_view.dart';
import 'database_view.dart';
import 'equalizer_view.dart';
import 'lastfm_view.dart';
import 'listenbrainz_view.dart';
import 'network_diagnostics_view.dart';
import 'plugins_view.dart';
import 'smb_browser_view.dart';
import 'spotify_connect_view.dart';
import 'library_setup_view.dart';
import 'metadata_fields_view.dart';
import 'metadata_view.dart';
import 'server_config_view.dart';
import 'smb_setup_view.dart';
import 'sources_view.dart';
import '../help/bug_report_view.dart';
import '../help/troubleshooting_view.dart';

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
                  onTap: () => _editRemotePort(context, settings),
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
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _SettingsTile(
                title: 'Lire en boucle par défaut',
                trailing: Switch(
                  value: settings.repeatOneByDefault,
                  onChanged: (v) => settings.setRepeatOneByDefault(v),
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

        // ---- Champs métadonnées ----
        const _SectionHeader('CHAMPS METADONNEES'),
        const _MetadataFieldsToggleSection(),

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
                  title: 'Equalizer',
                  subtitle: 'Assistant de calibration + EQ 10 bandes expert',
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
              if (app.apiClient != null) ...[
                const Divider(height: 1, indent: 16, color: TuneColors.divider),
                _SettingsTile(
                  title: 'Champs de metadonnees',
                  subtitle: 'Configurer les champs etendus (compositeur, chef...)',
                  trailing: const Icon(Icons.chevron_right_rounded,
                      color: TuneColors.textTertiary),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MetadataFieldsView()),
                  ),
                ),
              ],
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
                title: 'ListenBrainz',
                subtitle: 'Scrobble to ListenBrainz',
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: TuneColors.textTertiary),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ListenBrainzView()),
                ),
              ),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _SettingsTile(
                title: 'Auto Fix Metadata',
                subtitle: 'Fix missing genre, year, MBID via MusicBrainz',
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: TuneColors.textTertiary),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AutoFixView()),
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
                  title: 'Configuration serveur',
                  subtitle: 'Dossiers musicaux, scan, redemarrage',
                  trailing: const Icon(Icons.chevron_right_rounded, color: TuneColors.textTertiary),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ServerConfigView()),
                  ),
                ),
                const Divider(height: 1, indent: 16, color: TuneColors.divider),
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

        // ---- Cloud ----
        if (app.apiClient != null) ...[
          const _SectionHeader('CLOUD'),
          _CloudSection(api: app.apiClient!),
        ],

        // ---- Aide ----
        const _SectionHeader('AIDE'),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: [
              _SettingsTile(
                title: 'Depannage',
                subtitle: 'Questions frequentes et solutions',
                trailing: const Icon(Icons.chevron_right_rounded, color: TuneColors.textTertiary),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TroubleshootingView()),
                ),
              ),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _SettingsTile(
                title: 'Envoyer un rapport de bug',
                subtitle: 'Generer et copier un rapport technique',
                trailing: const Icon(Icons.chevron_right_rounded, color: TuneColors.textTertiary),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BugReportView()),
                ),
              ),
            ],
          ),
        ),

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
          decoration: const InputDecoration(labelText: 'Port (défaut: 8888)'),
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

  Future<void> _editProfile(Map<String, dynamic> profile) async {
    final id = profile['id'] as int? ?? 0;
    final currentName = profile['name'] as String? ?? '';
    final currentColor = profile['avatar_color'] as String? ?? '#6366f1';

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => _ProfileEditDialog(
        initialName: currentName,
        initialColor: currentColor,
      ),
    );

    if (result == null) return;
    try {
      await widget.api.updateProfile(id, {
        'name': result['name'],
        'avatar_color': result['color'],
      });
      _loadProfiles();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated'),
            backgroundColor: TuneColors.accent,
          ),
        );
      }
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
              final colorHex = p['avatar_color'] as String? ?? '#6366f1';
              final avatarColor = _hexToColor(colorHex);
              final isActive = id == _activeProfileId;
              return Column(
                children: [
                  if (idx > 0)
                    const Divider(
                        height: 1, indent: 56, color: TuneColors.divider),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor: avatarColor,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isActive)
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: TuneColors.accent,
                          ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              size: 18, color: TuneColors.textSecondary),
                          onPressed: () => _editProfile(p),
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded,
                              size: 18, color: TuneColors.error),
                          onPressed: () => _deleteProfile(id),
                          tooltip: 'Delete',
                        ),
                      ],
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

  static Color _hexToColor(String hex) {
    final cleaned = hex.replaceAll('#', '');
    try {
      return Color(int.parse('FF$cleaned', radix: 16));
    } catch (_) {
      return const Color(0xFF6C63FF);
    }
  }
}

// ---------------------------------------------------------------------------
// Profile Edit Dialog — name + avatar color picker
// Mirrors the web client's ProfileSelector edit modal (ProfileSelector.svelte)
// ---------------------------------------------------------------------------

class _ProfileEditDialog extends StatefulWidget {
  final String initialName;
  final String initialColor;

  const _ProfileEditDialog({
    required this.initialName,
    required this.initialColor,
  });

  @override
  State<_ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<_ProfileEditDialog> {
  late final TextEditingController _nameCtrl;
  late String _selectedColor;

  static const _avatarColors = [
    '#6366f1', // indigo
    '#f59e0b', // amber
    '#10b981', // emerald
    '#ec4899', // pink
    '#8b5cf6', // violet
    '#14b8a6', // teal
    '#ef4444', // red
    '#3b82f6', // blue
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    // Normalize: match against known colors or keep as-is
    _selectedColor = _avatarColors.contains(widget.initialColor)
        ? widget.initialColor
        : _avatarColors.first;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Color _hex(String hex) {
    final cleaned = hex.replaceAll('#', '');
    try {
      return Color(int.parse('FF$cleaned', radix: 16));
    } catch (_) {
      return const Color(0xFF6366F1);
    }
  }

  void _save() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop({'name': name, 'color': _selectedColor});
  }

  @override
  Widget build(BuildContext context) {
    final previewName = _nameCtrl.text.trim();
    final previewInitial =
        previewName.isNotEmpty ? previewName[0].toUpperCase() : '?';

    return AlertDialog(
      backgroundColor: TuneColors.surface,
      title: const Text('Edit profile', style: TuneFonts.title3),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview avatar + name
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: _hex(_selectedColor),
                  child: Text(
                    previewInitial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    previewName.isEmpty ? '...' : previewName,
                    style: TuneFonts.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Name field
            Text(
              'Name',
              style: TuneFonts.caption.copyWith(
                color: TuneColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _nameCtrl,
              autofocus: true,
              style: TuneFonts.body,
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _save(),
              decoration: InputDecoration(
                hintText: 'Profile name',
                hintStyle: const TextStyle(color: TuneColors.textTertiary),
                filled: true,
                fillColor: TuneColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: TuneColors.accent, width: 1.5),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 20),
            // Color picker
            Text(
              'Color',
              style: TuneFonts.caption.copyWith(
                color: TuneColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _avatarColors.map((hex) {
                final isSelected = hex == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = hex),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _hex(hex),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 2.5)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: _hex(hex).withValues(alpha: 0.6),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check_rounded,
                            size: 16, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel',
              style: TextStyle(color: TuneColors.textSecondary)),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: TuneColors.accent,
          ),
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
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
// _MetadataFieldsToggleSection — toggles for metadata chips shown under tracks
// ---------------------------------------------------------------------------

class _MetadataFieldsToggleSection extends StatelessWidget {
  const _MetadataFieldsToggleSection();

  static const _allFields = [
    ('format',      'Format (FLAC, MP3…)'),
    ('sample_rate', 'Fréquence (96kHz)'),
    ('bit_depth',   'Profondeur (24bit)'),
    ('genre',       'Genre'),
    ('year',        'Année'),
    ('label',       'Label'),
    ('composer',    'Compositeur'),
    ('duration',    'Durée'),
    ('source',      'Source (Tidal, Qobuz…)'),
  ];

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();
    final selected = settings.metadataDisplayFields;

    return Container(
      color: TuneColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Text(
              'Champs affichés sous chaque piste (recherche, bibliothèque, file, historique)',
              style: TuneFonts.caption.copyWith(color: TuneColors.textSecondary),
            ),
          ),
          ..._allFields.map((fieldDef) {
            final (key, label) = fieldDef;
            final isEnabled = selected.contains(key);
            return Column(
              children: [
                const Divider(height: 1, indent: 16, color: TuneColors.divider),
                SwitchListTile(
                  dense: true,
                  title: Text(label, style: TuneFonts.body),
                  value: isEnabled,
                  onChanged: (_) {
                    final next = List<String>.from(selected);
                    if (isEnabled) {
                      next.remove(key);
                    } else {
                      next.add(key);
                    }
                    settings.setMetadataDisplayFields(next);
                  },
                  activeThumbColor: TuneColors.accent,
                ),
              ],
            );
          }),
          const SizedBox(height: 4),
        ],
      ),
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
// Streaming Quality selector — PATCH /api/v1/system/config
// Two independent caps: max_sample_rate + max_bit_depth.
// null = no limit (server default).
// ---------------------------------------------------------------------------

class _StreamingQualitySelector extends StatefulWidget {
  const _StreamingQualitySelector();

  @override
  State<_StreamingQualitySelector> createState() => _StreamingQualitySelectorState();
}

class _StreamingQualitySelectorState extends State<_StreamingQualitySelector> {
  // null means "No limit"
  int? _maxSampleRate;
  int? _maxBitDepth;
  bool _loaded = false;

  static const _rates = [44100, 48000, 96000, 192000];
  static const _depths = [16, 24, 32];

  String _rateLabel(int hz) {
    final khz = hz / 1000;
    final s = khz % 1 == 0 ? khz.toStringAsFixed(0) : khz.toStringAsFixed(1);
    return '$s kHz';
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    try {
      final data = await api.getSystemConfig();
      if (mounted) {
        setState(() {
          _maxSampleRate = data['max_sample_rate'] as int?;
          _maxBitDepth = data['max_bit_depth'] as int?;
          _loaded = true;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loaded = true);
    }
  }

  Future<void> _patch(Map<String, dynamic> fields) async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    try {
      await api.updateSystemConfig(fields);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: TuneColors.error),
        );
      }
    }
  }

  Future<void> _setRate(int? value) async {
    final prev = _maxSampleRate;
    setState(() => _maxSampleRate = value);
    try {
      await _patch({'max_sample_rate': value});
    } catch (_) {
      if (mounted) setState(() => _maxSampleRate = prev);
    }
  }

  Future<void> _setDepth(int? value) async {
    final prev = _maxBitDepth;
    setState(() => _maxBitDepth = value);
    try {
      await _patch({'max_bit_depth': value});
    } catch (_) {
      if (mounted) setState(() => _maxBitDepth = prev);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget row(String label, Widget dropdown) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(child: Text(label, style: TuneFonts.body)),
              dropdown,
            ],
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        row(
          'Freq. max',
          DropdownButton<int?>(
            value: _maxSampleRate,
            dropdownColor: TuneColors.surfaceVariant,
            underline: const SizedBox(),
            style: TuneFonts.body,
            onChanged: _loaded ? _setRate : null,
            items: [
              const DropdownMenuItem<int?>(value: null, child: Text('Sans limite')),
              for (final r in _rates)
                DropdownMenuItem<int?>(value: r, child: Text(_rateLabel(r))),
            ],
          ),
        ),
        const Divider(height: 1, indent: 16, color: TuneColors.divider),
        row(
          'Bits max',
          DropdownButton<int?>(
            value: _maxBitDepth,
            dropdownColor: TuneColors.surfaceVariant,
            underline: const SizedBox(),
            style: TuneFonts.body,
            onChanged: _loaded ? _setDepth : null,
            items: [
              const DropdownMenuItem<int?>(value: null, child: Text('Sans limite')),
              for (final d in _depths)
                DropdownMenuItem<int?>(value: d, child: Text('$d-bit')),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Cloud section — SSO status + telemetry toggle
// GET/POST /api/v1/cloud/telemetry/status, /enable, /disable
// ---------------------------------------------------------------------------

class _CloudSection extends StatefulWidget {
  final TuneApiClient api;
  const _CloudSection({required this.api});

  @override
  State<_CloudSection> createState() => _CloudSectionState();
}

class _CloudSectionState extends State<_CloudSection> {
  bool _telemetryEnabled = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    setState(() => _loading = true);
    try {
      final data = await widget.api.getCloudTelemetryStatus();
      if (mounted) {
        setState(() {
          _telemetryEnabled = data['enabled'] == true;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggleTelemetry(bool value) async {
    final prev = _telemetryEnabled;
    setState(() => _telemetryEnabled = value);
    try {
      if (value) {
        await widget.api.enableCloudTelemetry();
      } else {
        await widget.api.disableCloudTelemetry();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _telemetryEnabled = prev);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: TuneColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final isConnected = auth.isLoggedIn;

    return Container(
      color: TuneColors.surface,
      child: Column(
        children: [
          // SSO Status
          ListTile(
            tileColor: TuneColors.surface,
            leading: Icon(
              isConnected
                  ? Icons.cloud_done_rounded
                  : Icons.cloud_off_rounded,
              color: isConnected ? TuneColors.success : TuneColors.textTertiary,
              size: 22,
            ),
            title: Text('Compte cloud', style: TuneFonts.body),
            subtitle: Text(
              isConnected
                  ? 'Connecte${auth.email != null ? " (${auth.email})" : ""}'
                  : 'Non connecte',
              style: TuneFonts.footnote.copyWith(
                color: isConnected ? TuneColors.success : TuneColors.textTertiary,
              ),
            ),
            trailing: isConnected
                ? TextButton(
                    onPressed: () async {
                      await auth.logout();
                      if (context.mounted) {
                        context.read<AppState>().setAuthToken(null);
                      }
                    },
                    child: Text(
                      'Deconnecter',
                      style: TuneFonts.caption.copyWith(color: TuneColors.error),
                    ),
                  )
                : null,
          ),
          const Divider(height: 1, indent: 16, color: TuneColors.divider),
          // Telemetry toggle
          ListTile(
            tileColor: TuneColors.surface,
            title: Text('Telemetrie', style: TuneFonts.body),
            subtitle: Text(
              'Envoyer des statistiques d\'utilisation anonymes',
              style: TuneFonts.footnote,
            ),
            trailing: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: TuneColors.accent,
                    ),
                  )
                : Switch(
                    value: _telemetryEnabled,
                    onChanged: _toggleTelemetry,
                    activeThumbColor: TuneColors.accent,
                  ),
          ),
        ],
      ),
    );
  }
}
