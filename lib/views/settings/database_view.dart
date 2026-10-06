import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

/// Database management — Import / Export the server DB via REST API.
class DatabaseView extends StatefulWidget {
  const DatabaseView({super.key});

  @override
  State<DatabaseView> createState() => _DatabaseViewState();
}

class _DatabaseViewState extends State<DatabaseView> {
  bool _exporting = false;
  bool _importing = false;
  String _message = '';
  bool _error = false;

  Future<void> _export() async {
    final l = AppLocalizations.of(context);
    final app = context.read<AppState>();
    final api = app.apiClient;
    if (api == null) {
      setState(() {
        _message = l.cfgDbNoServer;
        _error = true;
      });
      return;
    }

    setState(() {
      _exporting = true;
      _message = '';
      _error = false;
    });

    try {
      final dir = await getApplicationDocumentsDirectory();
      final ts = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
      final savePath = '${dir.path}/tune_server_$ts.db';
      final result = await api.exportDatabase(savePath: savePath);
      final sizeMb = (result['size'] as int) / 1024 / 1024;
      if (!mounted) return;
      setState(() {
        _message = l.cfgDbExportOk(
            sizeMb.toStringAsFixed(1), '${result['path']}');
        _error = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _message = l.errorWith(e.toString());
        _error = true;
      });
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _import() async {
    final l = AppLocalizations.of(context);
    final app = context.read<AppState>();
    final api = app.apiClient;
    if (api == null) {
      setState(() {
        _message = l.cfgDbNoServer;
        _error = true;
      });
      return;
    }

    final pick = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['db', 'sqlite', 'sqlite3', 'sql'],
    );
    if (pick == null || pick.files.isEmpty) return;
    final picked = pick.files.first;
    final path = picked.path;
    if (path == null) {
      setState(() {
        _message = l.cfgDbPathUnavailable;
        _error = true;
      });
      return;
    }

    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.cfgDbImportConfirmTitle, style: TuneFonts.title3),
        content: Text(
          l.cfgDbImportConfirmBody(picked.name),
          style: TuneFonts.body,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.btnCancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: TuneColors.error),
            child: Text(l.btnImport),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() {
      _importing = true;
      _message = '';
      _error = false;
    });

    try {
      final result = await api.importDatabase(path);
      final sizeMb = (result['size'] as int) / 1024 / 1024;
      if (!mounted) return;
      setState(() {
        _message = l.cfgDbImportOk(
            sizeMb.toStringAsFixed(1), '${result['engine']}');
        _error = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _message = l.errorWith(e.toString());
        _error = true;
      });
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(l.cfgDbTitle, style: TuneFonts.title3),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l.cfgDbIntro,
            style: TuneFonts.footnote,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _exporting || _importing ? null : _export,
              icon: _exporting
                  ? const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.download),
              label: Text(_exporting ? l.cfgDbExporting : l.cfgDbExportBtn),
              style: FilledButton.styleFrom(
                backgroundColor: TuneColors.accent,
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _exporting || _importing ? null : _import,
              icon: _importing
                  ? const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.upload),
              label: Text(_importing ? l.cfgDbImporting : l.cfgDbImportBtn),
              style: FilledButton.styleFrom(
                backgroundColor: TuneColors.surfaceVariant,
                foregroundColor: TuneColors.textPrimary,
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ),
          if (_message.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _error
                    ? TuneColors.error.withValues(alpha: 0.15)
                    : TuneColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _message,
                style: _error
                    ? const TextStyle(fontSize: 13, color: TuneColors.error)
                    : TuneFonts.footnote,
              ),
            ),
          ],
          const SizedBox(height: 24),
          const _Separator(),
          const SizedBox(height: 16),
          Text(
            l.cfgDbFooter,
            style: TuneFonts.footnote,
          ),
        ],
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator();
  @override
  Widget build(BuildContext context) => Container(
        height: 1,
        color: TuneColors.divider,
      );
}

// Re-export File to avoid unused import warning (FilePicker returns path, we use File implicitly)
// ignore: unused_element
File? _unused;
