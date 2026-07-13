import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/profile_avatar.dart';
import '../../widgets/shared_widgets.dart';

class StudentApplicationsScreen extends StatefulWidget {
  const StudentApplicationsScreen({super.key});

  @override
  State<StudentApplicationsScreen> createState() =>
      _StudentApplicationsScreenState();
}

class _StudentApplicationsScreenState extends State<StudentApplicationsScreen> {
  int _tabIndex = 0;

  bool _isPast(String status) {
    return ['Accepted', 'Rejected', 'Declined', 'Withdrawn'].contains(status);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final studentId = app.user?.id;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hub, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('InternBridge',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w800)),
          ],
        ),
        actions: const [ProfileAvatarButton()],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.outlineVariant),
        ),
      ),
      body: studentId == null
          ? const Center(child: Text('Sign in to view applications.'))
          : StreamBuilder<List<Application>>(
              stream: app.db.watchStudentApplications(studentId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final apps = snapshot.data ?? [];
                final active = apps.where((a) => !_isPast(a.status)).toList();
                final past = apps.where((a) => _isPast(a.status)).toList();
                final shown = _tabIndex == 0 ? active : past;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Applications',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(
                        'Updates from founders appear here in real time.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _Tab(
                              label: 'Active (${active.length})',
                              isActive: _tabIndex == 0,
                              onTap: () => setState(() => _tabIndex = 0)),
                          const SizedBox(width: 24),
                          _Tab(
                              label: 'Past (${past.length})',
                              isActive: _tabIndex == 1,
                              onTap: () => setState(() => _tabIndex = 1)),
                        ],
                      ),
                      const Divider(color: AppColors.outlineVariant),
                      const SizedBox(height: 16),
                      if (shown.isEmpty)
                        Text(
                          _tabIndex == 0
                              ? 'No active applications. Check Matches to apply.'
                              : 'Nothing in your history yet.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                        )
                      else
                        ...shown.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _AppCard(application: item),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _Tab({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
            decoration: isActive ? TextDecoration.underline : null,
            decorationColor: AppColors.primary,
            decorationThickness: 2,
          ),
        ),
      ),
    );
  }
}

class _AppCard extends StatelessWidget {
  final Application application;
  const _AppCard({required this.application});

  Color _statusColor(String status) {
    switch (status) {
      case 'Accepted':
        return const Color(0xFF4CAF50);
      case 'Rejected':
      case 'Declined':
        return const Color(0xFFFF5630);
      case 'Shortlisted':
        return AppColors.primary;
      case 'Withdrawn':
        return AppColors.outline;
      default:
        return AppColors.onSurfaceVariant;
    }
  }

  Future<void> _withdraw(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Withdraw?'),
        content: Text('Remove your application to ${application.jobTitle}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Withdraw')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await context.read<AppProvider>().withdrawApplication(application.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application withdrawn.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canWithdraw = ['Applied', 'Viewed', 'Shortlisted'].contains(application.status);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.work_outline, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(application.jobTitle,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text(
                      '${application.company} · ${application.matchScore}% match',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              StatusChip(
                label: application.status,
                backgroundColor: AppColors.surfaceContainerHigh,
                textColor: _statusColor(application.status),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Applied ${application.appliedDate}',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: AppColors.outline)),
              if (canWithdraw)
                TextButton(
                  onPressed: () => _withdraw(context),
                  child: const Text('Withdraw'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
