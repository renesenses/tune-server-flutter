import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../server/streaming/streaming_service.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'streaming_helpers.dart';
import 'streaming_service_detail_view.dart';

// ---------------------------------------------------------------------------
// T13.1 — StreamingView
// Liste des services de streaming (Qobuz, Tidal, YouTube) avec état
// d'authentification et boutons de connexion/déconnexion.
// Miroir de StreamingView.swift (iOS)
// ---------------------------------------------------------------------------

class StreamingView extends StatelessWidget {
  const StreamingView({super.key});

  @override
  Widget build(BuildContext context) {
    final services = context.watch<LibraryState>().streamingServices;
    // S'assure qu'on a les 3 services connus même si la liste est vide
    final serviceIds = ['qobuz', 'tidal', 'youtube'];
    final serviceMap = {for (final s in services) s.serviceId: s};

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Streaming', style: TuneFonts.title2),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: serviceIds.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final id = serviceIds[i];
          final status = serviceMap[id] ??
              StreamingServiceStatus(
                serviceId: id,
                enabled: false,
                authenticated: false,
              );
          return _ServiceCard(status: status);
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ServiceCard
// ---------------------------------------------------------------------------

class _ServiceCard extends StatelessWidget {
  final StreamingServiceStatus status;
  const _ServiceCard({required this.status});

  @override
  Widget build(BuildContext context) {
    final info = serviceInfo(status.serviceId);
    final app = context.read<AppState>();

    return Container(
      decoration: BoxDecoration(
        color: TuneColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: status.authenticated
              ? TuneColors.accent.withValues(alpha: 0.4)
              : TuneColors.divider,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: status.authenticated
            ? () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        StreamingServiceDetailView(status: status),
                  ),
                )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Row(
                children: [
                  // Icône service
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: info.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(info.icon, color: info.color, size: 26),
                  ),
                  const SizedBox(width: 14),
                  // Nom + statut
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(info.name, style: TuneFonts.title3),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: status.authenticated
                                    ? TuneColors.success
                                    : TuneColors.textTertiary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              status.authenticated
                                  ? (status.accountName ?? 'Connecté')
                                  : 'Non connecté',
                              style: TuneFonts.footnote,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Badge qualité
                  if (status.quality != null)
                    _QualityBadge(quality: status.quality!),
                ],
              ),

              // Message d'erreur
              if (status.errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  status.errorMessage!,
                  style: TuneFonts.footnote
                      .copyWith(color: TuneColors.error),
                ),
              ],

              const SizedBox(height: 14),

              // Boutons action
              Row(
                children: [
                  if (!status.authenticated) ...[
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.login_rounded, size: 18),
                        label: const Text('Se connecter'),
                        style: FilledButton.styleFrom(
                            backgroundColor: TuneColors.accent),
                        onPressed: () =>
                            _showAuthFlow(context, app, status.serviceId),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.explore_rounded, size: 18),
                        label: const Text('Parcourir'),
                        style: FilledButton.styleFrom(
                            backgroundColor: TuneColors.accent),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                StreamingServiceDetailView(status: status),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.logout_rounded,
                          size: 18, color: TuneColors.textSecondary),
                      label: const Text('Déconnecter',
                          style:
                              TextStyle(color: TuneColors.textSecondary)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: TuneColors.divider),
                      ),
                      onPressed: () => _confirmLogout(context, app, status),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAuthFlow(
      BuildContext context, AppState app, String serviceId) {
    if (serviceId == 'qobuz') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: TuneColors.surface,
        builder: (_) => QobuzAuthSheet(serviceId: serviceId),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: TuneColors.surface,
        builder: (_) => DeviceCodeAuthSheet(serviceId: serviceId),
      );
    }
  }

  Future<void> _confirmLogout(
      BuildContext context, AppState app, StreamingServiceStatus status) async {
    final info = serviceInfo(status.serviceId);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text('Déconnecter ${info.name}', style: TuneFonts.title3),
        content: Text(
          'Votre compte sera déconnecté.',
          style: TuneFonts.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler',
                style: TextStyle(color: TuneColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Déconnecter',
                style: TextStyle(color: TuneColors.error)),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      await app.logoutService(status.serviceId);
    }
  }
}

// ---------------------------------------------------------------------------
// T13.4 — QobuzAuthSheet (email / password)
// ---------------------------------------------------------------------------

class QobuzAuthSheet extends StatefulWidget {
  final String serviceId;
  const QobuzAuthSheet({super.key, required this.serviceId});

  @override
  State<QobuzAuthSheet> createState() => _QobuzAuthSheetState();
}

class _QobuzAuthSheetState extends State<QobuzAuthSheet> {
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20, 20, 20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: TuneColors.textTertiary,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.album_rounded,
                    color: Color(0xFF2563EB)),
              ),
              const SizedBox(width: 12),
              const Text('Connexion Qobuz', style: TuneFonts.title3),
            ],
          ),
          const SizedBox(height: 20),
          _AuthField(
            label: 'Email',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          _AuthField(
            label: 'Mot de passe',
            controller: _pwCtrl,
            obscureText: true,
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(_error!,
                style:
                    TuneFonts.footnote.copyWith(color: TuneColors.error)),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: TuneColors.accent),
              onPressed: _loading ? null : _login,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Se connecter'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    final email = _emailCtrl.text.trim();
    final pw = _pwCtrl.text;
    if (email.isEmpty || pw.isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await context
        .read<AppState>()
        .authenticateService(widget.serviceId, email, pw);

    if (!mounted) return;

    if (result is StreamingAuthSuccess) {
      Navigator.of(context).pop();
    } else if (result is StreamingAuthFailure) {
      setState(() {
        _loading = false;
        _error = result.message;
      });
    } else {
      setState(() => _loading = false);
    }
  }
}

// ---------------------------------------------------------------------------
// T13.4 — DeviceCodeAuthSheet (Tidal / YouTube)
// ---------------------------------------------------------------------------

class DeviceCodeAuthSheet extends StatefulWidget {
  final String serviceId;
  const DeviceCodeAuthSheet({super.key, required this.serviceId});

  @override
  State<DeviceCodeAuthSheet> createState() =>
      _DeviceCodeAuthSheetState();
}

enum _DeviceCodeStep { starting, waitingCode, polling, success, error }

class _DeviceCodeAuthSheetState extends State<DeviceCodeAuthSheet> {
  _DeviceCodeStep _step = _DeviceCodeStep.starting;
  StreamingDeviceCodeResult? _codeResult;
  String? _errorMsg;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _startFlow();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _startFlow() async {
    final app = context.read<AppState>();
    final result = await app.startDeviceCodeFlow(widget.serviceId);
    if (!mounted) return;

    if (result is StreamingDeviceCodeResult) {
      setState(() {
        _codeResult = result;
        _step = _DeviceCodeStep.waitingCode;
      });
    } else if (result is StreamingAuthFailure) {
      setState(() {
        _step = _DeviceCodeStep.error;
        _errorMsg = result.message;
      });
    }
  }

  void _startPolling() {
    final code = _codeResult;
    if (code == null) return;
    setState(() => _step = _DeviceCodeStep.polling);

    _pollTimer = Timer.periodic(
      Duration(seconds: code.intervalSeconds),
      (_) async {
        final app = context.read<AppState>();
        final result =
            await app.pollDeviceCodeFlow(widget.serviceId, code);
        if (!mounted) return;

        if (result is StreamingAuthSuccess) {
          _pollTimer?.cancel();
          setState(() => _step = _DeviceCodeStep.success);
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) Navigator.of(context).pop();
        } else if (result is StreamingAuthFailure) {
          // pending = continue polling; real error = stop
          final isPending = result.message.toLowerCase().contains('pending') ||
              result.message.toLowerCase().contains('authorization_pending');
          if (!isPending) {
            _pollTimer?.cancel();
            setState(() {
              _step = _DeviceCodeStep.error;
              _errorMsg = result.message;
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = serviceInfo(widget.serviceId);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: TuneColors.textTertiary,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: info.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(info.icon, color: info.color),
              ),
              const SizedBox(width: 12),
              Text('Connexion ${info.name}', style: TuneFonts.title3),
            ],
          ),
          const SizedBox(height: 24),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return switch (_step) {
      _DeviceCodeStep.starting => const SizedBox(
          height: 80,
          child:
              Center(child: CircularProgressIndicator(color: TuneColors.accent)),
        ),
      _DeviceCodeStep.waitingCode => _WaitingCodeBody(
          codeResult: _codeResult!,
          onContinue: _startPolling,
        ),
      _DeviceCodeStep.polling => _PollingBody(
          codeResult: _codeResult!,
        ),
      _DeviceCodeStep.success => const _SuccessBody(),
      _DeviceCodeStep.error => _ErrorBody(
          message: _errorMsg ?? 'Erreur inconnue',
          onRetry: () {
            setState(() => _step = _DeviceCodeStep.starting);
            _startFlow();
          },
        ),
    };
  }
}

class _WaitingCodeBody extends StatelessWidget {
  final StreamingDeviceCodeResult codeResult;
  final VoidCallback onContinue;
  const _WaitingCodeBody(
      {required this.codeResult, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TuneColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text('Code d\'autorisation',
                  style: TuneFonts.subheadline),
              const SizedBox(height: 8),
              Text(
                codeResult.userCode,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                  color: TuneColors.accent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Rendez-vous sur cette URL et entrez le code ci-dessus :',
          style: TuneFonts.subheadline,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            Clipboard.setData(
                ClipboardData(text: codeResult.verificationUrl));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('URL copiée dans le presse-papiers')),
            );
          },
          child: Text(
            codeResult.verificationUrl,
            style: TuneFonts.footnote.copyWith(
              color: TuneColors.accent,
              decoration: TextDecoration.underline,
              decorationColor: TuneColors.accent,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            icon: const Icon(Icons.check_rounded),
            label: const Text('J\'ai entré le code'),
            style: FilledButton.styleFrom(
                backgroundColor: TuneColors.accent),
            onPressed: onContinue,
          ),
        ),
      ],
    );
  }
}

class _PollingBody extends StatelessWidget {
  final StreamingDeviceCodeResult codeResult;
  const _PollingBody({required this.codeResult});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircularProgressIndicator(color: TuneColors.accent),
        const SizedBox(height: 16),
        const Text('En attente de la validation…',
            style: TuneFonts.subheadline),
        const SizedBox(height: 8),
        Text(
          'Code : ${codeResult.userCode}',
          style: TuneFonts.footnote,
        ),
      ],
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody();
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.check_circle_rounded,
            size: 56, color: TuneColors.success),
        SizedBox(height: 12),
        Text('Connecté !', style: TuneFonts.title3),
      ],
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBody({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.error_outline_rounded,
            size: 48, color: TuneColors.error),
        const SizedBox(height: 12),
        Text(message, style: TuneFonts.subheadline, textAlign: TextAlign.center),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: onRetry,
          style:
              FilledButton.styleFrom(backgroundColor: TuneColors.accent),
          child: const Text('Réessayer'),
        ),
      ],
    );
  }
}

class _QualityBadge extends StatelessWidget {
  final String quality;
  const _QualityBadge({required this.quality});

  @override
  Widget build(BuildContext context) {
    final isHiRes = quality == 'hi_res';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isHiRes
            ? TuneColors.accent.withValues(alpha: 0.15)
            : TuneColors.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isHiRes
            ? 'Hi-Res'
            : quality == 'lossless'
                ? 'Lossless'
                : quality == 'high'
                    ? 'High'
                    : quality,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isHiRes ? TuneColors.accentLight : TuneColors.textTertiary,
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  const _AuthField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
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
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
