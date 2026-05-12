part of 'metadata_view.dart';

// Sub-widgets utilisés par MetadataView (tous privés à la library
// `metadata_view.dart` via `part of`) :
// - _SectionHeader : titre uppercase avec letterSpacing
// - _StatChip : chip stat (label + valeur)
// - _CompletenessCard : carte clickable de complétude (cover/genre/...)
// - _MetadataTag : badge orange « tag manquant »
// - _ActionButton : ElevatedButton.icon avec spinner loading

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        title.toUpperCase(),
        style: TuneFonts.footnote.copyWith(
          color: TuneColors.textTertiary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: TuneColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style:
                  TuneFonts.title3.copyWith(color: TuneColors.accent)),
          const SizedBox(height: 2),
          Text(label, style: TuneFonts.caption),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Completeness card — clickable, shows active state
// ---------------------------------------------------------------------------

class _CompletenessCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int missing;
  final int total;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  const _CompletenessCard({
    required this.icon,
    required this.label,
    required this.missing,
    required this.total,
    required this.color,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final complete = total > 0 ? (total - missing) / total : 1.0;
    final pct = (complete * 100).toStringAsFixed(0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 155,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: active
              ? color.withValues(alpha: 0.15)
              : TuneColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: active
              ? Border.all(color: color.withValues(alpha: 0.5), width: 1.5)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(label,
                      style: TuneFonts.callout
                          .copyWith(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '$missing / $total',
              style: TuneFonts.footnote
                  .copyWith(color: TuneColors.textSecondary),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: complete,
                minHeight: 6,
                color: color,
                backgroundColor: color.withValues(alpha: 0.15),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$pct% complet',
              style: TuneFonts.caption.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Metadata tag chip (for missing fields)
// ---------------------------------------------------------------------------

class _MetadataTag extends StatelessWidget {
  final String label;
  const _MetadataTag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: TuneColors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TuneFonts.caption.copyWith(
          color: TuneColors.warning,
          fontSize: 10,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Action button with loading spinner
// ---------------------------------------------------------------------------

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: TuneColors.surfaceVariant,
        foregroundColor: TuneColors.textPrimary,
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: loading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: TuneColors.accent,
              ),
            )
          : Icon(icon, size: 18, color: TuneColors.accent),
      label: Text(label, style: TuneFonts.footnote),
      onPressed: loading ? null : onPressed,
    );
  }
}
