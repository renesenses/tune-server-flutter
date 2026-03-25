import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// T12.7 — EditTrackSheet
// Bottom sheet pour éditer titre, artiste, album, piste n°, disque n°.
// Miroir de EditTrackSheet.swift (iOS)
// ---------------------------------------------------------------------------

class EditTrackSheet extends StatefulWidget {
  final Track track;
  const EditTrackSheet({super.key, required this.track});

  @override
  State<EditTrackSheet> createState() => _EditTrackSheetState();
}

class _EditTrackSheetState extends State<EditTrackSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _artistCtrl;
  late final TextEditingController _albumCtrl;
  late final TextEditingController _trackNumCtrl;
  late final TextEditingController _discNumCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl    = TextEditingController(text: widget.track.title);
    _artistCtrl   = TextEditingController(text: widget.track.artistName ?? '');
    _albumCtrl    = TextEditingController(text: widget.track.albumTitle ?? '');
    _trackNumCtrl = TextEditingController(
        text: widget.track.trackNumber?.toString() ?? '');
    _discNumCtrl  = TextEditingController(
        text: widget.track.discNumber?.toString() ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _artistCtrl.dispose();
    _albumCtrl.dispose();
    _trackNumCtrl.dispose();
    _discNumCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
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
          Text(l.libraryEditTrack, style: TuneFonts.title3),
          const SizedBox(height: 20),
          _Field(label: 'Titre', controller: _titleCtrl),
          const SizedBox(height: 12),
          _Field(label: 'Artiste', controller: _artistCtrl),
          const SizedBox(height: 12),
          _Field(label: 'Album', controller: _albumCtrl),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _Field(
                  label: 'Piste n°',
                  controller: _trackNumCtrl,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Field(
                  label: 'Disque n°',
                  controller: _discNumCtrl,
                  keyboardType: TextInputType.number,
                ),
              ),
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
                  : Text(l.btnSave),
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

    final updated = widget.track.copyWith(
      title:       title,
      artistName:  Value(_artistCtrl.text.trim().isEmpty
          ? null : _artistCtrl.text.trim()),
      albumTitle:  Value(_albumCtrl.text.trim().isEmpty
          ? null : _albumCtrl.text.trim()),
      trackNumber: Value(int.tryParse(_trackNumCtrl.text.trim())),
      discNumber:  Value(int.tryParse(_discNumCtrl.text.trim())),
    );

    await context.read<AppState>().updateTrack(updated);
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
