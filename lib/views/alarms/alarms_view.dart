import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/tune_api_client.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// AlarmsView — gestion des alarmes (CRUD via API REST).
//
// Le serveur gere le scheduling ; le client ne fait que configurer.
// Champs : name, time, days, skip_holidays, holiday_country, zone_id,
//          source_type, source_id, source_name, volume, fade_in_seconds, enabled.
// ---------------------------------------------------------------------------

class AlarmsView extends StatefulWidget {
  const AlarmsView({super.key});

  @override
  State<AlarmsView> createState() => _AlarmsViewState();
}

class _AlarmsViewState extends State<AlarmsView> {
  List<Map<String, dynamic>> _alarms = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  TuneApiClient? get _api => context.read<AppState>().apiClient;

  Future<void> _load() async {
    final api = _api;
    if (api == null) {
      setState(() {
        _error = 'Non connecte a un serveur distant';
        _loading = false;
      });
      return;
    }
    setState(() => _loading = true);
    try {
      final data = await api.getAlarms();
      if (mounted) {
        setState(() {
          _alarms = data.cast<Map<String, dynamic>>();
          _loading = false;
          _error = null;
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

  Future<void> _toggleEnabled(Map<String, dynamic> alarm) async {
    final api = _api;
    if (api == null) return;
    final id = alarm['id'] as int;
    final current = alarm['enabled'] == 1 || alarm['enabled'] == true;
    try {
      await api.updateAlarm(id, {'enabled': !current});
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  Future<void> _deleteAlarm(int id) async {
    final api = _api;
    if (api == null) return;
    try {
      await api.deleteAlarm(id);
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  Future<void> _snoozeAlarm(int id) async {
    final api = _api;
    if (api == null) return;
    try {
      await api.snoozeAlarm(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alarme reportee de 5 min'),
            backgroundColor: TuneColors.accent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  void _openEditor({Map<String, dynamic>? existing}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _AlarmEditorView(
          api: _api!,
          existing: existing,
          onSaved: () {
            _load();
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Alarmes', style: TuneFonts.title3),
      ),
      floatingActionButton: _api != null
          ? FloatingActionButton(
              backgroundColor: TuneColors.accent,
              onPressed: () => _openEditor(),
              child: const Icon(Icons.add),
            )
          : null,
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
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: 48, color: TuneColors.error),
              const SizedBox(height: 12),
              Text(_error!, style: TuneFonts.footnote, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: _load, child: const Text('Reessayer')),
            ],
          ),
        ),
      );
    }
    if (_alarms.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.alarm_rounded,
                size: 56, color: TuneColors.textTertiary),
            const SizedBox(height: 12),
            Text('Aucune alarme', style: TuneFonts.subheadline),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: _alarms.length,
        separatorBuilder: (_, _) =>
            const Divider(height: 1, indent: 16, color: TuneColors.divider),
        itemBuilder: (_, i) => _AlarmTile(
          alarm: _alarms[i],
          onToggle: () => _toggleEnabled(_alarms[i]),
          onTap: () => _openEditor(existing: _alarms[i]),
          onDelete: () => _deleteAlarm(_alarms[i]['id'] as int),
          onSnooze: _snoozeAlarm,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _AlarmTile
// ---------------------------------------------------------------------------

class _AlarmTile extends StatelessWidget {
  final Map<String, dynamic> alarm;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final Future<void> Function(int id)? onSnooze;

  const _AlarmTile({
    required this.alarm,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
    this.onSnooze,
  });

  @override
  Widget build(BuildContext context) {
    final time = alarm['time'] as String? ?? '00:00';
    final name = alarm['name'] as String? ?? '';
    final enabled = alarm['enabled'] == 1 || alarm['enabled'] == true;
    final daysStr = alarm['days'] as String? ?? '';
    final sourceName = alarm['source_name'] as String? ?? '';
    final skipHolidays = alarm['skip_holidays'] == 1 || alarm['skip_holidays'] == true;
    final fadeIn = alarm['fade_in_seconds'] as num?;
    final zoneName = alarm['zone_name'] as String?;
    final zoneId = alarm['zone_id'];

    return Dismissible(
      key: ValueKey(alarm['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w300,
                color: enabled ? TuneColors.textPrimary : TuneColors.textTertiary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (name.isNotEmpty)
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: enabled ? TuneColors.textPrimary : TuneColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  // Day-of-week chips
                  _DayChips(daysStr: daysStr, enabled: enabled),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (sourceName.isNotEmpty) ...[
                        Icon(Icons.music_note_rounded, size: 12,
                            color: enabled ? TuneColors.textSecondary : TuneColors.textTertiary),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            sourceName,
                            style: TuneFonts.caption.copyWith(
                              color: enabled ? TuneColors.textSecondary : TuneColors.textTertiary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      if (fadeIn != null && fadeIn > 0) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.trending_up_rounded, size: 12,
                            color: enabled ? TuneColors.textTertiary : TuneColors.textTertiary),
                        const SizedBox(width: 2),
                        Text('${fadeIn.toInt()}s',
                            style: TuneFonts.caption),
                      ],
                      if (zoneName != null || zoneId != null) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.speaker_rounded, size: 12,
                            color: enabled ? TuneColors.textTertiary : TuneColors.textTertiary),
                        const SizedBox(width: 2),
                        Text(zoneName ?? 'Zone $zoneId',
                            style: TuneFonts.caption),
                      ],
                    ],
                  ),
                  if (skipHolidays)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text('Hors jours feries', style: TuneFonts.caption),
                    ),
                ],
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch.adaptive(
              value: enabled,
              activeTrackColor: TuneColors.accent,
              onChanged: (_) => onToggle(),
            ),
            if (enabled && onSnooze != null)
              GestureDetector(
                onTap: () => onSnooze!(alarm['id'] as int),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: TuneColors.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('Snooze',
                      style: TuneFonts.caption.copyWith(
                        color: TuneColors.accent,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
          ],
        ),
      ),
    );
  }

}

// ---------------------------------------------------------------------------
// _AlarmEditorView — create / edit an alarm
// ---------------------------------------------------------------------------

class _AlarmEditorView extends StatefulWidget {
  final TuneApiClient api;
  final Map<String, dynamic>? existing;
  final VoidCallback onSaved;

  const _AlarmEditorView({
    required this.api,
    this.existing,
    required this.onSaved,
  });

  @override
  State<_AlarmEditorView> createState() => _AlarmEditorViewState();
}

class _AlarmEditorViewState extends State<_AlarmEditorView> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _sourceIdCtrl;
  late final TextEditingController _sourceNameCtrl;

  late TimeOfDay _time;
  late Set<int> _selectedDays; // 1=Mon..7=Sun
  late bool _skipHolidays;
  late String _holidayCountry;
  late String _sourceType;
  late double _volume;
  late double _fadeIn;
  late bool _enabled;
  late int? _zoneId;
  List<dynamic> _availableZones = [];

  bool _saving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?['name'] as String? ?? '');
    _sourceIdCtrl = TextEditingController(text: e?['source_id'] as String? ?? '');
    _sourceNameCtrl = TextEditingController(text: e?['source_name'] as String? ?? '');

    // Parse time
    final timeStr = e?['time'] as String? ?? '07:00';
    final parts = timeStr.split(':');
    _time = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 7,
      minute: parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0,
    );

    // Parse days
    final daysStr = e?['days'] as String? ?? '1,2,3,4,5';
    _selectedDays = daysStr
        .split(',')
        .map((s) => int.tryParse(s.trim()))
        .whereType<int>()
        .toSet();

    _skipHolidays = e?['skip_holidays'] == 1 || e?['skip_holidays'] == true;
    _holidayCountry = e?['holiday_country'] as String? ?? 'FR';
    _sourceType = e?['source_type'] as String? ?? 'radio';
    _volume = (e?['volume'] as num?)?.toDouble() ?? 50;
    _fadeIn = (e?['fade_in_seconds'] as num?)?.toDouble() ?? 30;
    _enabled = e?['enabled'] == 1 || e?['enabled'] == true || e == null;
    _zoneId = e?['zone_id'] as int?;
    _loadZones();
  }

  Future<void> _loadZones() async {
    try {
      final zones = await widget.api.getZones();
      if (mounted) setState(() => _availableZones = zones);
    } catch (_) {}
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _sourceIdCtrl.dispose();
    _sourceNameCtrl.dispose();
    super.dispose();
  }

  String _formatTime() =>
      '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';

  Map<String, dynamic> _toJson() => {
        'name': _nameCtrl.text.trim().isEmpty ? 'Alarme' : _nameCtrl.text.trim(),
        'time': _formatTime(),
        'days': _selectedDays.toList()..sort(),
        'skip_holidays': _skipHolidays,
        'holiday_country': _holidayCountry,
        'source_type': _sourceType,
        'source_id': _sourceIdCtrl.text.trim(),
        'source_name': _sourceNameCtrl.text.trim(),
        'volume': _volume.round(),
        'fade_in_seconds': _fadeIn.round(),
        'enabled': _enabled,
        if (_zoneId != null) 'zone_id': _zoneId,
      };

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final body = _toJson();
      // Convert days list back to comma-separated string
      body['days'] = (body['days'] as List).join(',');

      if (_isEdit) {
        await widget.api.updateAlarm(widget.existing!['id'] as int, body);
      } else {
        await widget.api.createAlarm(body);
      }
      widget.onSaved();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: TuneColors.accent,
            surface: TuneColors.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(
          _isEdit ? 'Modifier l\'alarme' : 'Nouvelle alarme',
          style: TuneFonts.title3,
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: TuneColors.accent),
                  )
                : const Text('Enregistrer',
                    style: TextStyle(color: TuneColors.accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---- Time ----
          _SectionHeader('Heure'),
          InkWell(
            onTap: _pickTime,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: TuneColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _formatTime(),
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w200,
                  color: TuneColors.accent,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ---- Name ----
          _SectionHeader('Nom'),
          _Field(controller: _nameCtrl, hint: 'Reveil'),

          const SizedBox(height: 20),

          // ---- Days ----
          _SectionHeader('Jours'),
          _DaySelector(
            selected: _selectedDays,
            onChanged: (days) => setState(() => _selectedDays = days),
          ),

          const SizedBox(height: 20),

          // ---- Skip holidays ----
          _SwitchRow(
            label: 'Ignorer les jours feries',
            value: _skipHolidays,
            onChanged: (v) => setState(() => _skipHolidays = v),
          ),
          if (_skipHolidays)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Row(
                children: [
                  const Text('Pays : ', style: TuneFonts.footnote),
                  DropdownButton<String>(
                    value: _holidayCountry,
                    dropdownColor: TuneColors.surface,
                    style: TuneFonts.body,
                    items: const [
                      DropdownMenuItem(value: 'FR', child: Text('France')),
                      DropdownMenuItem(value: 'BE', child: Text('Belgique')),
                      DropdownMenuItem(value: 'CH', child: Text('Suisse')),
                      DropdownMenuItem(value: 'CA', child: Text('Canada')),
                      DropdownMenuItem(value: 'US', child: Text('USA')),
                      DropdownMenuItem(value: 'DE', child: Text('Allemagne')),
                      DropdownMenuItem(value: 'GB', child: Text('UK')),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _holidayCountry = v);
                    },
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),

          // ---- Source ----
          _SectionHeader('Source'),
          DropdownButtonFormField<String>(
            initialValue: _sourceType,
            dropdownColor: TuneColors.surface,
            style: TuneFonts.body,
            decoration: const InputDecoration(
              labelText: 'Type',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'radio', child: Text('Radio')),
              DropdownMenuItem(value: 'playlist', child: Text('Playlist')),
              DropdownMenuItem(value: 'album', child: Text('Album')),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _sourceType = v);
            },
          ),
          const SizedBox(height: 12),
          _Field(
            controller: _sourceNameCtrl,
            hint: _sourceType == 'radio' ? 'FIP' : 'Nom',
            label: 'Nom de la source',
          ),
          const SizedBox(height: 12),
          _Field(
            controller: _sourceIdCtrl,
            hint: _sourceType == 'radio'
                ? 'https://stream.fip.fr/fip-hifi.aac'
                : _sourceType == 'playlist'
                    ? 'ID de la playlist'
                    : 'ID de l\'album',
            label: _sourceType == 'radio' ? 'URL du stream' : 'Identifiant',
          ),

          const SizedBox(height: 20),

          // ---- Zone ----
          if (_availableZones.isNotEmpty) ...[
            _SectionHeader('Zone'),
            DropdownButtonFormField<int?>(
              value: _zoneId,
              dropdownColor: TuneColors.surface,
              style: TuneFonts.body,
              decoration: const InputDecoration(
                labelText: 'Zone de lecture',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<int?>(value: null, child: Text('Defaut')),
                ..._availableZones.map((z) {
                  final id = z is Map ? z['id'] as int : z as int;
                  final name = z is Map ? (z['name'] as String? ?? 'Zone $id') : 'Zone $id';
                  return DropdownMenuItem<int?>(value: id, child: Text(name));
                }),
              ],
              onChanged: (v) => setState(() => _zoneId = v),
            ),
            const SizedBox(height: 20),
          ],

          // ---- Volume ----
          _SectionHeader('Volume : ${_volume.round()}%'),
          Slider(
            value: _volume,
            min: 0,
            max: 100,
            divisions: 20,
            activeColor: TuneColors.accent,
            inactiveColor: TuneColors.surfaceHigh,
            onChanged: (v) => setState(() => _volume = v),
          ),

          const SizedBox(height: 12),

          // ---- Fade-in ----
          _SectionHeader('Fondu : ${_fadeIn.round()}s'),
          Slider(
            value: _fadeIn,
            min: 0,
            max: 300,
            divisions: 30,
            activeColor: TuneColors.accent,
            inactiveColor: TuneColors.surfaceHigh,
            onChanged: (v) => setState(() => _fadeIn = v),
          ),

          const SizedBox(height: 20),

          // ---- Enabled ----
          _SwitchRow(
            label: 'Active',
            value: _enabled,
            onChanged: (v) => setState(() => _enabled = v),
          ),

          const SizedBox(height: 40),

          // ---- Delete ----
          if (_isEdit)
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.delete_rounded, color: TuneColors.error),
                label: const Text('Supprimer',
                    style: TextStyle(color: TuneColors.error)),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: TuneColors.surface,
                      title: const Text('Supprimer l\'alarme ?', style: TuneFonts.title3),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Supprimer',
                              style: TextStyle(color: TuneColors.error)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true && mounted) {
                    try {
                      await widget.api.deleteAlarm(widget.existing!['id'] as int);
                      widget.onSaved();
                    } catch (e) {
                      if (mounted) {
                        messenger.showSnackBar(
                          SnackBar(content: Text('Erreur: $e')),
                        );
                      }
                    }
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Small reusable widgets
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: TuneColors.textSecondary,
            letterSpacing: 0.5,
          )),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? label;

  const _Field({required this.controller, required this.hint, this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TuneFonts.body,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: TuneColors.surface,
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TuneColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SwitchListTile.adaptive(
        title: Text(label, style: TuneFonts.body),
        value: value,
        activeTrackColor: TuneColors.accent,
        onChanged: onChanged,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _DayChips — compact day-of-week indicator for alarm list tile
// ---------------------------------------------------------------------------

class _DayChips extends StatelessWidget {
  final String daysStr;
  final bool enabled;

  const _DayChips({required this.daysStr, required this.enabled});

  static const _labels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    final nums = daysStr
        .split(',')
        .map((s) => int.tryParse(s.trim()))
        .whereType<int>()
        .toSet();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(7, (i) {
          final day = i + 1;
          final active = nums.contains(day);
          return Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(right: 3),
            decoration: BoxDecoration(
              color: active
                  ? (enabled ? TuneColors.accent : TuneColors.textTertiary)
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: active
                    ? Colors.transparent
                    : (enabled ? TuneColors.divider : TuneColors.surfaceHigh),
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              _labels[i],
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: active
                    ? Colors.white
                    : (enabled ? TuneColors.textTertiary : TuneColors.surfaceHigh),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _DaySelector — 7 toggle buttons Mon-Sun
// ---------------------------------------------------------------------------

class _DaySelector extends StatelessWidget {
  final Set<int> selected;
  final ValueChanged<Set<int>> onChanged;

  const _DaySelector({required this.selected, required this.onChanged});

  static const _labels = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final day = i + 1; // 1=Mon..7=Sun
        final active = selected.contains(day);
        return GestureDetector(
          onTap: () {
            final next = Set<int>.from(selected);
            if (active) {
              next.remove(day);
            } else {
              next.add(day);
            }
            onChanged(next);
          },
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: active ? TuneColors.accent : TuneColors.surface,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              _labels[i],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : TuneColors.textSecondary,
              ),
            ),
          ),
        );
      }),
    );
  }
}
