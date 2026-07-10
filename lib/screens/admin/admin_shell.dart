import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'admin_dashboard_screen.dart';
import 'admin_verification_screen.dart';
import 'admin_users_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;
  bool _sidebarOpen = false;

  final _navItems = const [
    _NavItem(icon: Icons.dashboard, label: 'Dashboard'),
    _NavItem(icon: Icons.verified_user, label: 'Startup Verification'),
    _NavItem(icon: Icons.fact_check, label: 'Internship Approval'),
    _NavItem(icon: Icons.group, label: 'User Management'),
    _NavItem(icon: Icons.assessment, label: 'Reports'),
    _NavItem(icon: Icons.analytics, label: 'Analytics'),
    _NavItem(icon: Icons.notifications, label: 'Notifications', badge: '15'),
    _NavItem(icon: Icons.history, label: 'Audit Logs'),
    _NavItem(icon: Icons.settings, label: 'Settings'),
  ];

  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0:
        return const AdminDashboardScreen();
      case 1:
        return const AdminVerificationScreen();
      case 3:
        return const AdminUsersScreen();
      default:
        return _ComingSoonScreen(label: _navItems[_selectedIndex].label);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // Top App Bar
          Container(
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.outlineVariant)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                if (!isWide)
                  IconButton(
                    icon: const Icon(Icons.menu, color: AppColors.primary),
                    onPressed: () => setState(() => _sidebarOpen = !_sidebarOpen),
                  ),
                const Icon(Icons.hub, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'InternBridge Admin',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Operations Lead',
                        style: Theme.of(context).textTheme.labelMedium),
                    Text('Super Admin',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: AppColors.outline)),
                  ],
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryContainer,
                  child: const Text('AL',
                      style: TextStyle(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Row(
                  children: [
                    // Sidebar (always visible on wide screens)
                    if (isWide) _Sidebar(items: _navItems, selected: _selectedIndex, onSelect: (i) => setState(() => _selectedIndex = i)),
                    // Main content
                    Expanded(child: _buildScreen()),
                  ],
                ),
                // Drawer overlay on mobile
                if (!isWide && _sidebarOpen) ...[
                  GestureDetector(
                    onTap: () => setState(() => _sidebarOpen = false),
                    child: Container(color: Colors.black38),
                  ),
                  _Sidebar(
                    items: _navItems,
                    selected: _selectedIndex,
                    onSelect: (i) => setState(() {
                      _selectedIndex = i;
                      _sidebarOpen = false;
                    }),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String? badge;
  const _NavItem({required this.icon, required this.label, this.badge});
}

class _Sidebar extends StatelessWidget {
  final List<_NavItem> items;
  final int selected;
  final ValueChanged<int> onSelect;

  const _Sidebar(
      {required this.items, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border(right: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Column(
        children: [
          // Profile section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('AL',
                        style: TextStyle(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Alex Lead',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text('V2.4.0 • Admin',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          // Nav links
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                ...items.asMap().entries.where((e) => e.key < 8).map((e) {
                  final isActive = e.key == selected;
                  return _SidebarTile(
                    item: e.value,
                    isActive: isActive,
                    onTap: () => onSelect(e.key),
                  );
                }),
                const Divider(color: AppColors.outlineVariant),
                _SidebarTile(
                  item: items[8],
                  isActive: selected == 8,
                  onTap: () => onSelect(8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarTile(
      {required this.item, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: isActive ? AppColors.primaryContainer : Colors.transparent,
      hoverColor: AppColors.surfaceContainerHigh,
      leading: Icon(item.icon,
          color: isActive ? AppColors.onPrimary : AppColors.onSurfaceVariant,
          size: 20),
      title: Text(
        item.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isActive ? AppColors.onPrimary : AppColors.onSurfaceVariant,
        ),
      ),
      trailing: item.badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(item.badge!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            )
          : null,
      onTap: onTap,
    );
  }
}

class _ComingSoonScreen extends StatelessWidget {
  final String label;
  const _ComingSoonScreen({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.construction, size: 64, color: AppColors.outlineVariant),
          const SizedBox(height: 16),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Coming soon',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
