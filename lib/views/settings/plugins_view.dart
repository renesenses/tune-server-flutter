import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// PluginsView — List installed plugins with enable/disable toggle
// API: GET /system/plugins, POST /system/plugins/{id}
// ---------------------------------------------------------------------------

class PluginsView extends StatefulWidget {
  const PluginsView({super.key});

  @override
  State<PluginsView> createState() => _PluginsViewState();
}

class _PluginsViewState extends State<PluginsView> {
  List<Map<String, dynamic>> _plugins = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) {
      setState(() { _loading = false; _error = 'Non connecte au serveur'; });
      return;
    }
    setState(() => _loading = true);
    try {
      final data = await api.getPlugins();
      if (mounted) {
        setState(() {
          _plugins = data.map((p) => p as Map<String, dynamic>).toList();
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = '$e'; });
    }
  }

  Future<void> _togglePlugin(String pluginId, bool enabled) async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    try {
      await api.setPluginEnabled(pluginId, enabled);
      // Update local state
      setState(() {
        final idx = _plugins.indexWhere((p) => p['id'] == pluginId);
        if (idx != -1) {
          _plugins[idx] = {..._plugins[idx], 'enabled': enabled};
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: TuneColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Plugins', style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: TuneColors.accent),
            onPressed: _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: TuneColors.accent))
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.extension_off_rounded, color: TuneColors.textTertiary, size: 48),
                      const SizedBox(height: 16),
                      Text(_error!, style: TuneFonts.body.copyWith(color: TuneColors.textSecondary)),
                    ],
                  ),
                )
              : _plugins.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.extension_rounded, color: TuneColors.textTertiary, size: 48),
                          const SizedBox(height: 16),
                          Text('Aucun plugin installe',
                              style: TuneFonts.body.copyWith(color: TuneColors.textSecondary)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _plugins.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) => _PluginCard(
                        plugin: _plugins[i],
                        onToggle: (enabled) {
                          final id = _plugins[i]['id'] as String? ?? '';
                          _togglePlugin(id, enabled);
                        },
                      ),
                    ),
    );
  }
}

// ---------------------------------------------------------------------------
// Plugin card
// ---------------------------------------------------------------------------

class _PluginCard extends StatelessWidget {
  final Map<String, dynamic> plugin;
  final ValueChanged<bool> onToggle;

  const _PluginCard({required this.plugin, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final name = plugin['name'] as String? ?? plugin['id'] as String? ?? 'Plugin';
    final description = plugin['description'] as String? ?? '';
    final version = plugin['version'] as String? ?? '';
    final enabled = plugin['enabled'] as bool? ?? false;
    final author = plugin['author'] as String? ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TuneColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled
              ? TuneColors.accent.withValues(alpha: 0.3)
              : TuneColors.divider,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: enabled
                  ? TuneColors.accent.withValues(alpha: 0.15)
                  : TuneColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.extension_rounded,
              color: enabled ? TuneColors.accent : TuneColors.textTertiary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(name,
                          style: TuneFonts.body.copyWith(fontWeight: FontWeight.w600)),
                    ),
                    if (version.isNotEmpty)
                      Text('v$version',
                          style: TuneFonts.caption.copyWith(color: TuneColors.textTertiary)),
                  ],
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(description,
                      style: TuneFonts.caption.copyWith(color: TuneColors.textSecondary),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
                if (author.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text('par $author',
                      style: TuneFonts.caption.copyWith(
                        color: TuneColors.textTertiary,
                        fontStyle: FontStyle.italic,
                      )),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: enabled,
            onChanged: onToggle,
            activeColor: TuneColors.accent,
          ),
        ],
      ),
    );
  }
}
