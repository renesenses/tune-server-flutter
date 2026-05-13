import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// LastfmView — Last.fm scrobble settings
//
// Connect/disconnect Last.fm account, view scrobble status.
// API: POST /api/v1/lastfm/authenticate
//      GET  /api/v1/lastfm/status
//      POST /api/v1/lastfm/disconnect
// ---------------------------------------------------------------------------

class LastfmView extends StatefulWidget {
  const LastfmView({super.key});

  @override
  State<LastfmView> createState() => _LastfmViewState();
}

class _LastfmViewState extends State<LastfmView> {
  Map<String, dynamic>? _status;
  bool _loading = true;
  bool _busy = false;
  String? _error;

  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) {
      if (mounted) setState(() { _loading = false; _error = 'Not connected to server'; });
      return;
    }
    try {
      final s = await api.getLastfmStatus();
      if (!mounted) return;
      setState(() { _status = s; _loading = false; _error = null; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _loading = false; _error = '$e'; });
    }
  }

  bool get _isConnected => _status?['connected'] == true;

  Future<void> _authenticate() async {
    final username = _usernameCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    if (username.isEmpty || password.isEmpty) {
      setState(() => _error = 'Username and password are required');
      return;
    }
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    setState(() { _busy = true; _error = null; });
    try {
      final result = await api.lastfmAuthenticate(username: username, password: password);
      if (!mounted) return;
      setState(() {
        _status = result;
        _busy = false;
        _usernameCtrl.clear();
        _passwordCtrl.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Last.fm connected.')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() { _busy = false; _error = '$e'; });
    }
  }

  Future<void> _disconnect() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    setState(() { _busy = true; _error = null; });
    try {
      final result = await api.disconnectLastfm();
      if (!mounted) return;
      setState(() { _status = result; _busy = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Last.fm disconnected.')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() { _busy = false; _error = '$e'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Last.fm Scrobble', style: TuneFonts.title3),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: TuneColors.accent))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Description
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: TuneColors.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD51007).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.music_note_rounded, color: Color(0xFFD51007)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Last.fm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: TuneColors.textPrimary)),
                            const SizedBox(height: 4),
                            Text(
                              'Scrobble your listening history to Last.fm. '
                              'Tracks are automatically scrobbled when played on any zone.',
                              style: TuneFonts.footnote,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Status
                if (_isConnected) ...[
                  _StatusSection(status: _status!),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _busy ? null : _disconnect,
                      icon: _busy
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.link_off_rounded),
                      label: Text(_busy ? 'Disconnecting...' : 'Disconnect'),
                      style: FilledButton.styleFrom(
                        backgroundColor: TuneColors.error,
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                ] else ...[
                  // Login form
                  const Text('CONNECT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TuneColors.textTertiary, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _usernameCtrl,
                    style: TuneFonts.body,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: const Icon(Icons.person_outline, color: TuneColors.textSecondary),
                      filled: true,
                      fillColor: TuneColors.surface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: TuneColors.divider)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: TuneColors.divider)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: TuneColors.accent)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordCtrl,
                    style: TuneFonts.body,
                    obscureText: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline, color: TuneColors.textSecondary),
                      filled: true,
                      fillColor: TuneColors.surface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: TuneColors.divider)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: TuneColors.divider)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: TuneColors.accent)),
                    ),
                    onSubmitted: (_) => _authenticate(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _busy ? null : _authenticate,
                      icon: _busy
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.link_rounded),
                      label: Text(_busy ? 'Connecting...' : 'Connect'),
                      style: FilledButton.styleFrom(
                        backgroundColor: TuneColors.accent,
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                ],

                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: TuneColors.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: TuneColors.error, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_error!, style: TuneFonts.caption.copyWith(color: TuneColors.error))),
                      ],
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Status section — shows connected user and scrobble stats
// ---------------------------------------------------------------------------

class _StatusSection extends StatelessWidget {
  final Map<String, dynamic> status;
  const _StatusSection({required this.status});

  @override
  Widget build(BuildContext context) {
    final username = status['username'] as String? ?? '';
    final scrobbleCount = status['scrobble_count'] as int? ?? 0;
    final lastScrobble = status['last_scrobble'] as String?;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TuneColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: TuneColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text('Connected', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: TuneColors.success)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 18, color: TuneColors.textSecondary),
              const SizedBox(width: 8),
              Text(username, style: TuneFonts.body),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.music_note_rounded, size: 18, color: TuneColors.textSecondary),
              const SizedBox(width: 8),
              Text('$scrobbleCount scrobbles', style: TuneFonts.footnote),
            ],
          ),
          if (lastScrobble != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: TuneColors.textSecondary),
                const SizedBox(width: 8),
                Text('Last: $lastScrobble', style: TuneFonts.footnote),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
