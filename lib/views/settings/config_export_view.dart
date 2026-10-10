import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// ConfigExportView — Export/Import server configuration as JSON
// API: GET /system/config/export, POST /system/config/import
// ---------------------------------------------------------------------------

class ConfigExportView extends StatefulWidget {
  const ConfigExportView({super.key});

  @override
  State<ConfigExportView> createState() => _ConfigExportViewState();
}

class _ConfigExportViewState extends State<ConfigExportView> {
  bool _exporting = false;
  bool _importing = false;
  String? _message;
  bool _isError = false;

  Future<void> _exportConfig() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    final l = AppLocalizations.of(context);
    setState(() { _exporting = true; _message = null; });
    try {
      final data = await api.exportConfig();
      final json = const JsonEncoder.withIndent('  ').convert(data);

      // Save to downloads/documents
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
      final file = File('${dir.path}/tune-config-$timestamp.json');
      await file.writeAsString(json);

      if (mounted) {
        setState(() {
          _exporting = false;
          _message = l.cfgConfigExported(file.path);
          _isError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() { _exporting = false; _message = l.errorWith(e.toString()); _isError = true; });
      }
    }
  }

  Future<void> _importConfig() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    final l = AppLocalizations.of(context);

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null || result.files.isEmpty) return;

    final path = result.files.single.path;
    if (path == null) return;

    setState(() { _importing = true; _message = null; });
    try {
      final content = await File(path).readAsString();
      final config = jsonDecode(content) as Map<String, dynamic>;
      final response = await api.importConfig(config);
      if (mounted) {
        final msg = response['message'] as String? ?? l.cfgConfigImported;
        setState(() { _importing = false; _message = msg; _isError = false; });
      }
    } catch (e) {
      if (mounted) {
        setState(() { _importing = false; _message = l.cfgImportError(e.toString()); _isError = true; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(l.onboardingConfigTitle, style: TuneFonts.title3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Export section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: TuneColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.upload_file_rounded, color: TuneColors.accent, size: 24),
                      const SizedBox(width: 12),
                      Text(l.btnExport, style: const TextStyle(
                        color: TuneColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      )),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.cfgConfigExportDesc,
                    style: TuneFonts.footnote.copyWith(color: TuneColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _exporting ? null : _exportConfig,
                    icon: _exporting
                        ? const SizedBox(
                            width: 16, height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.download_rounded, size: 18),
                    label: Text(l.cfgConfigExportJson),
                    style: FilledButton.styleFrom(
                      backgroundColor: TuneColors.accent,
                      minimumSize: const Size.fromHeight(44),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Import section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: TuneColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.file_open_rounded, color: TuneColors.warning, size: 24),
                      const SizedBox(width: 12),
                      Text(l.btnImport, style: const TextStyle(
                        color: TuneColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      )),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.cfgConfigImportDesc,
                    style: TuneFonts.footnote.copyWith(color: TuneColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _importing ? null : _importConfig,
                    icon: _importing
                        ? const SizedBox(
                            width: 16, height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: TuneColors.accent),
                          )
                        : const Icon(Icons.folder_open_rounded, size: 18),
                    label: Text(l.cfgChooseFile),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: TuneColors.accent,
                      side: const BorderSide(color: TuneColors.accent),
                      minimumSize: const Size.fromHeight(44),
                    ),
                  ),
                ],
              ),
            ),
            // Message
            if (_message != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (_isError ? TuneColors.error : TuneColors.success).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
                      color: _isError ? TuneColors.error : TuneColors.success,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _message!,
                        style: TuneFonts.caption.copyWith(
                          color: _isError ? TuneColors.error : TuneColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
