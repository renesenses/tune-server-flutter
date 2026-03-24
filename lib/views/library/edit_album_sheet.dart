import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// T12.7 — EditAlbumSheet
// Bottom sheet pour éditer titre, artiste, année, genre d'un album.
// Miroir de EditAlbumSheet.swift (iOS)
// ---------------------------------------------------------------------------

class EditAlbumSheet extends StatefulWidget {
  final Album album;
  const EditAlbumSheet({super.key, required this.album});

  @override
  State<EditAlbumSheet> createState() => _EditAlbumSheetState();
}

class _EditAlbumSheetState extends State<EditAlbumSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _artistCtrl;
  late final TextEditingController _yearCtrl;
  late final TextEditingController _genreCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl  = TextEditingController(text: widget.album.title);
    _artistCtrl = TextEditingController(text: widget.album.artistName ?? '');
    _yearCtrl   = TextEditingController(
        text: widget.album.year?.toString() ?? '');
    _genreCtrl  = TextEditingController(text: widget.album.genre ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _artistCtrl.dispose();
    _yearCtrl.dispose();
    _genreCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20, 20, 20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: TuneColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Modifier l\'album', style: TuneFonts.title3),
          const SizedBox(height: 20),
          _Field(label: 'Titre', controller: _titleCtrl),
          const SizedBox(height: 12),
          _Field(label: 'Artiste', controller: _artistCtrl),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _Field(label: 'Année', controller: _yearCtrl,
                  keyboardType: TextInputType.number)),
              const SizedBox(width: 12),
              Expanded(child: _Field(label: 'Genre', controller: _genreCtrl)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: TuneColors.accent),
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Enregistrer'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;
    setState(() => _saving = true);

    final updated = widget.album.copyWith(
      title:      title,
      artistName: Value(_artistCtrl.text.trim().isEmpty
          ? null
          : _artistCtrl.text.trim()),
      year:       Value(int.tryParse(_yearCtrl.text.trim())),
      genre:      Value(_genreCtrl.text.trim().isEmpty
          ? null
          : _genreCtrl.text.trim()),
    );

    await context.read<AppState>().updateAlbum(updated);
    if (mounted) Navigator.of(context).pop();
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const _Field({
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TuneFonts.body,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TuneFonts.footnote,
        filled: true,
        fillColor: TuneColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
