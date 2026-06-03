import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../server/metadata/listenbrainz_scrobbler.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// ListenBrainzView — ListenBrainz scrobble settings
// Token input, save/disconnect, connection status indicator.
// Uses ListenBrainzScrobbler from lib/server/metadata/listenbrainz_scrobbler.dart.
// Miroir de ListenBrainzView.swift (iOS)
// ---------------------------------------------------------------------------

class ListenBrainzView extends StatefulWidget {
  const ListenBrainzView({super.key});

  @override
  State<ListenBrainzView> createState() => _ListenBrainzViewState();
}

class _ListenBrainzViewState extends State<ListenBrainzView> {
  final _tokenCtrl = TextEditingController();
  bool _busy = false;
  String? _error;
  bool _obscureToken = true;

  ListenBrainzScrobbler? _scrobbler;

  @override
  void initState() {
    super.initState();
    _scrobbler = context.read<AppState>().engine.listenBrainz;
  }

  @override
  void dispose() {
    _tokenCtrl.dispose();
    super.dispose();
  }

  bool get _isConnected => _scrobbler?.isAuthenticated ?? false;
  String? get _username => _scrobbler?.username;

  Future<void> _authenticate() async {
    final token = _tokenCtrl.text.trim();
    if (token.isEmpty) {
      setState(() => _error = 'Please enter your user token');
      return;
    }

    final scrobbler = _scrobbler;
    if (scrobbler == null) {
      setState(() => _error = 'Scrobbler not available');
      return;
    }

    setState(() { _busy = true; _error = null; });

    try {
      final result = await scrobbler.authenticate(token);
      if (!mounted) return;

      if (result.success) {
        setState(() {
          _busy = false;
          _tokenCtrl.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connected as ${scrobbler.username ?? "unknown"}'),
          ),
        );
      } else {
        setState(() {
          _busy = false;
          _error = result.error ?? 'Authentication failed';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() { _busy = false; _error = '$e'; });
    }
  }

  void _disconnect() {
    _scrobbler?.logout();
    setState(() { _error = null; });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ListenBrainz disconnected.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('ListenBrainz', style: TuneFonts.title3),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Description card
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
                    color: const Color(0xFF353070).withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.hearing_rounded,
                      color: Color(0xFF8070E8)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ListenBrainz',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: TuneColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text(
                        'Scrobble your listening history to ListenBrainz. '
                        'Get your user token from listenbrainz.org/settings.',
                        style: TuneFonts.footnote,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (_isConnected) ...[
            // Connected status
            _StatusSection(username: _username ?? ''),
            const SizedBox(height: 20),

            // Disconnect button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _busy ? null : _disconnect,
                icon: const Icon(Icons.link_off_rounded),
                label: const Text('Disconnect'),
                style: FilledButton.styleFrom(
                  backgroundColor: TuneColors.error,
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ),
          ] else ...[
            // Token input
            const Text('CONNECT',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: TuneColors.textTertiary,
                    letterSpacing: 1)),
            const SizedBox(height: 12),

            TextField(
              controller: _tokenCtrl,
              style: TuneFonts.body,
              autocorrect: false,
              obscureText: _obscureToken,
              decoration: InputDecoration(
                labelText: 'User Token',
                prefixIcon: const Icon(Icons.key_rounded,
                    color: TuneColors.textSecondary),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureToken
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: TuneColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscureToken = !_obscureToken),
                ),
                filled: true,
                fillColor: TuneColors.surface,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: TuneColors.divider)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: TuneColors.divider)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: TuneColors.accent)),
              ),
              onSubmitted: (_) => _authenticate(),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _busy ? null : _authenticate,
                icon: _busy
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.link_rounded),
                label: Text(_busy ? 'Validating...' : 'Save & Connect'),
                style: FilledButton.styleFrom(
                  backgroundColor: TuneColors.accent,
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ),
          ],

          // Error display
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
                  const Icon(Icons.error_outline,
                      color: TuneColors.error, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_error!,
                        style: TuneFonts.caption
                            .copyWith(color: TuneColors.error)),
                  ),
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
// _StatusSection — connected user info
// ---------------------------------------------------------------------------

class _StatusSection extends StatelessWidget {
  final String username;
  const _StatusSection({required this.username});

  @override
  Widget build(BuildContext context) {
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
              const Text('Connected',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: TuneColors.success)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person_outline,
                  size: 18, color: TuneColors.textSecondary),
              const SizedBox(width: 8),
              Text(username, style: TuneFonts.body),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.hearing_rounded,
                  size: 18, color: TuneColors.textSecondary),
              const SizedBox(width: 8),
              Text('Tracks will be scrobbled automatically',
                  style: TuneFonts.footnote),
            ],
          ),
        ],
      ),
    );
  }
}
