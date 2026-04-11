import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import 'tune_colors.dart';

// ---------------------------------------------------------------------------
// T10.2 — ArtworkView
// Widget réutilisable pour afficher une pochette d'album.
// Sources acceptées : [bytes] > [url] HTTP/HTTPS > [filePath] local.
// Fallback : placeholder icône musicale si aucune source valide.
// ---------------------------------------------------------------------------

class ArtworkView extends StatelessWidget {
  final String? url;
  final String? filePath;
  final Uint8List? bytes;
  final double size;
  final double cornerRadius;
  final BoxFit fit;

  const ArtworkView({
    super.key,
    this.url,
    this.filePath,
    this.bytes,
    this.size = 56,
    this.cornerRadius = 6,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(cornerRadius),
      child: SizedBox.square(
        dimension: size,
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (bytes != null && bytes!.isNotEmpty) {
      return Image.memory(bytes!, fit: fit, errorBuilder: _fallback);
    }
    // URL explicite ou filePath qui est en fait une URL HTTP (UPnP covers)
    // In remote mode, resolve relative paths to API URLs
    String? resolvedPath = filePath;
    if (filePath != null && !filePath!.startsWith('http') && !filePath!.startsWith('/')) {
      try {
        final app = context.read<AppState>();
        if (app.isRemoteMode && app.apiClient != null) {
          resolvedPath = app.apiClient!.artworkUrl(filePath!);
        }
      } catch (_) {}
    }
    final httpUrl = url ??
        (resolvedPath != null && resolvedPath.startsWith('http') ? resolvedPath : null);
    if (httpUrl != null && httpUrl.startsWith('http')) {
      return Image.network(
        httpUrl,
        fit: fit,
        loadingBuilder: (_, child, progress) =>
            progress == null ? child : _placeholder(),
        errorBuilder: _fallback,
      );
    }
    if (filePath != null) {
      return Image.file(
        File(filePath!),
        fit: fit,
        errorBuilder: _fallback,
      );
    }
    return _placeholder();
  }

  Widget _fallback(BuildContext ctx, Object err, StackTrace? st) =>
      _placeholder();

  Widget _placeholder() => ColoredBox(
        color: TuneColors.surfaceVariant,
        child: Center(
          child: Icon(
            Icons.music_note_rounded,
            color: TuneColors.textTertiary,
            size: size * 0.45,
          ),
        ),
      );
}
