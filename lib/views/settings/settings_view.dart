import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';
import '../../state/settings_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'library_setup_view.dart';
import 'metadata_view.dart';
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
    final app = context.read<AppState>();

    final l = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
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
