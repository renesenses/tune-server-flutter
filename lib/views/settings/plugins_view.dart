import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// PluginsView — Plugin store with install/uninstall/enable/disable
// API: GET /plugins (merged store+local), POST install/uninstall/enable/disable
// Mirrors web client PluginsView.svelte
// ---------------------------------------------------------------------------

class PluginsView extends StatefulWidget {
  const PluginsView({super.key});

  @override
  State<PluginsView> createState() => _PluginsViewState();
}

class _PluginsViewState extends State<PluginsView>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _plugins = [];
  bool _loading = true;
  String? _error;
  String _searchQuery = '';
  String _selectedCategory = '';
  late TabController _tabController;

  // Track ongoing operations per plugin
  final Set<String> _installing = {};
  final Set<String> _uninstalling = {};
  final Set<String> _updating = {};
  bool _showRestartBanner = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) {
      setState(() {
        _loading = false;
        _error = 'Non connecte au serveur';
      });
      return;
    }
    setState(() => _loading = true);
    try {
      final data = await api.getMergedPlugins();
      if (mounted) {
        setState(() {
          _plugins = data.map((p) => p as Map<String, dynamic>).toList();
          _loading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = '$e'; });
    }
  }

  List<String> get _categories {
    final cats = _plugins
        .map((p) => p['category'] as String? ?? '')
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();
    cats.sort();
    return cats;
  }

  List<Map<String, dynamic>> get _installedPlugins =>
      _plugins.where((p) => p['installed'] == true).toList();

  List<Map<String, dynamic>> get _filteredPlugins {
    return _plugins.where((p) {
      if (_selectedCategory.isNotEmpty &&
          p['category'] != _selectedCategory) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = (p['display_name'] ?? p['name'] ?? '').toString().toLowerCase();
        final desc = (p['description'] ?? '').toString().toLowerCase();
        final author = (p['author'] ?? '').toString().toLowerCase();
        final cat = (p['category'] ?? '').toString().toLowerCase();
        return name.contains(q) || desc.contains(q) ||
            author.contains(q) || cat.contains(q);
      }
      return true;
    }).toList();
  }

  bool _isBusy(String name) =>
      _installing.contains(name) || _uninstalling.contains(name) || _updating.contains(name);

  Future<void> _installPlugin(Map<String, dynamic> plugin) async {
    final api = context.read<AppState>().apiClient;
    final name = plugin['name'] as String? ?? '';
    if (api == null || name.isEmpty) return;
    setState(() => _installing.add(name));
    try {
      final result = await api.installPlugin(name);
      final restartRequired = (result is Map) && result['restart_required'] == true;
      if (restartRequired) setState(() => _showRestartBanner = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${plugin['display_name'] ?? name} installed'),
            backgroundColor: TuneColors.success,
          ),
        );
      }
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Install failed: $e'), backgroundColor: TuneColors.error),
        );
      }
    }
    if (mounted) setState(() => _installing.remove(name));
  }

  Future<void> _uninstallPlugin(Map<String, dynamic> plugin) async {
    final api = context.read<AppState>().apiClient;
    final name = plugin['name'] as String? ?? '';
    if (api == null || name.isEmpty) return;
    setState(() => _uninstalling.add(name));
    try {
      final result = await api.uninstallPlugin(name);
      final restartRequired = (result is Map) && result['restart_required'] == true;
      if (restartRequired) setState(() => _showRestartBanner = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${plugin['display_name'] ?? name} uninstalled'),
            backgroundColor: TuneColors.accent,
          ),
        );
      }
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Uninstall failed: $e'), backgroundColor: TuneColors.error),
        );
      }
    }
    if (mounted) setState(() => _uninstalling.remove(name));
  }

  Future<void> _updatePlugin(Map<String, dynamic> plugin) async {
    final api = context.read<AppState>().apiClient;
    final name = plugin['name'] as String? ?? '';
    if (api == null || name.isEmpty) return;
    setState(() => _updating.add(name));
    try {
      final result = await api.updatePlugin(name);
      final restartRequired = (result is Map) && result['restart_required'] == true;
      if (restartRequired) setState(() => _showRestartBanner = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${plugin['display_name'] ?? name} updated'),
            backgroundColor: TuneColors.success,
          ),
        );
      }
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Update failed: $e'), backgroundColor: TuneColors.error),
        );
      }
    }
    if (mounted) setState(() => _updating.remove(name));
  }

  Future<void> _togglePlugin(Map<String, dynamic> plugin) async {
    final api = context.read<AppState>().apiClient;
    final name = plugin['name'] as String? ?? '';
    if (api == null || name.isEmpty) return;
    try {
      final isActive = plugin['status'] == 'active';
      if (isActive) {
        await api.disablePlugin(name);
      } else {
        await api.enablePlugin(name);
      }
      setState(() => _showRestartBanner = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${plugin['display_name'] ?? name} ${isActive ? "disabled" : "enabled"}'),
            backgroundColor: TuneColors.accent,
          ),
        );
      }
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: TuneColors.error),
        );
      }
    }
  }

  Color _categoryColor(String category) {
    const colors = {
      'streaming': Color(0xFF10B981),
      'audio': Color(0xFF6366F1),
      'playback': Color(0xFFF59E0B),
      'library': Color(0xFF3B82F6),
      'integration': Color(0xFF8B5CF6),
      'hardware': Color(0xFFEC4899),
      'system': Color(0xFF6B7280),
      'metadata': Color(0xFFF59E0B),
      'output': Color(0xFFEC4899),
      'analytics': Color(0xFF14B8A6),
      'tools': Color(0xFF78716C),
    };
    return colors[category.toLowerCase()] ?? const Color(0xFF6B7280);
  }

  IconData _categoryIcon(String category) {
    const icons = {
      'streaming': Icons.music_note_rounded,
      'audio': Icons.volume_up_rounded,
      'playback': Icons.play_arrow_rounded,
      'library': Icons.library_music_rounded,
      'integration': Icons.code_rounded,
      'hardware': Icons.memory_rounded,
      'system': Icons.settings_rounded,
      'metadata': Icons.description_rounded,
      'output': Icons.speaker_rounded,
      'analytics': Icons.analytics_rounded,
      'tools': Icons.build_rounded,
    };
    return icons[category.toLowerCase()] ?? Icons.extension_rounded;
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: TuneColors.accent,
          labelColor: TuneColors.accent,
          unselectedLabelColor: TuneColors.textSecondary,
          tabs: [
            const Tab(text: 'Store'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Installed'),
                  if (_installedPlugins.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: TuneColors.accent,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${_installedPlugins.length}',
                        style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Restart banner
          if (_showRestartBanner)
            Container(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Colors.orange, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Redemarrage requis pour appliquer les changements',
                      style: TuneFonts.caption.copyWith(
                        fontWeight: FontWeight.w500, color: Colors.orange),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _showRestartBanner = false),
                    child: const Icon(Icons.close_rounded, color: Colors.orange, size: 16),
                  ),
                ],
              ),
            ),

          // Content
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: TuneColors.accent))
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.extension_off_rounded,
                                color: TuneColors.textTertiary, size: 48),
                            const SizedBox(height: 16),
                            Text(_error!,
                                style: TuneFonts.body.copyWith(
                                    color: TuneColors.textSecondary)),
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: _load,
                              child: const Text('Reessayer'),
                            ),
                          ],
                        ),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildStoreTab(),
                          _buildInstalledTab(),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreTab() {
    final filtered = _filteredPlugins;
    return CustomScrollView(
      slivers: [
        // Search bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: TuneFonts.body,
              decoration: InputDecoration(
                hintText: 'Rechercher un plugin...',
                hintStyle: TuneFonts.footnote.copyWith(color: TuneColors.textTertiary),
                filled: true,
                fillColor: TuneColors.surface,
                prefixIcon: const Icon(Icons.search_rounded, color: TuneColors.textTertiary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: TuneColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: TuneColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: TuneColors.accent),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),

        // Category chips
        if (_categories.isNotEmpty)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _CategoryChip(
                    label: 'Tous',
                    selected: _selectedCategory.isEmpty,
                    onTap: () => setState(() => _selectedCategory = ''),
                  ),
                  const SizedBox(width: 6),
                  ..._categories.map((cat) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: _CategoryChip(
                      label: cat,
                      color: _categoryColor(cat),
                      selected: _selectedCategory == cat,
                      onTap: () => setState(() =>
                          _selectedCategory = _selectedCategory == cat ? '' : cat),
                    ),
                  )),
                ],
              ),
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // Plugin grid
        if (filtered.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.extension_rounded,
                      color: TuneColors.textTertiary, size: 48),
                  const SizedBox(height: 16),
                  Text('Aucun plugin trouve',
                      style: TuneFonts.body.copyWith(color: TuneColors.textSecondary)),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _StorePluginCard(
                    plugin: filtered[i],
                    categoryColor: _categoryColor(filtered[i]['category'] as String? ?? ''),
                    categoryIcon: _categoryIcon(filtered[i]['category'] as String? ?? ''),
                    isBusy: _isBusy(filtered[i]['name'] as String? ?? ''),
                    isInstalling: _installing.contains(filtered[i]['name']),
                    isUninstalling: _uninstalling.contains(filtered[i]['name']),
                    isUpdating: _updating.contains(filtered[i]['name']),
                    onInstall: () => _installPlugin(filtered[i]),
                    onUninstall: () => _uninstallPlugin(filtered[i]),
                    onUpdate: () => _updatePlugin(filtered[i]),
                    onToggle: () => _togglePlugin(filtered[i]),
                  ),
                ),
                childCount: filtered.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInstalledTab() {
    final installed = _installedPlugins;
    if (installed.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.extension_rounded,
                color: TuneColors.textTertiary, size: 48),
            const SizedBox(height: 16),
            Text('Aucun plugin installe',
                style: TuneFonts.body.copyWith(color: TuneColors.textSecondary)),
            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
              onPressed: () => _tabController.animateTo(0),
              child: const Text('Parcourir le Store'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: installed.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _InstalledPluginCard(
        plugin: installed[i],
        categoryColor: _categoryColor(installed[i]['category'] as String? ?? ''),
        categoryIcon: _categoryIcon(installed[i]['category'] as String? ?? ''),
        isBusy: _isBusy(installed[i]['name'] as String? ?? ''),
        isUninstalling: _uninstalling.contains(installed[i]['name']),
        isUpdating: _updating.contains(installed[i]['name']),
        onUninstall: () => _uninstallPlugin(installed[i]),
        onUpdate: () => _updatePlugin(installed[i]),
        onToggle: () => _togglePlugin(installed[i]),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Category chip
// ---------------------------------------------------------------------------

class _CategoryChip extends StatelessWidget {
  final String label;
  final Color? color;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? TuneColors.accent;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? chipColor : TuneColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? chipColor : TuneColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TuneFonts.caption.copyWith(
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : TuneColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Store plugin card
// ---------------------------------------------------------------------------

class _StorePluginCard extends StatelessWidget {
  final Map<String, dynamic> plugin;
  final Color categoryColor;
  final IconData categoryIcon;
  final bool isBusy;
  final bool isInstalling;
  final bool isUninstalling;
  final bool isUpdating;
  final VoidCallback onInstall;
  final VoidCallback onUninstall;
  final VoidCallback onUpdate;
  final VoidCallback onToggle;

  const _StorePluginCard({
    required this.plugin,
    required this.categoryColor,
    required this.categoryIcon,
    required this.isBusy,
    required this.isInstalling,
    required this.isUninstalling,
    required this.isUpdating,
    required this.onInstall,
    required this.onUninstall,
    required this.onUpdate,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final name = plugin['display_name'] as String? ??
        plugin['name'] as String? ?? 'Plugin';
    final description = plugin['description'] as String? ?? '';
    final version = plugin['version'] as String? ?? '';
    final author = plugin['author'] as String? ?? '';
    final category = plugin['category'] as String? ?? '';
    final installed = plugin['installed'] as bool? ?? false;
    final compatible = plugin['compatible'] as bool? ?? true;
    final updateAvailable = plugin['update_available'] as bool? ?? false;
    final status = plugin['status'] as String? ?? '';
    final isFeatured = plugin['is_featured'] as bool? ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TuneColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: installed
              ? TuneColors.accent.withValues(alpha: 0.3)
              : TuneColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: icon + badges
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(categoryIcon, color: categoryColor, size: 24),
              ),
              const SizedBox(width: 12),
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
                        if (category.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: categoryColor,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              category,
                              style: const TextStyle(
                                fontSize: 9, fontWeight: FontWeight.w600,
                                color: Colors.white, letterSpacing: 0.5),
                            ),
                          ),
                      ],
                    ),
                    if (version.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text('v$version',
                          style: TuneFonts.caption.copyWith(color: TuneColors.textTertiary)),
                    ],
                  ],
                ),
              ),
            ],
          ),

          // Badges row
          if (isFeatured || updateAvailable || !compatible) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: [
                if (isFeatured)
                  _Badge(label: 'Featured', color: const Color(0xFFF59E0B)),
                if (updateAvailable)
                  _Badge(label: 'Update', color: const Color(0xFF10B981)),
                if (!compatible)
                  _Badge(label: 'Incompatible', color: const Color(0xFFEF4444)),
              ],
            ),
          ],

          // Description
          if (description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(description,
                style: TuneFonts.caption.copyWith(color: TuneColors.textSecondary),
                maxLines: 3, overflow: TextOverflow.ellipsis),
          ],

          // Footer: author + actions
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (author.isNotEmpty)
                      Text('par $author',
                          style: TuneFonts.caption.copyWith(
                            color: TuneColors.textTertiary, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
              // Action buttons
              if (installed) ...[
                if (updateAvailable) ...[
                  _ActionButton(
                    label: isUpdating ? null : 'Update',
                    color: const Color(0xFF10B981),
                    loading: isUpdating,
                    disabled: isBusy,
                    onTap: onUpdate,
                  ),
                  const SizedBox(width: 6),
                ],
                _ActionButton(
                  label: status == 'active' ? 'Disable' : 'Enable',
                  color: status == 'active'
                      ? const Color(0xFFEF4444)
                      : TuneColors.accent,
                  outlined: true,
                  disabled: isBusy,
                  onTap: onToggle,
                ),
                const SizedBox(width: 6),
                _ActionButton(
                  label: isUninstalling ? null : 'Uninstall',
                  color: const Color(0xFFEF4444),
                  outlined: true,
                  loading: isUninstalling,
                  disabled: isBusy,
                  onTap: onUninstall,
                ),
              ] else
                _ActionButton(
                  label: isInstalling ? null : 'Install',
                  color: TuneColors.accent,
                  loading: isInstalling,
                  disabled: !compatible || isBusy,
                  onTap: onInstall,
                ),
            ],
          ),

          // Status stripe for installed plugins
          if (installed) ...[
            const SizedBox(height: 8),
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: status == 'active'
                    ? const Color(0xFF10B981)
                    : status == 'error'
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF6B7280),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Installed plugin card (compact list view)
// ---------------------------------------------------------------------------

class _InstalledPluginCard extends StatelessWidget {
  final Map<String, dynamic> plugin;
  final Color categoryColor;
  final IconData categoryIcon;
  final bool isBusy;
  final bool isUninstalling;
  final bool isUpdating;
  final VoidCallback onUninstall;
  final VoidCallback onUpdate;
  final VoidCallback onToggle;

  const _InstalledPluginCard({
    required this.plugin,
    required this.categoryColor,
    required this.categoryIcon,
    required this.isBusy,
    required this.isUninstalling,
    required this.isUpdating,
    required this.onUninstall,
    required this.onUpdate,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final name = plugin['display_name'] as String? ??
        plugin['name'] as String? ?? 'Plugin';
    final description = plugin['description'] as String? ?? '';
    final version = plugin['installed_version'] as String? ??
        plugin['version'] as String? ?? '';
    final status = plugin['status'] as String? ?? '';
    final updateAvailable = plugin['update_available'] as bool? ?? false;
    final errorMessage = plugin['error_message'] as String?;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TuneColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: status == 'error'
              ? const Color(0xFFEF4444)
              : TuneColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(categoryIcon, color: categoryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(name,
                            style: TuneFonts.body.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Text('v$version',
                            style: TuneFonts.caption.copyWith(color: TuneColors.textTertiary)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                          decoration: BoxDecoration(
                            color: status == 'active'
                                ? const Color(0xFF10B981).withValues(alpha: 0.15)
                                : status == 'error'
                                    ? const Color(0xFFEF4444).withValues(alpha: 0.15)
                                    : const Color(0xFF6B7280).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            status == 'active' ? 'Active' :
                            status == 'error' ? 'Error' : 'Disabled',
                            style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600,
                              color: status == 'active'
                                  ? const Color(0xFF10B981)
                                  : status == 'error'
                                      ? const Color(0xFFEF4444)
                                      : const Color(0xFF9CA3AF),
                            ),
                          ),
                        ),
                        if (updateAvailable) ...[
                          const SizedBox(width: 6),
                          _Badge(label: 'Update', color: const Color(0xFF10B981)),
                        ],
                      ],
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(description,
                          style: TuneFonts.caption.copyWith(color: TuneColors.textSecondary),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                    if (status == 'error' && errorMessage != null) ...[
                      const SizedBox(height: 2),
                      Text(errorMessage,
                          style: TuneFonts.caption.copyWith(color: const Color(0xFFEF4444)),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (updateAvailable) ...[
                _ActionButton(
                  label: isUpdating ? null : 'Update',
                  color: const Color(0xFF10B981),
                  loading: isUpdating,
                  disabled: isBusy,
                  onTap: onUpdate,
                  small: true,
                ),
                const SizedBox(width: 6),
              ],
              _ActionButton(
                label: status == 'active' ? 'Disable' : 'Enable',
                color: status == 'active'
                    ? const Color(0xFFEF4444)
                    : TuneColors.accent,
                outlined: true,
                disabled: isBusy,
                onTap: onToggle,
                small: true,
              ),
              const SizedBox(width: 6),
              _ActionButton(
                label: isUninstalling ? null : 'Uninstall',
                color: const Color(0xFFEF4444),
                outlined: true,
                loading: isUninstalling,
                disabled: isBusy,
                onTap: onUninstall,
                small: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared UI helpers
// ---------------------------------------------------------------------------

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 9, fontWeight: FontWeight.w700,
          letterSpacing: 0.5, color: color,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String? label;
  final Color color;
  final bool outlined;
  final bool loading;
  final bool disabled;
  final VoidCallback onTap;
  final bool small;

  const _ActionButton({
    this.label,
    required this.color,
    this.outlined = false,
    this.loading = false,
    this.disabled = false,
    required this.onTap,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final hPad = small ? 10.0 : 14.0;
    final vPad = small ? 4.0 : 7.0;
    final fontSize = small ? 11.0 : 12.0;

    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : (disabled ? color.withValues(alpha: 0.5) : color),
          borderRadius: BorderRadius.circular(8),
          border: outlined ? Border.all(color: disabled ? color.withValues(alpha: 0.5) : color) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading) ...[
              SizedBox(
                width: 12, height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: outlined ? color : Colors.white,
                ),
              ),
              const SizedBox(width: 6),
            ],
            if (label != null)
              Text(
                label!,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: outlined
                      ? (disabled ? color.withValues(alpha: 0.5) : color)
                      : Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
