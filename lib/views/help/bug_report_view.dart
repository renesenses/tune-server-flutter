import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// BugReportView — Generates a markdown bug report with device/server info.
// Remote mode: fetches from GET /api/v1/system/bug-report/markdown.
// Server mode: builds locally from device info + ServerEngine data.
// ---------------------------------------------------------------------------

class BugReportView extends StatefulWidget {
  const BugReportView({super.key});

  @override
  State<BugReportView> createState() => _BugReportViewState();
}

class _BugReportViewState extends State<BugReportView> {
  String? _report;
  bool _loading = true;
  String? _error;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  Future<void> _generate() async {
    setState(() {
      _loading = true;
      _error = null;
      _copied = false;
    });

    final app = context.read<AppState>();

    try {
      if (app.isRemoteMode && app.apiClient != null) {
        // Remote mode — fetch from server
        _report = await _fetchRemoteReport(app);
      } else {
        // Server mode — generate locally
        _report = await _generateLocalReport(app);
      }
    } catch (e) {
      _error = '$e';
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<String> _fetchRemoteReport(AppState app) async {
    try {
      final data = await app.apiClient!.getBugReportMarkdown();
      if (data is String) return data;
      if (data is Map && data['report'] is String) return data['report'] as String;
      // Fallback: generate locally even in remote mode
      return _generateLocalReport(app);
    } catch (_) {
      // Endpoint may not exist on all servers — fallback to local
      return _generateLocalReport(app);
    }
  }

  Future<String> _generateLocalReport(AppState app) async {
    final info = await PackageInfo.fromPlatform();
    final engine = app.engine;
    final zones = app.zoneState.zones;
    final devices = app.zoneState.devices;
    final trackCount = app.libraryState.tracks.length;
    final albumCount = app.libraryState.albums.length;
    final artistCount = app.libraryState.artists.length;

    final buf = StringBuffer();
    buf.writeln('# Tune Bug Report');
    buf.writeln();
    buf.writeln('## Appareil');
    buf.writeln('| Champ | Valeur |');
    buf.writeln('|-------|--------|');
    buf.writeln('| Plateforme | ${Platform.operatingSystem} |');
    buf.writeln('| OS Version | ${Platform.operatingSystemVersion} |');
    buf.writeln('| App Version | ${info.version} (build ${info.buildNumber}) |');
    buf.writeln('| Package | ${info.packageName} |');
    buf.writeln('| Dart | ${Platform.version.split(' ').first} |');
    buf.writeln();
    buf.writeln('## Serveur');
    buf.writeln('| Champ | Valeur |');
    buf.writeln('|-------|--------|');
    buf.writeln('| Mode | ${app.isRemoteMode ? "Remote" : "Serveur embarque"} |');
    buf.writeln('| IP locale | ${engine.localIp ?? "—"} |');
    buf.writeln('| Port | ${app.settingsState.serverPort} |');
    buf.writeln();
    buf.writeln('## Bibliotheque');
    buf.writeln('| Champ | Valeur |');
    buf.writeln('|-------|--------|');
    buf.writeln('| Pistes | $trackCount |');
    buf.writeln('| Albums | $albumCount |');
    buf.writeln('| Artistes | $artistCount |');
    buf.writeln();
    buf.writeln('## Zones');
    if (zones.isEmpty) {
      buf.writeln('Aucune zone configuree.');
    } else {
      buf.writeln('| Nom | Sortie | Etat |');
      buf.writeln('|-----|--------|------|');
      for (final z in zones) {
        buf.writeln('| ${z.name} | ${z.outputType?.name ?? "—"} | ${z.state.name} |');
      }
    }
    buf.writeln();
    buf.writeln('## Appareils reseau');
    if (devices.isEmpty) {
      buf.writeln('Aucun appareil detecte.');
    } else {
      buf.writeln('| Nom | Type |');
      buf.writeln('|-----|------|');
      for (final d in devices) {
        buf.writeln('| ${d.name} | ${d.type} |');
      }
    }
    buf.writeln();
    buf.writeln('## Description du probleme');
    buf.writeln();
    buf.writeln('<!-- Decrivez le probleme ici -->');
    buf.writeln();
    buf.writeln('## Etapes pour reproduire');
    buf.writeln();
    buf.writeln('1. ');
    buf.writeln('2. ');
    buf.writeln('3. ');
    buf.writeln();
    buf.writeln('---');
    buf.writeln('*Genere par Tune v${info.version}*');

    return buf.toString();
  }

  void _copyToClipboard() {
    if (_report == null) return;
    Clipboard.setData(ClipboardData(text: _report!));
    setState(() => _copied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rapport copie dans le presse-papiers'),
        backgroundColor: TuneColors.accent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Rapport de bug', style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: TuneColors.accent),
            onPressed: _generate,
            tooltip: 'Regenerer',
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: TuneColors.accent),
            )
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline_rounded,
                            color: TuneColors.error, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'Impossible de generer le rapport',
                          style: TuneFonts.body
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          style: TuneFonts.footnote,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: _generate,
                          icon: const Icon(Icons.refresh_rounded, size: 16),
                          label: const Text('Reessayer'),
                          style: FilledButton.styleFrom(
                            backgroundColor: TuneColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    // Action buttons
                    Container(
                      color: TuneColors.surface,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: _copyToClipboard,
                              icon: Icon(
                                _copied
                                    ? Icons.check_rounded
                                    : Icons.copy_rounded,
                                size: 16,
                              ),
                              label: Text(
                                  _copied ? 'Copie !' : 'Copier le rapport'),
                              style: FilledButton.styleFrom(
                                backgroundColor: _copied
                                    ? TuneColors.success
                                    : TuneColors.accent,
                                minimumSize: const Size.fromHeight(44),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Report preview
                    Expanded(
                      child: Container(
                        color: TuneColors.surface,
                        margin: const EdgeInsets.all(12),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: SelectableText(
                            _report ?? '',
                            style: TuneFonts.footnote.copyWith(
                              fontFamily: 'monospace',
                              color: TuneColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
