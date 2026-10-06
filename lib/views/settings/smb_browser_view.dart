import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../services/tune_api_client.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// SMBBrowserView — discovers SMB shares on the network (remote mode).
// GET /network/smb/discover, POST /network/smb/mount, POST /network/smb/credentials.
// ---------------------------------------------------------------------------

class SMBBrowserView extends StatefulWidget {
  const SMBBrowserView({super.key});

  @override
  State<SMBBrowserView> createState() => _SMBBrowserViewState();
}

class _SMBBrowserViewState extends State<SMBBrowserView> {
  List<Map<String, dynamic>> _shares = [];
  bool _loading = true;
  String? _error;
  bool _notConnected = false;

  @override
  void initState() {
    super.initState();
    _discover();
  }

  TuneApiClient? get _api => context.read<AppState>().apiClient;

  Future<void> _discover() async {
    final api = _api;
    if (api == null) {
      setState(() {
        _error = null;
        _notConnected = true;
        _loading = false;
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _notConnected = false;
    });
    try {
      final data = await api.discoverSMBShares();
      if (mounted) {
        setState(() {
          _shares = data.cast<Map<String, dynamic>>();
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

  Future<void> _mountShare(Map<String, dynamic> share) async {
    final api = _api;
    if (api == null) return;

    final userCtrl = TextEditingController(text: 'guest');
    final passCtrl = TextEditingController();
    final l = AppLocalizations.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(
          l.cfgSmbMountTitle(
              '${share['name'] ?? share['share_name'] ?? ''}'),
          style: TuneFonts.title3,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: userCtrl,
              style: TuneFonts.body,
              decoration: InputDecoration(
                labelText: l.smbUser,
                border: OutlineInputBorder(),
                filled: true,
                fillColor: TuneColors.background,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passCtrl,
              obscureText: true,
              style: TuneFonts.body,
              decoration: InputDecoration(
                labelText: l.smbPassword,
                border: OutlineInputBorder(),
                filled: true,
                fillColor: TuneColors.background,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.btnCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.cfgSmbMount),
          ),
        ],
      ),
    );

    if (result != true) return;

    try {
      final host = share['host'] ?? share['ip'] ?? share['address'] ?? '';
      final shareName = share['name'] ?? share['share_name'] ?? '';

      await api.mountSMBShare({
        'host': host,
        'share': shareName,
        'username': userCtrl.text.trim(),
        'password': passCtrl.text,
      });

      // Also save credentials
      await api.saveSMBCredentials({
        'host': host,
        'share': shareName,
        'username': userCtrl.text.trim(),
        'password': passCtrl.text,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.cfgSmbMountSuccess('$shareName')),
            backgroundColor: TuneColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(l.errorWith(e.toString())),
              backgroundColor: TuneColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(l.cfgSmbTitle, style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: TuneColors.textSecondary),
            onPressed: _discover,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final l = AppLocalizations.of(context);
    if (_loading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: TuneColors.accent),
            const SizedBox(height: 16),
            Text(
              l.cfgSmbSearching,
              style: TuneFonts.subheadline.copyWith(color: TuneColors.textSecondary),
            ),
          ],
        ),
      );
    }

    if (_error != null || _notConnected) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48, color: TuneColors.error),
              const SizedBox(height: 12),
              Text(_notConnected ? l.cfgSmbNotConnected : _error!,
                  style: TuneFonts.footnote, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _discover,
                style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
                child: Text(l.btnRetry),
              ),
            ],
          ),
        ),
      );
    }

    if (_shares.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.folder_off_rounded, size: 56, color: TuneColors.textTertiary),
            const SizedBox(height: 12),
            Text(l.cfgSmbNone, style: TuneFonts.subheadline),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _discover,
              icon: const Icon(Icons.radar_rounded, size: 18),
              label: Text(l.sourcesRescanBtn),
              style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _discover,
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: _shares.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, indent: 56, color: TuneColors.divider),
        itemBuilder: (_, i) {
          final share = _shares[i];
          final name = share['name'] ?? share['share_name'] ?? l.cfgUnknown;
          final host = share['host'] ?? share['ip'] ?? share['address'] ?? '';
          final type = share['type'] ?? '';

          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: TuneColors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.folder_shared_rounded,
                  color: TuneColors.accent, size: 22),
            ),
            title: Text(name.toString(), style: TuneFonts.body),
            subtitle: Text(
              '${host.toString()}${type.toString().isNotEmpty ? " ($type)" : ""}',
              style: TuneFonts.caption,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.save_rounded, color: TuneColors.accent, size: 20),
                  tooltip: l.cfgSmbSaveCredentials,
                  onPressed: () => _mountShare(share),
                ),
                IconButton(
                  icon: const Icon(Icons.link_rounded, color: TuneColors.success, size: 20),
                  tooltip: l.cfgSmbMount,
                  onPressed: () => _mountShare(share),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
