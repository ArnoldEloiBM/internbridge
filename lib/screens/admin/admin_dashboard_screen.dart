import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/shared_widgets.dart';

/// Single-screen admin: view participants, verify startups, delete users.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _searchCtrl = TextEditingController();
  String _roleFilter = 'All';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<AppUser> _filtered(List<AppUser> users) {
    var list = users.where((u) => u.role != UserRole.admin).toList();
    if (_roleFilter == 'Students') {
      list = list.where((u) => u.role == UserRole.student).toList();
    } else if (_roleFilter == 'Founders') {
      list = list.where((u) => u.role == UserRole.founder).toList();
    }
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((u) {
        final startup = u.startupName?.toLowerCase() ?? '';
        return u.name.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q) ||
            startup.contains(q);
      }).toList();
    }
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<void> _confirmDelete(BuildContext context, AppUser user) async {
    final label = user.role == UserRole.founder
        ? (user.startupName ?? user.name)
        : user.name;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete participant?'),
        content: Text(
          'Remove "$label" and all their data? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;

    try {
      await context.read<AppProvider>().db.deleteUser(user.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label removed')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not delete: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return StreamBuilder<List<AppUser>>(
      stream: app.db.watchAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final all = snapshot.data ?? [];
        final participants =
            all.where((u) => u.role != UserRole.admin).toList();
        final students =
            participants.where((u) => u.role == UserRole.student).length;
        final founders =
            participants.where((u) => u.role == UserRole.founder).length;
        final pending = participants
            .where((u) =>
                u.role == UserRole.founder &&
                u.verificationStatus == VerificationStatus.pending)
            .length;
        final filtered = _filtered(all);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Participant Management',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Verify startups, remove accounts, and browse all participants.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _SummaryChip(
                    icon: Icons.groups,
                    label: 'Total',
                    value: '${participants.length}',
                  ),
                  _SummaryChip(
                    icon: Icons.school,
                    label: 'Students',
                    value: '$students',
                  ),
                  _SummaryChip(
                    icon: Icons.business,
                    label: 'Founders',
                    value: '$founders',
                  ),
                  if (pending > 0)
                    _SummaryChip(
                      icon: Icons.pending_actions,
                      label: 'Pending',
                      value: '$pending',
                      highlight: true,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchCtrl,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Search by name, email, or startup...',
                  prefixIcon: Icon(Icons.search),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Students', 'Founders'].map((f) {
                    final selected = _roleFilter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(f),
                        selected: selected,
                        onSelected: (_) => setState(() => _roleFilter = f),
                        selectedColor: AppColors.primaryContainer,
                        labelStyle: TextStyle(
                          color: selected
                              ? AppColors.onPrimary
                              : AppColors.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor: AppColors.surfaceContainerLowest,
                        side: const BorderSide(color: AppColors.outlineVariant),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              if (filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      participants.isEmpty
                          ? 'No participants yet.'
                          : 'No matches for this filter.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ),
                )
              else
                ...filtered.map(
                  (user) => _ParticipantCard(
                    user: user,
                    onVerify: user.role == UserRole.founder &&
                            user.verificationStatus !=
                                VerificationStatus.approved
                        ? () => app.db.updateVerification(
                              user.id,
                              VerificationStatus.approved,
                            )
                        : null,
                    onUnverify: user.role == UserRole.founder &&
                            user.verificationStatus ==
                                VerificationStatus.approved
                        ? () => app.db.updateVerification(
                              user.id,
                              VerificationStatus.pending,
                            )
                        : null,
                    onDelete: () => _confirmDelete(context, user),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: highlight
            ? const Color(0xFFFFF4E5)
            : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: highlight
              ? const Color(0xFFB76E00).withValues(alpha: 0.3)
              : AppColors.outlineVariant,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: highlight ? const Color(0xFFB76E00) : AppColors.primary,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: highlight
                          ? const Color(0xFFB76E00)
                          : AppColors.onSurface,
                    ),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ParticipantCard extends StatelessWidget {
  final AppUser user;
  final VoidCallback? onVerify;
  final VoidCallback? onUnverify;
  final VoidCallback onDelete;

  const _ParticipantCard({
    required this.user,
    required this.onVerify,
    required this.onUnverify,
    required this.onDelete,
  });

  String get _roleLabel =>
      user.role == UserRole.founder ? 'Founder' : 'Student';

  String get _verificationLabel {
    switch (user.verificationStatus) {
      case VerificationStatus.approved:
        return 'Verified';
      case VerificationStatus.declined:
        return 'Declined';
      default:
        return 'Pending';
    }
  }

  (Color, Color) get _verificationColors {
    switch (user.verificationStatus) {
      case VerificationStatus.approved:
        return (const Color(0xFFE6F4EA), const Color(0xFF1E7E34));
      case VerificationStatus.declined:
        return (const Color(0xFFFFDAD6), AppColors.error);
      default:
        return (const Color(0xFFFFF4E5), const Color(0xFFB76E00));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFounder = user.role == UserRole.founder;
    final displayName =
        isFounder ? (user.startupName ?? user.name) : user.name;
    final (statusBg, statusFg) = _verificationColors;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: isFounder
                    ? const Color(0xFFD9E2FF)
                    : AppColors.primaryFixed,
                child: Icon(
                  isFounder ? Icons.business : Icons.person,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (isFounder)
                      Text(
                        user.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    Text(
                      user.email,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              StatusChip(
                label: _roleLabel,
                backgroundColor: isFounder
                    ? const Color(0xFFD9E2FF)
                    : AppColors.primaryFixed,
                textColor: AppColors.primary,
              ),
            ],
          ),
          if (isFounder) ...[
            const SizedBox(height: 10),
            StatusChip(
              label: _verificationLabel,
              backgroundColor: statusBg,
              textColor: statusFg,
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (onVerify != null)
                OutlinedButton.icon(
                  onPressed: onVerify,
                  icon: const Icon(Icons.verified, size: 16),
                  label: const Text('Verify'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1E7E34),
                    side: const BorderSide(color: Color(0xFF1E7E34)),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              if (onUnverify != null)
                OutlinedButton.icon(
                  onPressed: onUnverify,
                  icon: const Icon(Icons.verified_outlined, size: 16),
                  label: const Text('Unverify'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFB76E00),
                    side: const BorderSide(color: Color(0xFFB76E00)),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Delete'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
