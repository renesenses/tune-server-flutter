import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/tune_api_client.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// ZoneManagerView — gestion avancée des zones, groupes, profils.
//
// Fonctionnalités :
//   - Vue d'ensemble des zones (volume, mute, latence)
//   - Groupes multi-room (créer, calibrer, dissoudre, volume master)
//   - Profils de configuration (sauvegarder, activer, supprimer)
// ---------------------------------------------------------------------------

class ZoneManagerView extends StatefulWidget {
  const ZoneManagerView({super.key});

  @override
  State<ZoneManagerView> createState() => _ZoneManagerViewState();
}

class _ZoneManagerViewState extends State<ZoneManagerView> {
  // Overview data
  Map<String, dynamic>? _overview;
  bool _loadingOverview = false;

  // Groups
  List<dynamic> _groups = [];
  bool _loadingGroups = false;

  // Profiles
  List<dynamic> _profiles = [];
  bool _loadingProfiles = false;

  // Action loading states
  final Map<String, bool> _actionLoading = {};

  // Latency results per zone id
  final Map<int, String> _latencyResults = {};

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  TuneApiClient? get _api => context.read<AppState>().apiClient;

  Future<void> _loadAll() async {
    _loadOverview();
    _loadGroups();
    _loadProfiles();
  }

  Future<void> _loadOverview() async {
    final api = _api;
    if (api == null) return;
    setState(() => _loadingOverview = true);
    try {
      final data = await api.getZoneOverview();
      if (mounted) setState(() => _overview = data);
    } catch (e) {
      debugPrint('Zone overview error: $e');
    } finally {
      if (mounted) setState(() => _loadingOverview = false);
    }
  }

  Future<void> _loadGroups() async {
    final api = _api;
    if (api == null) return;
    setState(() => _loadingGroups = true);
    try {
      final data = await api.getZoneManagerGroups();
      if (mounted) setState(() => _groups = data);
    } catch (e) {
      debugPrint('Zone groups error: $e');
    } finally {
      if (mounted) setState(() => _loadingGroups = false);
    }
  }

  Future<void> _loadProfiles() async {
    final api = _api;
    if (api == null) return;
    setState(() => _loadingProfiles = true);
    try {
      final data = await api.getZoneProfiles();
      if (mounted) setState(() => _profiles = data);
    } catch (e) {
      debugPrint('Zone profiles error: $e');
    } finally {
      if (mounted) setState(() => _loadingProfiles = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  Future<void> _toggleMute(int zoneId, bool currentlyMuted) async {
    final api = _api;
    if (api == null) return;
    final key = 'mute_$zoneId';
    if (_actionLoading[key] == true) return;
    setState(() => _actionLoading[key] = true);
    try {
      await api.muteZone(zoneId, !currentlyMuted);
      if (mounted) {
        _loadOverview();
        _showSnackBar(!currentlyMuted ? 'Zone en sourdine' : 'Sourdine désactivée');
      }
    } catch (e) {
      if (mounted) _showSnackBar('Erreur mute : $e', isError: true);
    } finally {
      if (mounted) setState(() => _actionLoading[key] = false);
    }
  }

  Future<void> _setVolume(int zoneId, double volume) async {
    final api = _api;
    if (api == null) return;
    try {
      await api.setVolume(zoneId, volume);
    } catch (e) {
      if (mounted) _showSnackBar('Erreur volume : $e', isError: true);
    }
  }

  Future<void> _measureLatency(int zoneId) async {
    final api = _api;
    if (api == null) return;
    final key = 'latency_$zoneId';
    if (_actionLoading[key] == true) return;
    setState(() => _actionLoading[key] = true);
    try {
      final result = await api.measureLatency(zoneId);
      if (mounted) {
        final latencyMs = result['latency_ms'] ?? result['latency'] ?? '?';
        setState(() => _latencyResults[zoneId] = '${latencyMs}ms');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _latencyResults[zoneId] = 'erreur');
        _showSnackBar('Erreur latence : $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _actionLoading[key] = false);
    }
  }

  Future<void> _setGroupVolume(String groupId, double volume) async {
    final api = _api;
    if (api == null) return;
    try {
      await api.setGroupVolume(groupId, masterVolume: volume);
    } catch (e) {
      if (mounted) _showSnackBar('Erreur volume groupe : $e', isError: true);
    }
  }

  Future<void> _calibrateGroup(String groupId) async {
    final api = _api;
    if (api == null) return;
    final key = 'calibrate_$groupId';
    if (_actionLoading[key] == true) return;
    setState(() => _actionLoading[key] = true);
    try {
      await api.calibrateGroup(groupId);
      if (mounted) _showSnackBar('Calibration terminée');
    } catch (e) {
      if (mounted) _showSnackBar('Erreur calibration : $e', isError: true);
    } finally {
      if (mounted) setState(() => _actionLoading[key] = false);
    }
  }

  Future<void> _dissolveGroup(String groupId) async {
    final api = _api;
    if (api == null) return;
    final key = 'dissolve_$groupId';
    if (_actionLoading[key] == true) return;
    setState(() => _actionLoading[key] = true);
    try {
      await api.deleteZoneGroup(groupId);
      if (mounted) {
        _showSnackBar('Groupe dissous');
        _loadGroups();
      }
    } catch (e) {
      if (mounted) _showSnackBar('Erreur dissolution : $e', isError: true);
    } finally {
      if (mounted) setState(() => _actionLoading[key] = false);
    }
  }

  Future<void> _renameGroup(String groupId, String currentName) async {
    final ctrl = TextEditingController(text: currentName);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: const Text('Renommer le groupe', style: TuneFonts.title3),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: const TextStyle(color: TuneColors.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Nouveau nom',
            hintStyle: TextStyle(color: TuneColors.textTertiary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Renommer'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty && mounted) {
      final api = _api;
      if (api == null) return;
      try {
        await api.renameZoneGroup(groupId, result);
        _loadGroups();
        _showSnackBar('Groupe renommé');
      } catch (e) {
        _showSnackBar('Erreur renommage : $e', isError: true);
      }
    }
  }

  Future<void> _showCreateGroupDialog() async {
    final api = _api;
    if (api == null) return;

    final zones = _overview?['zones'] as List<dynamic>? ?? [];
    if (zones.length < 2) {
      _showSnackBar('Il faut au moins 2 zones pour créer un groupe');
      return;
    }

    final nameCtrl = TextEditingController();
    int? leaderId;
    final Set<int> selectedIds = {};

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            backgroundColor: TuneColors.surface,
            title: const Text('Créer un groupe', style: TuneFonts.title3),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    TextField(
                      controller: nameCtrl,
                      style: const TextStyle(color: TuneColors.textPrimary),
                      decoration: const InputDecoration(
                        labelText: 'Nom du groupe',
                        hintText: 'ex: Salon + Cuisine',
                        hintStyle: TextStyle(color: TuneColors.textTertiary),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Leader dropdown
                    const Text('Leader', style: TuneFonts.subheadline),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: leaderId,
                      dropdownColor: TuneColors.surfaceVariant,
                      style: const TextStyle(color: TuneColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Choisir le leader',
                        hintStyle: TextStyle(color: TuneColors.textTertiary),
                      ),
                      items: zones.map<DropdownMenuItem<int>>((z) {
                        final zMap = z as Map<String, dynamic>;
                        final id = zMap['id'] as int;
                        final name = zMap['name'] as String? ?? 'Zone $id';
                        return DropdownMenuItem(value: id, child: Text(name));
                      }).toList(),
                      onChanged: (val) {
                        setDialogState(() {
                          leaderId = val;
                          if (val != null) selectedIds.add(val);
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Members
                    const Text('Membres', style: TuneFonts.subheadline),
                    const SizedBox(height: 8),
                    ...zones.map<Widget>((z) {
                      final zMap = z as Map<String, dynamic>;
                      final id = zMap['id'] as int;
                      final name = zMap['name'] as String? ?? 'Zone $id';
                      return CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        activeColor: TuneColors.accent,
                        checkColor: TuneColors.textPrimary,
                        value: selectedIds.contains(id),
                        title: Text(name,
                            style: const TextStyle(
                                color: TuneColors.textPrimary)),
                        onChanged: (checked) {
                          setDialogState(() {
                            if (checked == true) {
                              selectedIds.add(id);
                            } else {
                              selectedIds.remove(id);
                              if (leaderId == id) leaderId = null;
                            }
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Annuler'),
              ),
              FilledButton(
                style:
                    FilledButton.styleFrom(backgroundColor: TuneColors.accent),
                onPressed: (leaderId != null && selectedIds.length >= 2)
                    ? () => Navigator.pop(ctx, true)
                    : null,
                child: const Text('Créer'),
              ),
            ],
          );
        },
      ),
    ).then((result) async {
      if (result == true && leaderId != null && mounted) {
        try {
          await api.createZoneGroup(
            leaderId!,
            selectedIds.toList(),
            name: nameCtrl.text.trim().isNotEmpty
                ? nameCtrl.text.trim()
                : null,
          );
          _loadGroups();
          _showSnackBar('Groupe créé');
        } catch (e) {
          _showSnackBar('Erreur création groupe : $e', isError: true);
        }
      }
    });
  }

  Future<void> _activateProfile(int profileId) async {
    final api = _api;
    if (api == null) return;
    final key = 'activate_$profileId';
    if (_actionLoading[key] == true) return;
    setState(() => _actionLoading[key] = true);
    try {
      await api.activateZoneProfile(profileId);
      if (mounted) {
        _showSnackBar('Profil activé');
        _loadOverview();
      }
    } catch (e) {
      if (mounted) _showSnackBar('Erreur activation : $e', isError: true);
    } finally {
      if (mounted) setState(() => _actionLoading[key] = false);
    }
  }

  Future<void> _deleteProfile(int profileId) async {
    final api = _api;
    if (api == null) return;
    final key = 'delete_$profileId';
    if (_actionLoading[key] == true) return;
    setState(() => _actionLoading[key] = true);
    try {
      await api.deleteZoneProfile(profileId);
      if (mounted) {
        _showSnackBar('Profil supprimé');
        _loadProfiles();
      }
    } catch (e) {
      if (mounted) _showSnackBar('Erreur suppression : $e', isError: true);
    } finally {
      if (mounted) setState(() => _actionLoading[key] = false);
    }
  }

  Future<void> _showSaveProfileDialog() async {
    final api = _api;
    if (api == null) return;

    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: const Text('Sauvegarder la configuration',
            style: TuneFonts.title3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              autofocus: true,
              style: const TextStyle(color: TuneColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Nom du profil',
                hintText: 'ex: Soirée, Matin calme',
                hintStyle: TextStyle(color: TuneColors.textTertiary),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              style: const TextStyle(color: TuneColors.textPrimary),
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Description (optionnel)',
                hintStyle: TextStyle(color: TuneColors.textTertiary),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final name = nameCtrl.text.trim();
      if (name.isEmpty) {
        _showSnackBar('Le nom est requis');
        return;
      }
      try {
        await api.createZoneProfile(
          name,
          description: descCtrl.text.trim().isNotEmpty
              ? descCtrl.text.trim()
              : null,
        );
        _loadProfiles();
        _showSnackBar('Profil sauvegardé');
      } catch (e) {
        _showSnackBar('Erreur sauvegarde : $e', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? TuneColors.error : TuneColors.surfaceHigh,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final api = _api;

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Zone Manager', style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: TuneColors.textSecondary),
            tooltip: 'Rafraîchir',
            onPressed: () => _loadAll(),
          ),
        ],
      ),
      body: api == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off_rounded,
                        size: 48, color: TuneColors.textTertiary),
                    const SizedBox(height: 16),
                    Text(
                      'Zone Manager nécessite une connexion au serveur distant.',
                      textAlign: TextAlign.center,
                      style: TuneFonts.body
                          .copyWith(color: TuneColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ============================================================
                  // 1. ZONES
                  // ============================================================
                  _buildZonesSection(),

                  // ============================================================
                  // 2. GROUPES
                  // ============================================================
                  _buildGroupsSection(),

                  // ============================================================
                  // 3. PROFILS
                  // ============================================================
                  _buildProfilesSection(),
                ],
              ),
            ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Zones section
  // ---------------------------------------------------------------------------

  Widget _buildZonesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader('Zones'),
        if (_loadingOverview && _overview == null)
          Container(
            color: TuneColors.surface,
            padding: const EdgeInsets.all(20),
            child: const Center(
              child: CircularProgressIndicator(color: TuneColors.accent),
            ),
          )
        else if (_overview == null)
          Container(
            color: TuneColors.surface,
            padding: const EdgeInsets.all(16),
            child: Text(
              'Données indisponibles',
              style: TuneFonts.footnote
                  .copyWith(color: TuneColors.textTertiary),
            ),
          )
        else
          _buildZoneCards(),
      ],
    );
  }

  Widget _buildZoneCards() {
    final zones = _overview!['zones'] as List<dynamic>? ?? [];
    if (zones.isEmpty) {
      return Container(
        color: TuneColors.surface,
        padding: const EdgeInsets.all(16),
        child: Text(
          'Aucune zone',
          style: TuneFonts.footnote.copyWith(color: TuneColors.textTertiary),
        ),
      );
    }

    return Container(
      color: TuneColors.surface,
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: zones.map<Widget>((z) {
          final zMap = z as Map<String, dynamic>;
          return _ZoneCard(
            zone: zMap,
            latencyResult: _latencyResults[zMap['id'] as int],
            muteLoading: _actionLoading['mute_${zMap['id']}'] == true,
            latencyLoading: _actionLoading['latency_${zMap['id']}'] == true,
            onToggleMute: () => _toggleMute(
              zMap['id'] as int,
              zMap['muted'] == true,
            ),
            onVolumeChanged: (v) => _setVolume(zMap['id'] as int, v),
            onMeasureLatency: () => _measureLatency(zMap['id'] as int),
          );
        }).toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Groupes section
  // ---------------------------------------------------------------------------

  Widget _buildGroupsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader('Groupes'),
        if (_loadingGroups && _groups.isEmpty)
          Container(
            color: TuneColors.surface,
            padding: const EdgeInsets.all(20),
            child: const Center(
              child: CircularProgressIndicator(color: TuneColors.accent),
            ),
          )
        else if (_groups.isEmpty)
          Container(
            color: TuneColors.surface,
            padding: const EdgeInsets.all(16),
            child: Text(
              'Aucun groupe',
              style: TuneFonts.footnote
                  .copyWith(color: TuneColors.textTertiary),
            ),
          )
        else
          Container(
            color: TuneColors.surface,
            child: Column(
              children: _groups.asMap().entries.map((entry) {
                final idx = entry.key;
                final g = entry.value as Map<String, dynamic>;
                return Column(
                  children: [
                    if (idx > 0)
                      const Divider(
                          height: 1, indent: 16, color: TuneColors.divider),
                    _buildGroupTile(g),
                  ],
                );
              }).toList(),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: TuneColors.accent,
              minimumSize: const Size.fromHeight(44),
            ),
            icon: const Icon(Icons.group_add_rounded, size: 20),
            label: const Text('Créer un groupe'),
            onPressed: () => _showCreateGroupDialog(),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupTile(Map<String, dynamic> group) {
    final groupId = (group['id'] ?? group['group_id'] ?? '').toString();
    final name = group['name'] as String? ?? 'Groupe';
    final leaderName = group['leader_name'] as String? ??
        'Zone ${group['leader_zone_id'] ?? '?'}';
    final memberIds = group['zone_ids'] as List<dynamic>? ?? [];
    final masterVolume =
        (group['master_volume'] as num?)?.toDouble() ?? 0.5;

    // Build member chips from overview zones
    final zones = _overview?['zones'] as List<dynamic>? ?? [];
    final memberNames = memberIds.map<String>((id) {
      final z = zones.cast<Map<String, dynamic>?>().firstWhere(
        (z) => z?['id'] == id,
        orElse: () => null,
      );
      return z?['name'] as String? ?? 'Zone $id';
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name (tappable) + leader
          Row(
            children: [
              const Icon(Icons.speaker_group_rounded,
                  color: TuneColors.accent, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => _renameGroup(groupId, name),
                  child: Text(
                    name,
                    style: TuneFonts.callout
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const Icon(Icons.star_rounded,
                  size: 14, color: TuneColors.accent),
              const SizedBox(width: 4),
              Text(leaderName, style: TuneFonts.caption),
            ],
          ),
          const SizedBox(height: 8),

          // Member chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: memberNames
                .map<Widget>((n) => Chip(
                      label: Text(n, style: TuneFonts.caption),
                      backgroundColor: TuneColors.surfaceVariant,
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),

          // Volume master slider
          Row(
            children: [
              const Icon(Icons.volume_up_rounded,
                  size: 18, color: TuneColors.textSecondary),
              Expanded(
                child: Slider(
                  value: masterVolume.clamp(0.0, 1.0),
                  activeColor: TuneColors.accent,
                  inactiveColor: TuneColors.surfaceHigh,
                  onChanged: (v) {
                    setState(() {
                      group['master_volume'] = v;
                    });
                  },
                  onChangeEnd: (v) => _setGroupVolume(groupId, v),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '${(masterVolume * 100).round()}%',
                  style: TuneFonts.caption,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),

          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TuneColors.surfaceVariant,
                    foregroundColor: TuneColors.textPrimary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: _actionLoading['calibrate_$groupId'] == true
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: TuneColors.accent),
                        )
                      : const Icon(Icons.tune_rounded,
                          size: 18, color: TuneColors.accent),
                  label: const Text('Calibrer', style: TuneFonts.footnote),
                  onPressed: _actionLoading['calibrate_$groupId'] == true
                      ? null
                      : () => _calibrateGroup(groupId),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TuneColors.surfaceVariant,
                    foregroundColor: TuneColors.textPrimary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: _actionLoading['dissolve_$groupId'] == true
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: TuneColors.error),
                        )
                      : const Icon(Icons.link_off_rounded,
                          size: 18, color: TuneColors.error),
                  label:
                      const Text('Dissoudre', style: TuneFonts.footnote),
                  onPressed: _actionLoading['dissolve_$groupId'] == true
                      ? null
                      : () => _dissolveGroup(groupId),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Profils section
  // ---------------------------------------------------------------------------

  Widget _buildProfilesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader('Profils'),
        if (_loadingProfiles && _profiles.isEmpty)
          Container(
            color: TuneColors.surface,
            padding: const EdgeInsets.all(20),
            child: const Center(
              child: CircularProgressIndicator(color: TuneColors.accent),
            ),
          )
        else if (_profiles.isEmpty)
          Container(
            color: TuneColors.surface,
            padding: const EdgeInsets.all(16),
            child: Text(
              'Aucun profil sauvegardé',
              style: TuneFonts.footnote
                  .copyWith(color: TuneColors.textTertiary),
            ),
          )
        else
          Container(
            color: TuneColors.surface,
            child: Column(
              children: _profiles.asMap().entries.map((entry) {
                final idx = entry.key;
                final p = entry.value as Map<String, dynamic>;
                return Column(
                  children: [
                    if (idx > 0)
                      const Divider(
                          height: 1, indent: 56, color: TuneColors.divider),
                    _buildProfileTile(p),
                  ],
                );
              }).toList(),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: TuneColors.accent,
              minimumSize: const Size.fromHeight(44),
            ),
            icon: const Icon(Icons.save_rounded, size: 20),
            label: const Text('Sauvegarder config'),
            onPressed: () => _showSaveProfileDialog(),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTile(Map<String, dynamic> profile) {
    final profileId = profile['id'] as int? ?? 0;
    final name = profile['name'] as String? ?? 'Profil';
    final description = profile['description'] as String?;

    return ListTile(
      leading: const Icon(Icons.bookmark_rounded,
          color: TuneColors.accent),
      title: Text(name, style: TuneFonts.body),
      subtitle: description != null && description.isNotEmpty
          ? Text(description, style: TuneFonts.caption)
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _actionLoading['activate_$profileId'] == true
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: TuneColors.accent),
                )
              : TextButton(
                  onPressed: () => _activateProfile(profileId),
                  child: const Text('Activer',
                      style: TextStyle(color: TuneColors.accent)),
                ),
          _actionLoading['delete_$profileId'] == true
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: TuneColors.error),
                )
              : IconButton(
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: TuneColors.error, size: 20),
                  tooltip: 'Supprimer',
                  onPressed: () => _deleteProfile(profileId),
                ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Zone card widget
// ---------------------------------------------------------------------------

class _ZoneCard extends StatefulWidget {
  final Map<String, dynamic> zone;
  final String? latencyResult;
  final bool muteLoading;
  final bool latencyLoading;
  final VoidCallback onToggleMute;
  final ValueChanged<double> onVolumeChanged;
  final VoidCallback onMeasureLatency;

  const _ZoneCard({
    required this.zone,
    required this.latencyResult,
    required this.muteLoading,
    required this.latencyLoading,
    required this.onToggleMute,
    required this.onVolumeChanged,
    required this.onMeasureLatency,
  });

  @override
  State<_ZoneCard> createState() => _ZoneCardState();
}

class _ZoneCardState extends State<_ZoneCard> {
  late double _localVolume;

  @override
  void initState() {
    super.initState();
    _localVolume =
        (widget.zone['volume'] as num?)?.toDouble() ?? 0.5;
  }

  @override
  void didUpdateWidget(covariant _ZoneCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newVol = (widget.zone['volume'] as num?)?.toDouble() ?? 0.5;
    if ((oldWidget.zone['volume'] as num?)?.toDouble() != newVol) {
      _localVolume = newVol;
    }
  }

  @override
  Widget build(BuildContext context) {
    final z = widget.zone;
    final id = z['id'] as int;
    final name = z['name'] as String? ?? 'Zone $id';
    final outputType = z['output_type'] as String? ?? 'local';
    final host = z['host'] as String? ?? z['ip'] as String? ?? '';
    final muted = z['muted'] == true;
    final online = z['online'] != false; // default to true if absent

    return Container(
      width: 300,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TuneColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: name + output badge + online dot
          Row(
            children: [
              // Online indicator
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: online ? TuneColors.success : TuneColors.error,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: TuneFonts.callout
                      .copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: TuneColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _outputLabel(outputType),
                  style: TuneFonts.caption
                      .copyWith(color: TuneColors.accent),
                ),
              ),
            ],
          ),

          // Host/IP
          if (host.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(host,
                style: TuneFonts.caption
                    .copyWith(color: TuneColors.textTertiary)),
          ],

          const SizedBox(height: 10),

          // Volume + mute
          Row(
            children: [
              widget.muteLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: TuneColors.accent),
                    )
                  : IconButton(
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 24, minHeight: 24),
                      icon: Icon(
                        muted
                            ? Icons.volume_off_rounded
                            : Icons.volume_up_rounded,
                        size: 20,
                        color: muted
                            ? TuneColors.error
                            : TuneColors.textSecondary,
                      ),
                      tooltip: muted ? 'Réactiver' : 'Sourdine',
                      onPressed: widget.onToggleMute,
                    ),
              Expanded(
                child: Slider(
                  value: _localVolume.clamp(0.0, 1.0),
                  activeColor:
                      muted ? TuneColors.textTertiary : TuneColors.accent,
                  inactiveColor: TuneColors.surfaceHigh,
                  onChanged: muted
                      ? null
                      : (v) => setState(() => _localVolume = v),
                  onChangeEnd: muted ? null : widget.onVolumeChanged,
                ),
              ),
              SizedBox(
                width: 36,
                child: Text(
                  '${(_localVolume * 100).round()}%',
                  style: TuneFonts.caption,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),

          // Latency
          Row(
            children: [
              widget.latencyLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: TuneColors.accent),
                    )
                  : TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: widget.onMeasureLatency,
                      child: const Text('Latence',
                          style: TextStyle(
                              color: TuneColors.accent, fontSize: 13)),
                    ),
              if (widget.latencyResult != null) ...[
                const SizedBox(width: 8),
                Text(
                  widget.latencyResult!,
                  style: TuneFonts.caption
                      .copyWith(color: TuneColors.textSecondary),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _outputLabel(String type) {
    switch (type) {
      case 'dlna':
        return 'DLNA';
      case 'airplay':
        return 'AirPlay';
      case 'bluetooth':
        return 'Bluetooth';
      default:
        return 'Local';
    }
  }
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        title.toUpperCase(),
        style: TuneFonts.footnote.copyWith(
          color: TuneColors.textTertiary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
