import 'package:flutter/material.dart';

import '../views/helpers/tune_colors.dart';

/// A reusable heart toggle for any track/album/artist row.
///
/// Self-contained: it shows an optimistic filled/outline heart, a spinner while
/// the toggle is in flight, and reverts on error. [onToggle] performs the actual
/// add/remove and returns the new favourite state (the authoritative value the
/// button settles on). This keeps every list row consistent without each one
/// re-implementing the local state + spinner dance.
class FavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final double size;

  /// Performs the toggle and returns the new favourite state.
  final Future<bool> Function() onToggle;

  const FavoriteButton({
    required this.isFavorite,
    required this.onToggle,
    this.size = 18,
    super.key,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool _fav = widget.isFavorite;
  bool _busy = false;

  @override
  void didUpdateWidget(FavoriteButton old) {
    super.didUpdateWidget(old);
    // Sync with the parent's value when it changes (e.g. list refreshed), unless
    // a toggle is currently in flight (don't clobber the optimistic state).
    if (!_busy && old.isFavorite != widget.isFavorite) {
      _fav = widget.isFavorite;
    }
  }

  Future<void> _tap() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _fav = !_fav; // optimistic
    });
    try {
      final next = await widget.onToggle();
      if (mounted) setState(() => _fav = next);
    } catch (_) {
      if (mounted) setState(() => _fav = !_fav); // revert
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _tap,
      child: SizedBox(
        width: widget.size + 12,
        height: widget.size + 12,
        child: Center(
          child: _busy
              ? SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  _fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  size: widget.size,
                  color: _fav ? TuneColors.error : TuneColors.textTertiary,
                ),
        ),
      ),
    );
  }
}
