import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../services/tune_api_client.dart';
import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// AIChatScreen — conversational AI assistant
// POST /api/v1/ai/query with message + zone_id, displays reply + actions.
// ---------------------------------------------------------------------------

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  final List<_ChatMessage> _messages = [];
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _sending = true;
    });
    _controller.clear();
    _scrollToBottom();

    final api = context.read<AppState>().apiClient;
    final auth = context.read<AuthService>();
    final zoneId = context.read<ZoneState>().currentZoneId;

    if (api == null) {
      setState(() {
        _messages.add(const _ChatMessage(
          text: 'Serveur non connecte. Verifiez la connexion.',
          isUser: false,
        ));
        _sending = false;
      });
      _scrollToBottom();
      return;
    }

    try {
      final response = await _postAIQuery(api, auth, text, zoneId);
      if (mounted) {
        setState(() {
          _messages.add(_ChatMessage(
            text: response.reply,
            isUser: false,
            actions: response.actions,
          ));
          _sending = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(_ChatMessage(
            text: 'Erreur: ${e.toString().replaceFirst("Exception: ", "")}',
            isUser: false,
          ));
          _sending = false;
        });
        _scrollToBottom();
      }
    }
  }

  Future<_AIResponse> _postAIQuery(
    TuneApiClient api,
    AuthService auth,
    String message,
    int? zoneId,
  ) async {
    final baseUrl = api.baseUrl;
    final uri = Uri.parse('$baseUrl/ai/query');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      ...auth.authHeaders,
    };

    final body = jsonEncode({
      'message': message,
      ?'zone_id': zoneId,
    });

    final resp = await http.post(uri, headers: headers, body: body)
        .timeout(const Duration(seconds: 60));

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception('AI query failed (${resp.statusCode})');
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;

    final reply = data['reply'] as String? ??
        data['response'] as String? ??
        data['message'] as String? ??
        'Pas de reponse';

    final actionsRaw = data['actions'] as List<dynamic>? ?? [];
    final actions = actionsRaw
        .map((a) {
          if (a is Map<String, dynamic>) {
            return _AIAction(
              label: a['label'] as String? ?? a['action'] as String? ?? '',
              action: a['action'] as String? ?? '',
            );
          }
          if (a is String) return _AIAction(label: a, action: a);
          return null;
        })
        .whereType<_AIAction>()
        .toList();

    return _AIResponse(reply: reply, actions: actions);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome_rounded, color: TuneColors.accent, size: 22),
            const SizedBox(width: 8),
            Text('Assistant IA', style: TuneFonts.title3),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? _EmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: _messages.length + (_sending ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == _messages.length && _sending) {
                        return const _TypingIndicator();
                      }
                      return _MessageBubble(message: _messages[i]);
                    },
                  ),
          ),

          // Input bar
          Container(
            color: TuneColors.surface,
            padding: EdgeInsets.fromLTRB(
              16,
              10,
              8,
              10 + MediaQuery.of(context).viewPadding.bottom,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: TuneFonts.body,
                    maxLines: 4,
                    minLines: 1,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: 'Posez une question...',
                      hintStyle: TuneFonts.footnote,
                      filled: true,
                      fillColor: TuneColors.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: _sending ? null : _send,
                  icon: Icon(
                    Icons.send_rounded,
                    color: _sending ? TuneColors.textTertiary : TuneColors.accent,
                  ),
                  tooltip: 'Envoyer',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data models
// ---------------------------------------------------------------------------

class _ChatMessage {
  final String text;
  final bool isUser;
  final List<_AIAction> actions;

  const _ChatMessage({
    required this.text,
    required this.isUser,
    this.actions = const [],
  });
}

class _AIAction {
  final String label;
  final String action;

  const _AIAction({required this.label, required this.action});
}

class _AIResponse {
  final String reply;
  final List<_AIAction> actions;

  const _AIResponse({required this.reply, this.actions = const []});
}

// ---------------------------------------------------------------------------
// UI components
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 48,
            color: TuneColors.accent.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Assistant IA Tune',
            style: TuneFonts.title3.copyWith(color: TuneColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Posez une question sur votre musique,\ndemandez des recommandations...',
            style: TuneFonts.footnote,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: TuneColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 16,
                color: TuneColors.accent,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? TuneColors.accent
                        : TuneColors.surfaceVariant,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                  ),
                  child: SelectableText(
                    message.text,
                    style: TuneFonts.body.copyWith(
                      color: isUser ? Colors.white : TuneColors.textPrimary,
                    ),
                  ),
                ),
                if (message.actions.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: message.actions.map((a) {
                      return ActionChip(
                        label: Text(
                          a.label,
                          style: TuneFonts.caption.copyWith(
                            color: TuneColors.accent,
                          ),
                        ),
                        backgroundColor: TuneColors.accent.withValues(alpha: 0.12),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Action: ${a.action}'),
                              backgroundColor: TuneColors.accent,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: TuneColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 16,
              color: TuneColors.accent,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: TuneColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const SizedBox(
              width: 24,
              height: 16,
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: TuneColors.accent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
