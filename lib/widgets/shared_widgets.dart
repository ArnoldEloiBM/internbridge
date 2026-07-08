import 'package:flutter/material.dart';
import '../core/theme.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final Widget? leading;

  const AppTopBar({super.key, this.actions, this.leading});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.hub, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            'InternBridge',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
      actions: actions,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.outlineVariant),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

class StatusChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const StatusChip({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class MatchScoreRing extends StatelessWidget {
  final int score;
  final double size;

  const MatchScoreRing({super.key, required this.score, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 4,
            backgroundColor: AppColors.outlineVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              score >= 90
                  ? const Color(0xFF00875A)
                  : score >= 70
                      ? AppColors.primary
                      : AppColors.secondary,
            ),
          ),
          Text(
            '$score%',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool fullWidth;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final btn = ElevatedButton(
      onPressed: onPressed,
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(icon, size: 18), const SizedBox(width: 8), Text(label)],
            )
          : Text(label),
    );
    return fullWidth ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}

class OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool fullWidth;

  const OutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final btn = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
      child: Text(label),
    );
    return fullWidth ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}

class SkillTag extends StatelessWidget {
  final String label;
  final bool highlighted;

  const SkillTag({super.key, required this.label, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.primaryContainer : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
        border: highlighted
            ? null
            : Border.all(color: AppColors.outlineVariant),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: highlighted ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
