import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/app_provider.dart';

/// Top-bar avatar showing the logged-in user's initial. Taps open Profile tab.
class ProfileAvatarButton extends StatelessWidget {
  final double radius;
  const ProfileAvatarButton({super.key, this.radius = 16});

  @override
  Widget build(BuildContext context) {
    final name = context.watch<AppProvider>().user?.name ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => context.read<AppProvider>().requestTab(3),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.surfaceContainerHigh,
          child: Text(
            initial,
            style: TextStyle(
              fontSize: radius * 0.9,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
