import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/shared_widgets.dart';

class StudentApplicationsScreen extends StatefulWidget {
  const StudentApplicationsScreen({super.key});

  @override
  State<StudentApplicationsScreen> createState() =>
      _StudentApplicationsScreenState();
}

class _StudentApplicationsScreenState
    extends State<StudentApplicationsScreen> {
  int _tabIndex = 0;

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
                final active = apps
                    .where((a) =>
                        !['Accepted', 'Rejected'].contains(a.status))
                    .toList();
                final past = apps
                    .where((a) =>
                        ['Accepted', 'Rejected'].contains(a.status))
                    .toList();
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
                        'Track your applications across ALU startup opportunities.',
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            _tabIndex == 0
                                ? 'No active applications yet. Browse Matches to apply.'
                                : 'No past applications yet.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                        )
                      else
                        ...shown.map(
                          (app) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _AppCard(
                              icon: Icons.work_outline,
                              iconColor: AppColors.primary,
                              title: app.jobTitle,
                              company: app.company,
                              matchScore: app.matchScore,
                              status: app.status,
                            ),
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
  const _Tab(
      {required this.label, required this.isActive, required this.onTap});

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
  final IconData icon;
  final Color iconColor;
  final String title;
  final String company;
  final int matchScore;
  final String status;

  const _AppCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.company,
    required this.matchScore,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.onSurfaceVariant),
                    children: [
                      TextSpan(text: '$company • Matching Score: '),
                      TextSpan(
                        text: '$matchScore%',
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          StatusChip(
            label: status,
            backgroundColor: AppColors.surfaceContainerHigh,
            textColor: AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: AppColors.outline),
        ],
      ),
    );
  }
}
