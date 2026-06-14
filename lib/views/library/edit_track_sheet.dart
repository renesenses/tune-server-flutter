import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/metadata_fields.dart';
import '../../server/database/database.dart';
import '../../services/tune_api_client.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import '../tags/tag_chips_widget.dart';

// ---------------------------------------------------------------------------
// T12.7 — EditTrackSheet
// Bottom sheet pour éditer titre, artiste, album, piste n°, disque n°
// + champs de metadonnees etendues (compositeur, chef d'orchestre...).
// Miroir de EditTrackSheet.swift (iOS) + TrackEditModal.svelte (web)
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

  // Extended metadata state
  MetadataFieldsResponse? _extFields;
  Map<String, String> _extOriginal = {};
  final Map<String, TextEditingController> _extControllers = {};
  bool _extLoading = true;

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
    _loadExtendedMetadata();
  }

  Future<void> _loadExtendedMetadata() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) {
      setState(() => _extLoading = false);
      return;
    }
    try {
      final fieldsFuture = api.getMetadataFieldSettings();
      final metaFuture = api.getTrackExtendedMetadata(widget.track.id);
      final fieldsRaw = await fieldsFuture;
      final metaValues = await metaFuture;

      final fields = MetadataFieldsResponse.fromJson(fieldsRaw);

      // Pre-fill controllers for all enabled keys
      final vals = <String, String>{};
      for (final cat in fields.categories) {
        for (final f in cat.fields) {
          if (f.enabled) {
            vals[f.key] = metaValues[f.key] ?? '';
          }
        }
      }

      if (mounted) {
        setState(() {
          _extFields = fields;
          _extOriginal = Map.of(vals);
          // Create controllers
          for (final entry in vals.entries) {
            _extControllers[entry.key] =
                TextEditingController(text: entry.value);
          }
          _extLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Load extended metadata error: $e');
      if (mounted) setState(() => _extLoading = false);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _artistCtrl.dispose();
    _albumCtrl.dispose();
    _trackNumCtrl.dispose();
    _discNumCtrl.dispose();
    for (final ctrl in _extControllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final enabledCategories = _extFields?.enabledCategories ?? [];

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20, 12, 20,
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
              const SizedBox(height: 12),
              Text(l.libraryEditTrack, style: TuneFonts.title3),
              const SizedBox(height: 8),
              // Scrollable content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Tags
                    if (context.read<AppState>().apiClient != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TagChipsWidget(itemType: 'track', itemId: widget.track.id),
                      ),
                    const SizedBox(height: 8),
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
                    // Extended metadata fields
                    if (!_extLoading && enabledCategories.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Divider(color: TuneColors.divider.withValues(alpha: 0.5)),
                      const SizedBox(height: 8),
                      Text(
                        'Metadonnees etendues',
                        style: TuneFonts.footnote.copyWith(
                          color: TuneColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...enabledCategories.expand((cat) => [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, top: 4),
                          child: Text(
                            cat.name,
                            style: TuneFonts.caption.copyWith(
                              color: TuneColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ...cat.fields.map((f) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _Field(
                            label: f.label,
                            controller: _extControllers[f.key] ??
                                TextEditingController(),
                          ),
                        )),
                      ]),
                    ],
                    if (_extLoading && context.read<AppState>().apiClient != null)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: TuneColors.accent,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              // Save button (fixed at bottom)
              const SizedBox(height: 8),
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
      },
    );
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;
    setState(() => _saving = true);

    final appState = context.read<AppState>();
    final api = appState.apiClient;

    try {
      // Save core fields via Drift
      final updated = widget.track.copyWith(
        title:       title,
        artistName:  Value(_artistCtrl.text.trim().isEmpty
            ? null : _artistCtrl.text.trim()),
        albumTitle:  Value(_albumCtrl.text.trim().isEmpty
            ? null : _albumCtrl.text.trim()),
        trackNumber: Value(int.tryParse(_trackNumCtrl.text.trim())),
        discNumber:  Value(int.tryParse(_discNumCtrl.text.trim())),
      );
      await appState.updateTrack(updated);

      // Save extended metadata (only changed fields) via API
      if (api != null && _extFields != null) {
        final changed = <String, String>{};
        for (final cat in _extFields!.enabledCategories) {
          for (final f in cat.fields) {
            final newVal = (_extControllers[f.key]?.text ?? '').trim();
            final oldVal = (_extOriginal[f.key] ?? '').trim();
            if (newVal != oldVal) {
              changed[f.key] = newVal;
            }
          }
        }
        if (changed.isNotEmpty) {
          await api.updateTrackExtendedMetadata(widget.track.id, changed);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: TuneColors.error,
          ),
        );
      }
    }

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
