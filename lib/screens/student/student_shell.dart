import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'student_home_screen.dart';
import 'student_matches_screen.dart';
import 'student_applications_screen.dart';
import 'student_profile_screen.dart';

class StudentShell extends StatefulWidget {
  const StudentShell({super.key});

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int _currentIndex = 0;

  final _screens = const [
    StudentHomeScreen(),
    StudentMatchesScreen(),
    StudentApplicationsScreen(),
    StudentProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.outlineVariant)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.onPrimaryContainer,
          unselectedItemColor: AppColors.onSurfaceVariant,
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: [
            _navItem(Icons.home, Icons.home, 'Home', 0),
            _navItem(Icons.handshake_outlined, Icons.handshake, 'Matches', 1),
            _navItem(Icons.description_outlined, Icons.description, 'Applications', 2),
            _navItem(Icons.person_outline, Icons.person, 'Profile', 3),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(
      IconData icon, IconData activeIcon, String label, int index) {
    final isActive = _currentIndex == index;
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
