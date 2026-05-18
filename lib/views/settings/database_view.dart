import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

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
    final app = context.read<AppState>();
    final api = app.apiClient;
    if (api == null) {
      setState(() {
        _message = 'Aucun serveur connecté.';
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
        _message = 'Export OK : ${sizeMb.toStringAsFixed(1)} MB\n${result['path']}';
        _error = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _message = 'Erreur : $e';
        _error = true;
      });
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _import() async {
    final app = context.read<AppState>();
    final api = app.apiClient;
    if (api == null) {
      setState(() {
        _message = 'Aucun serveur connecté.';
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
        _message = 'Chemin du fichier inaccessible.';
        _error = true;
      });
      return;
    }

    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: const Text('Confirmer l\'import', style: TuneFonts.title3),
        content: Text(
          'Remplacer la base de données du serveur avec "${picked.name}" ?\n\n'
          'Un backup de sécurité sera créé automatiquement. Le serveur devra être redémarré après l\'import.',
          style: TuneFonts.body,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: TuneColors.error),
            child: const Text('Importer'),
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
        _message = 'Import OK : ${sizeMb.toStringAsFixed(1)} MB (${result['engine']}).\n'
            'Redémarre le serveur pour appliquer les changements.';
        _error = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _message = 'Erreur : $e';
        _error = true;
      });
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Base de données', style: TuneFonts.title3),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Exporte ou importe la base de données du serveur connecté.\n'
            'SQLite : fichier .db. PostgreSQL : dump SQL.',
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
              label: Text(_exporting ? 'Export en cours...' : 'Exporter la base'),
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
              label: Text(_importing ? 'Import en cours...' : 'Importer un fichier'),
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
          const Text(
            'Après un import, redémarre le serveur pour appliquer les changements. '
            'Un backup de sécurité est créé automatiquement avant le remplacement.',
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
