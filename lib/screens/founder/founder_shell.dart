import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../utils/shell_mixin.dart';
import 'founder_home_screen.dart';
import 'founder_postings_screen.dart';
import 'founder_applicants_screen.dart';
import 'founder_profile_screen.dart';

class FounderShell extends StatefulWidget {
  const FounderShell({super.key});

  @override
  State<FounderShell> createState() => _FounderShellState();
}

class _FounderShellState extends State<FounderShell> with ShellTabMixin {
  final _screens = const [
    FounderHomeScreen(),
    FounderPostingsScreen(),
    FounderApplicantsScreen(),
    FounderProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.outlineVariant)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) => setState(() => currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.onPrimaryContainer,
          unselectedItemColor: AppColors.onSurfaceVariant,
          selectedLabelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: [
            _navItem(Icons.home_outlined, Icons.home, 'Home', 0),
            _navItem(Icons.work_outline, Icons.work, 'Postings', 1),
            _navItem(Icons.group_outlined, Icons.group, 'Applicants', 2),
            _navItem(Icons.person_outline, Icons.person, 'Profile', 3),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(
      IconData icon, IconData activeIcon, String label, int index) {
    final isActive = currentIndex == index;
    return BottomNavigationBarItem(
      icon: Container(
        padding: isActive
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 4)
            : const EdgeInsets.all(4),
        decoration: isActive
            ? BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(999),
              )
            : null,
        child: Icon(isActive ? activeIcon : icon),
      ),
      label: label,
    );
  }
}
