import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/auth_service.dart';
import '../../state/settings_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// LoginScreen — email/password login + register toggle
// Material Design 3, dark theme matching Tune design system.
// ---------------------------------------------------------------------------

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isRegisterMode = false;
  bool _loading = false;
  String? _error;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    final auth = context.read<AuthService>();
    final settings = context.read<SettingsState>();
    final baseUrl = settings.isRemoteMode
        ? 'http://${settings.remoteHost}:${settings.remotePort}'
        : 'http://localhost:${settings.serverPort}';

    try {
      if (_isRegisterMode) {
        await auth.register(
          baseUrl,
          _usernameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        await auth.login(
          baseUrl,
          _emailController.text.trim(),
          _passwordController.text,
        );
      }
      if (mounted) widget.onLoginSuccess();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openMozaiklabs() async {
    final url = Uri.parse('https://mozaiklabs.fr');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  const Icon(
                    Icons.wifi_tethering_rounded,
                    size: 56,
                    color: TuneColors.accent,
                  ),
                  const SizedBox(height: 16),
                  Text('Tune', style: TuneFonts.title1),
                  const SizedBox(height: 4),
                  Text(
                    _isRegisterMode ? 'Creer un compte' : 'Se connecter',
                    style: TuneFonts.subheadline,
                  ),
                  const SizedBox(height: 40),

                  // Error
                  if (_error != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: TuneColors.error.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: TuneColors.error.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded, color: TuneColors.error, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _error!,
                              style: TuneFonts.footnote.copyWith(color: TuneColors.error),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Username (register only)
                  if (_isRegisterMode) ...[
                    TextFormField(
                      controller: _usernameController,
                      style: TuneFonts.body,
                      decoration: _inputDecoration(
                        label: 'Nom d\'utilisateur',
                        icon: Icons.person_outline_rounded,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (_isRegisterMode && (v == null || v.trim().isEmpty)) {
                          return 'Nom d\'utilisateur requis';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Email
                  TextFormField(
                    controller: _emailController,
                    style: TuneFonts.body,
                    decoration: _inputDecoration(
                      label: 'Email',
                      icon: Icons.email_outlined,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Email requis';
                      if (!v.contains('@')) return 'Email invalide';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    style: TuneFonts.body,
                    decoration: _inputDecoration(
                      label: 'Mot de passe',
                      icon: Icons.lock_outline_rounded,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: TuneColors.textTertiary,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Mot de passe requis';
                      if (v.length < 4) return 'Minimum 4 caracteres';
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: _loading ? null : _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: TuneColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _isRegisterMode ? 'Creer un compte' : 'Se connecter',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Toggle register / login
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isRegisterMode = !_isRegisterMode;
                        _error = null;
                      });
                    },
                    child: Text(
                      _isRegisterMode
                          ? 'Deja un compte ? Se connecter'
                          : 'Pas de compte ? S\'inscrire',
                      style: TuneFonts.footnote.copyWith(color: TuneColors.accent),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // mozaiklabs.fr link
                  OutlinedButton.icon(
                    onPressed: _openMozaiklabs,
                    icon: const Icon(Icons.open_in_new_rounded, size: 16),
                    label: const Text('Connexion mozaiklabs.fr'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: TuneColors.textSecondary,
                      side: const BorderSide(color: TuneColors.divider),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(44),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TuneFonts.footnote,
      prefixIcon: Icon(icon, size: 20, color: TuneColors.textTertiary),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: TuneColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: TuneColors.accent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: TuneColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: TuneColors.error, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
