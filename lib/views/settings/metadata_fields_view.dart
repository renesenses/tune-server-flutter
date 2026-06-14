import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/metadata_fields.dart';
import '../../services/tune_api_client.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// MetadataFieldsView — configurable extended metadata field toggles.
// Fetches categories from GET /api/v1/system/settings/metadata-fields
// and saves via PUT on toggle (debounced 500ms).
// Mirrors the "Metadonnees" section in tune-web-client SettingsView.svelte.
// ---------------------------------------------------------------------------

class MetadataFieldsView extends StatefulWidget {
  const MetadataFieldsView({super.key});

  @override
  State<MetadataFieldsView> createState() => _MetadataFieldsViewState();
}

class _MetadataFieldsViewState extends State<MetadataFieldsView> {
  MetadataFieldsResponse? _data;
  bool _loading = true;
  String? _error;
  Timer? _saveTimer;

  // Track which categories are collapsed (all expanded by default)
  final Map<String, bool> _collapsed = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    super.dispose();
  }

  TuneApiClient? get _api => context.read<AppState>().apiClient;

  Future<void> _load() async {
    final api = _api;
    if (api == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final raw = await api.getMetadataFieldSettings();
      if (mounted) {
        setState(() {
          _data = MetadataFieldsResponse.fromJson(raw);
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  void _toggleField(int catIndex, int fieldIndex) {
    final data = _data;
    if (data == null) return;
    setState(() {
      data.categories[catIndex].fields[fieldIndex].enabled =
          !data.categories[catIndex].fields[fieldIndex].enabled;
    });
    _debounceSave();
  }

  void _debounceSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 500), _save);
  }

  Future<void> _save() async {
    final api = _api;
    final data = _data;
    if (api == null || data == null) return;
    try {
      await api.updateMetadataFieldSettings(data.enabledKeys);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de sauvegarde: $e'),
            backgroundColor: TuneColors.error,
          ),
        );
      }
    }
  }

  void _toggleCategory(String name) {
    setState(() {
      _collapsed[name] = !(_collapsed[name] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Champs de metadonnees', style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: TuneColors.textSecondary),
            tooltip: 'Recharger',
            onPressed: _load,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: TuneColors.accent),
      );
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded,
                  color: TuneColors.error, size: 48),
              const SizedBox(height: 16),
              Text(
                'Impossible de charger les champs',
                style: TuneFonts.title3,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TuneFonts.footnote
                    .copyWith(color: TuneColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _load,
                style:
                    FilledButton.styleFrom(backgroundColor: TuneColors.accent),
                child: const Text('Reessayer'),
              ),
            ],
          ),
        ),
      );
    }

    final data = _data;
    if (data == null || data.categories.isEmpty) {
      return Center(
        child: Text(
          'Aucun champ disponible',
          style: TuneFonts.body.copyWith(color: TuneColors.textSecondary),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        // Hint
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Choisissez les champs de metadonnees affiches dans la vue edition de piste.',
            style:
                TuneFonts.footnote.copyWith(color: TuneColors.textSecondary),
          ),
        ),
        // Categories
        ...data.categories.asMap().entries.map((entry) {
          final catIndex = entry.key;
          final cat = entry.value;
          final isCollapsed = _collapsed[cat.name] ?? false;
          return _buildCategory(cat, catIndex, isCollapsed);
        }),
      ],
    );
  }

  Widget _buildCategory(
      MetadataCategory cat, int catIndex, bool isCollapsed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Category header
        InkWell(
          onTap: () => _toggleCategory(cat.name),
          child: Container(
            color: TuneColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    cat.name,
                    style: TuneFonts.body.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  '${cat.enabledCount}/${cat.fields.length}',
                  style: TuneFonts.caption
                      .copyWith(color: TuneColors.textSecondary),
                ),
                const SizedBox(width: 8),
                Icon(
                  isCollapsed
                      ? Icons.expand_more_rounded
                      : Icons.expand_less_rounded,
                  color: TuneColors.textTertiary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        // Fields (visible when expanded)
        if (!isCollapsed)
          Container(
            color: TuneColors.surface,
            child: Column(
              children: cat.fields.asMap().entries.map((fieldEntry) {
                final fieldIndex = fieldEntry.key;
                final field = fieldEntry.value;
                return Column(
                  children: [
                    const Divider(
                        height: 1, indent: 16, color: TuneColors.divider),
                    SwitchListTile(
                      title: Text(field.label, style: TuneFonts.body),
                      subtitle: Text(
                        field.key,
                        style: TuneFonts.caption
                            .copyWith(color: TuneColors.textTertiary),
                      ),
                      value: field.enabled,
                      onChanged: (_) => _toggleField(catIndex, fieldIndex),
                      activeThumbColor: TuneColors.accent,
                      dense: true,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}
