import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/smb/smb_indexer.dart';
import '../../server/smb/smb_music_client.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// SMBSetupView — configuration et indexation d'un partage SMB/Samba.
// Miroir de SMBSetupView.swift (iOS)
// ---------------------------------------------------------------------------

enum _Phase { enterHost, selectShare, manualShare, scanning, done }

class SMBSetupView extends StatefulWidget {
  const SMBSetupView({super.key});

  @override
  State<SMBSetupView> createState() => _SMBSetupViewState();
}

class _SMBSetupViewState extends State<SMBSetupView> {
  final _hostCtrl = TextEditingController();
  final _userCtrl = TextEditingController(text: 'guest');
  final _passCtrl = TextEditingController();
  final _manualShareCtrl = TextEditingController();

  _Phase _phase = _Phase.enterHost;
  List<SmbShareInfo> _shares = [];
  String _selectedShare = '';
  bool _isConnecting = false;
  String? _error;
  int _scanProgress = 0;
  String _scanPath = '';

  @override
  void dispose() {
    _hostCtrl.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    _manualShareCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(l.smbNavTitle, style: TuneFonts.title3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Icon(
              Icons.storage_rounded,
              size: 56,
              color: TuneColors.accent,
            ),
            const SizedBox(height: 16),
            Text(l.smbTitle, style: TuneFonts.title3),
            const SizedBox(height: 24),
            _buildPhase(context, l),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TuneColors.error.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _error!,
                  style: TuneFonts.footnote.copyWith(color: TuneColors.error),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildPhase(BuildContext context, AppLocalizations l) {
    switch (_phase) {
      case _Phase.enterHost:
        return _buildHostForm(l);
      case _Phase.selectShare:
        return _buildShareSelection(l);
      case _Phase.manualShare:
        return _buildManualShare(l);
      case _Phase.scanning:
        return _buildScanning(l);
      case _Phase.done:
        return _buildDone(l);
    }
  }

  // -------------------------------------------------------------------------
  // Phase 1 — Saisie hôte
  // -------------------------------------------------------------------------

  Widget _buildHostForm(AppLocalizations l) {
    return Column(
      children: [
        Text(l.smbHostHint, style: TuneFonts.body.copyWith(color: TuneColors.textSecondary)),
        const SizedBox(height: 16),
        _TuneTextField(controller: _hostCtrl, hint: l.smbHostLabel,
            keyboardType: TextInputType.numberWithOptions(decimal: true)),
        const SizedBox(height: 8),
        _TuneTextField(controller: _userCtrl, hint: l.smbUser),
        const SizedBox(height: 8),
        _TuneTextField(controller: _passCtrl, hint: l.smbPassword, obscure: true),
        const SizedBox(height: 24),
        _TuneButton(
          label: _isConnecting ? null : l.smbConnect,
          loading: _isConnecting,
          disabled: _hostCtrl.text.trim().isEmpty,
          onPressed: _connectAndListShares,
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Phase 2 — Sélection du partage
  // -------------------------------------------------------------------------

  Widget _buildShareSelection(AppLocalizations l) {
    return Column(
      children: [
        Text(l.smbSelectShare, style: TuneFonts.body.copyWith(color: TuneColors.textSecondary)),
        const SizedBox(height: 16),
        ..._shares.map((share) => _ShareTile(
              name: share.name,
              onTap: () => _startScan(share.name),
            )),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => setState(() { _phase = _Phase.enterHost; _error = null; }),
          child: Text(l.smbBack, style: const TextStyle(color: TuneColors.textSecondary)),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Phase 3 — Partage manuel (fallback)
  // -------------------------------------------------------------------------

  Widget _buildManualShare(AppLocalizations l) {
    return Column(
      children: [
        const Icon(Icons.warning_amber_rounded, size: 40, color: Colors.orange),
        const SizedBox(height: 12),
        Text(l.smbManualHint,
            style: TuneFonts.body.copyWith(color: TuneColors.textSecondary),
            textAlign: TextAlign.center),
        const SizedBox(height: 16),
        _TuneTextField(controller: _manualShareCtrl, hint: l.smbShareName),
        const SizedBox(height: 16),
        _TuneButton(
          label: l.smbScan,
          disabled: _manualShareCtrl.text.trim().isEmpty,
          onPressed: () => _startScan(_manualShareCtrl.text.trim()),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => setState(() { _phase = _Phase.enterHost; _error = null; }),
          child: Text(l.smbBack, style: const TextStyle(color: TuneColors.textSecondary)),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Phase 4 — Scan en cours
  // -------------------------------------------------------------------------

  Widget _buildScanning(AppLocalizations l) {
    return Column(
      children: [
        const SizedBox(
          width: 48, height: 48,
          child: CircularProgressIndicator(color: TuneColors.accent, strokeWidth: 3),
        ),
        const SizedBox(height: 20),
        Text(l.smbScanning, style: TuneFonts.title3),
        const SizedBox(height: 8),
        Text(
          l.smbScanCount(_scanProgress),
          style: TuneFonts.body.copyWith(color: TuneColors.accent),
        ),
        if (_scanPath.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            _scanPath,
            style: TuneFonts.caption.copyWith(color: TuneColors.textTertiary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Phase 5 — Terminé
  // -------------------------------------------------------------------------

  Widget _buildDone(AppLocalizations l) {
    return Column(
      children: [
        const Icon(Icons.check_circle_rounded, size: 56, color: TuneColors.success),
        const SizedBox(height: 16),
        Text(l.smbDoneTitle, style: TuneFonts.title3),
        const SizedBox(height: 8),
        Text(
          l.smbDoneBody(_scanProgress, '${_hostCtrl.text}/$_selectedShare'),
          style: TuneFonts.body.copyWith(color: TuneColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        _TuneButton(
          label: l.smbAddAnother,
          onPressed: () => setState(() {
            _phase = _Phase.enterHost;
            _shares = [];
            _selectedShare = '';
            _scanProgress = 0;
            _error = null;
          }),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Actions
  // -------------------------------------------------------------------------

  Future<void> _connectAndListShares() async {
    setState(() { _isConnecting = true; _error = null; });

    final host = _hostCtrl.text.trim();
    final user = _userCtrl.text.trim();
    final pass = _passCtrl.text;

    try {
      final client = SmbMusicClient(host: host, username: user, password: pass);
      await client.connect();

      final shares = await client.listShares();
      await client.disconnect();

      if (shares.isEmpty) {
        setState(() { _phase = _Phase.manualShare; _error = null; });
      } else {
        setState(() { _shares = shares; _phase = _Phase.selectShare; });
      }
    } on SmbException catch (e) {
      setState(() { _error = e.message; });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _phase = _Phase.manualShare;
      });
    } finally {
      setState(() => _isConnecting = false);
    }
  }

  Future<void> _startScan(String shareName) async {
    setState(() {
      _selectedShare = shareName;
      _phase = _Phase.scanning;
      _error = null;
      _scanProgress = 0;
    });

    final host = _hostCtrl.text.trim();
    final user = _userCtrl.text.trim();
    final pass = _passCtrl.text;
    final app = context.read<AppState>();

    try {
      final client = SmbMusicClient(
        host: host,
        share: shareName,
        username: user,
        password: pass,
      );
      await client.connect();

      final indexer = SmbIndexer(
        client: client,
        db: app.engine.db,
        serverName: host,
        shareName: shareName,
      );

      final added = await indexer.run(
        onProgress: (count, path) {
          if (mounted) {
            setState(() {
              _scanProgress = count;
              _scanPath = path;
            });
          }
        },
      );

      await client.disconnect();

      // Recharge la bibliothèque
      await app.startServer();

      if (mounted) {
        setState(() {
          _scanProgress = added;
          _phase = _Phase.done;
        });
      }
    } on SmbException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _phase = _shares.isNotEmpty ? _Phase.selectShare : _Phase.manualShare;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _phase = _shares.isNotEmpty ? _Phase.selectShare : _Phase.manualShare;
        });
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Widgets helper internes
// ---------------------------------------------------------------------------

class _TuneTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;

  const _TuneTextField({
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      autocorrect: false,
      style: TuneFonts.body,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TuneFonts.body.copyWith(color: TuneColors.textTertiary),
        filled: true,
        fillColor: TuneColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: TuneColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: TuneColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: TuneColors.accent),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class _TuneButton extends StatelessWidget {
  final String? label;
  final bool loading;
  final bool disabled;
  final VoidCallback? onPressed;

  const _TuneButton({
    this.label,
    this.loading = false,
    this.disabled = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (disabled || loading) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: TuneColors.accent,
          disabledBackgroundColor: TuneColors.surfaceVariant,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: loading
            ? const SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(label ?? '',
                style: TuneFonts.title3.copyWith(color: Colors.white)),
      ),
    );
  }
}

class _ShareTile extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  const _ShareTile({required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TuneColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: TuneColors.divider),
          ),
          child: Row(
            children: [
              const Icon(Icons.folder_rounded, color: TuneColors.accent),
              const SizedBox(width: 12),
              Expanded(child: Text(name, style: TuneFonts.body)),
              const Icon(Icons.chevron_right_rounded, color: TuneColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
