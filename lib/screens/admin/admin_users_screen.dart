import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/shared_widgets.dart';

enum _UserRole { student, founder }
enum _UserStatus { active, suspended }

class _User {
  final String name;
  final String email;
  final _UserRole role;
  _UserStatus status;

  _User({
    required this.name,
    required this.email,
    required this.role,
    this.status = _UserStatus.active,
  });
}

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final _searchCtrl = TextEditingController();
  String _roleFilter = 'All';

  final List<_User> _users = [
    _User(name: 'Jordan Mensah', email: 'jordan@alustudent.com', role: _UserRole.student),
    _User(name: 'Amara Okafor', email: 'amara@alustudent.com', role: _UserRole.student),
    _User(name: 'Sarah Mutoni', email: 'sarah@nexusflow.tech', role: _UserRole.founder),
    _User(name: 'Kwame Asante', email: 'kwame@alustudent.com', role: _UserRole.student),
    _User(name: 'David Okoro', email: 'david@nexusflow.tech', role: _UserRole.founder),
    _User(name: 'Jean Bahizi', email: 'jean@alustudent.com', role: _UserRole.student, status: _UserStatus.suspended),
  ];

  List<_User> get _filtered {
    var list = _users;
    if (_roleFilter == 'Students') list = list.where((u) => u.role == _UserRole.student).toList();
    if (_roleFilter == 'Founders') list = list.where((u) => u.role == _UserRole.founder).toList();
    final q = _searchCtrl.text.toLowerCase();
    if (q.isNotEmpty) list = list.where((u) => u.name.toLowerCase().contains(q) || u.email.toLowerCase().contains(q)).toList();
    return list;
  }

  void _toggleStatus(int i) {
    final user = _filtered[i];
    setState(() => user.status = user.status == _UserStatus.active ? _UserStatus.suspended : _UserStatus.active);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('User Management',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          Text('View, search, and manage all platform users.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 20),

          // Search + filter row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Search by name or email...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ...['All', 'Students', 'Founders'].map((f) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(f),
                      selected: _roleFilter == f,
                      onSelected: (_) => setState(() => _roleFilter = f),
                      selectedColor: AppColors.primaryContainer,
                      labelStyle: TextStyle(
                        color: _roleFilter == f ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: AppColors.surfaceContainerLowest,
                      side: const BorderSide(color: AppColors.outlineVariant),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 16),

          // Table
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: _H('User')),
                      Expanded(flex: 2, child: _H('Email')),
                      Expanded(child: _H('Role')),
                      Expanded(child: _H('Status')),
                      _H('Action'),
                    ],
                  ),
                ),
                if (_filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text('No users found.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.onSurfaceVariant)),
                    ),
                  )
                else
                  ..._filtered.asMap().entries.map((e) => _UserRow(
                        user: e.value,
                        onToggle: () => _toggleStatus(e.key),
                        showDivider: e.key < _filtered.length - 1,
                      )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _H extends StatelessWidget {
  final String text;
  const _H(this.text);

  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.onSurfaceVariant,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5));
}

class _UserRow extends StatelessWidget {
  final _User user;
  final VoidCallback onToggle;
  final bool showDivider;

  const _UserRow(
      {required this.user, required this.onToggle, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    final isActive = user.status == _UserStatus.active;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primaryFixed,
                      child: Text(user.name[0],
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 10),
                    Text(user.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(user.email,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.onSurfaceVariant)),
              ),
              Expanded(
                child: StatusChip(
                  label: user.role == _UserRole.student ? 'Student' : 'Founder',
                  backgroundColor: user.role == _UserRole.student
                      ? AppColors.primaryFixed
                      : const Color(0xFFD9E2FF),
                  textColor: AppColors.primary,
                ),
              ),
              Expanded(
                child: StatusChip(
                  label: isActive ? 'Active' : 'Suspended',
                  backgroundColor: isActive
                      ? const Color(0xFFE6F4EA)
                      : const Color(0xFFFFDAD6),
                  textColor: isActive
                      ? const Color(0xFF1E7E34)
                      : AppColors.error,
                ),
              ),
              TextButton(
                onPressed: onToggle,
                style: TextButton.styleFrom(
                  foregroundColor: isActive ? AppColors.error : AppColors.primary,
                ),
                child: Text(isActive ? 'Suspend' : 'Restore',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, color: AppColors.outlineVariant),
      ],
    );
  }
}
