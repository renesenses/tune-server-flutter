import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/domain_models.dart';
import '../../state/app_state.dart';
import '../../state/settings_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'library_setup_view.dart';
import 'metadata_view.dart';

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
        title: const Text('Paramètres', style: TuneFonts.title3),
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
    final zones = context.select<ZoneState, List<ZoneWithState>>((z) => z.zones);
    final app = context.read<AppState>();

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        // ---- Apparence ----
        const _SectionHeader('Apparence'),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: [
              _SettingsTile(
                title: 'Thème',
                trailing: DropdownButton<String>(
                  value: settings.theme,
                  dropdownColor: TuneColors.surfaceVariant,
                  underline: const SizedBox(),
                  style: TuneFonts.body,
                  items: const [
                    DropdownMenuItem(value: 'system', child: Text('Système')),
                    DropdownMenuItem(value: 'light', child: Text('Clair')),
                    DropdownMenuItem(value: 'dark', child: Text('Sombre')),
                  ],
                  onChanged: (v) {
                    if (v != null) settings.setTheme(v);
                  },
                ),
              ),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _SettingsTile(
                title: 'Langue',
                trailing: DropdownButton<String?>(
                  value: settings.language,
                  dropdownColor: TuneColors.surfaceVariant,
                  underline: const SizedBox(),
                  style: TuneFonts.body,
                  items: const [
                    DropdownMenuItem<String?>(value: null, child: Text('Système')),
                    DropdownMenuItem(value: 'fr', child: Text('Français')),
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'de', child: Text('Deutsch')),
                    DropdownMenuItem(value: 'es', child: Text('Español')),
                    DropdownMenuItem(value: 'it', child: Text('Italiano')),
                    DropdownMenuItem(value: 'zh', child: Text('中文')),
                    DropdownMenuItem(value: 'ja', child: Text('日本語')),
                  ],
                  onChanged: (v) => settings.setLanguage(v),
                ),
              ),
            ],
          ),
        ),

        // ---- Zones ----
        const _SectionHeader('Zones'),
        Container(
          color: TuneColors.surface,
          child: _SettingsTile(
            title: 'Zone par défaut',
            trailing: zones.isEmpty
                ? const Text('Aucune zone',
                    style: TextStyle(color: TuneColors.textTertiary))
                : DropdownButton<int?>(
                    value: settings.defaultZoneId,
                    dropdownColor: TuneColors.surfaceVariant,
                    underline: const SizedBox(),
                    style: TuneFonts.body,
                    items: [
                      const DropdownMenuItem<int?>(
                          value: null, child: Text('Automatique')),
                      ...zones.map((z) => DropdownMenuItem<int?>(
                            value: z.id,
                            child: Text(z.name),
                          )),
                    ],
                    onChanged: (v) => settings.setDefaultZoneId(v),
                  ),
          ),
        ),

        // ---- Serveur ----
        const _SectionHeader('Serveur'),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: [
              _SettingsTile(
                title: 'Port HTTP',
                subtitle: 'Port du serveur principal',
                trailing: Text(
                  settings.serverPort.toString(),
                  style: const TextStyle(color: TuneColors.textSecondary),
                ),
                onTap: () => _editPort(context, settings),
              ),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _SettingsTile(
                title: 'Adresse IP locale',
                trailing: Text(
                  app.engine.localIp ?? '—',
                  style: const TextStyle(
                      color: TuneColors.textSecondary, fontSize: 13),
                ),
              ),
            ],
          ),
        ),

        // ---- Bibliothèque ----
        const _SectionHeader('Bibliothèque'),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: [
              _SettingsTile(
                title: 'Musique & Métadonnées',
                subtitle: 'Dossiers, scan, statistiques',
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: TuneColors.textTertiary),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MetadataView()),
                ),
              ),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _SettingsTile(
                title: 'Assistant de configuration',
                subtitle: 'Reconfigurer les sources musicales',
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: TuneColors.textTertiary),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LibrarySetupView()),
                ),
              ),
            ],
          ),
        ),

        // ---- À propos ----
        const _SectionHeader('À propos'),
        Container(
          color: TuneColors.surface,
          child: Column(
            children: [
              const _SettingsTile(
                title: 'Tune Server',
                subtitle: 'Version 0.1.0',
                trailing: Icon(Icons.wifi_tethering_rounded,
                    color: TuneColors.accent),
              ),
              const Divider(height: 1, indent: 16, color: TuneColors.divider),
              _SettingsTile(
                title: 'Réinitialiser la configuration',
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
        title: const Text('Port HTTP', style: TuneFonts.title3),
        content: TextField(
          controller: ctrl,
          style: TuneFonts.body,
          keyboardType: TextInputType.number,
          decoration:
              const InputDecoration(labelText: 'Port (1024–65535)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
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

  Future<void> _confirmReset(
      BuildContext context, SettingsState settings) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: const Text('Réinitialiser ?', style: TuneFonts.title3),
        content: const Text(
          'Toutes les préférences seront réinitialisées. L\'assistant de démarrage s\'affichera au prochain lancement.',
          style: TuneFonts.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Réinitialiser',
                style: TextStyle(color: TuneColors.error)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await settings.resetSetup();
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
