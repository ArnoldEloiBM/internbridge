import 'package:flutter/material.dart';
import '../../core/theme.dart';
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surfaceContainerHigh,
              child: const Icon(Icons.person,
                  size: 18, color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.outlineVariant),
        ),
      ),
      body: SingleChildScrollView(
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
              'Track your professional momentum across all active and historical opportunities.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            // Tabs
            Row(
              children: [
                _Tab(label: 'Active (3)', isActive: _tabIndex == 0,
                    onTap: () => setState(() => _tabIndex = 0)),
                const SizedBox(width: 24),
                _Tab(label: 'Past (12)', isActive: _tabIndex == 1,
                    onTap: () => setState(() => _tabIndex = 1)),
              ],
            ),
            const Divider(color: AppColors.outlineVariant),
            const SizedBox(height: 16),
            // Featured timeline card
            _TimelineApplicationCard(),
            const SizedBox(height: 16),
            Text('Other Active Applications',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.outline,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _AppCard(
              icon: Icons.storage,
              iconColor: AppColors.secondary,
              title: 'Backend Engineering Intern',
              company: 'Stripe',
              matchScore: 92,
              status: 'Applied',
            ),
            const SizedBox(height: 8),
            _AppCard(
              icon: Icons.language,
              iconColor: AppColors.tertiary,
              title: 'Growth Marketing Associate',
              company: 'Canva',
              matchScore: 88,
              status: 'Viewed',
            ),
            const SizedBox(height: 16),
            // Recent decision
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.outlineVariant,
                    style: BorderStyle.solid),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Decision',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: AppColors.onSurfaceVariant)),
                      StatusChip(
                        label: 'Accepted',
                        backgroundColor: const Color(0xFFE6F4EA),
                        textColor: const Color(0xFF1E7E34),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.outlineVariant),
                        ),
                        child: const Icon(Icons.rocket_launch,
                            color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Product Management Intern',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600)),
                            Text('SpaceX • Summer 2024',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: AppColors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        child: const Text('View Offer'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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

class _TimelineApplicationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: const Icon(Icons.business, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('UX Design Intern',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text('Atlassian • Applied 4 days ago',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ),
              StatusChip(
                label: 'Interview',
                backgroundColor: AppColors.tertiaryContainer,
                textColor: AppColors.onPrimaryContainer,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Timeline steps
          _TimelineStep(
              label: 'Applied',
              date: 'October 12, 2023',
              isDone: true,
              isActive: false),
          _TimelineStep(
              label: 'Viewed by Recruiter',
              date: 'October 14, 2023',
              isDone: true,
              isActive: false),
          _TimelineStep(
              label: 'Interview Scheduled',
              date: 'Tomorrow, 10:30 AM (PDT)',
              isDone: false,
              isActive: true,
              detail: 'Technical Screen with Design Lead'),
          _TimelineStep(
              label: 'Offer / Decision',
              date: 'Pending Interview',
              isDone: false,
              isActive: false,
              isPending: true),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String label;
  final String date;
  final bool isDone;
  final bool isActive;
  final bool isPending;
  final String? detail;

  const _TimelineStep({
    required this.label,
    required this.date,
    required this.isDone,
    required this.isActive,
    this.isPending = false,
    this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isPending ? 0.4 : 1.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isDone || isActive
                      ? AppColors.primary
                      : AppColors.outline,
                  shape: BoxShape.circle,
                  border: isActive
                      ? Border.all(color: AppColors.primary, width: 3)
                      : null,
                ),
              ),
              if (!isPending)
                Container(width: 2, height: 40, color: AppColors.outlineVariant),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: isActive
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(label,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(fontWeight: FontWeight.w600)),
                              const Icon(Icons.calendar_today,
                                  size: 14, color: AppColors.primary),
                            ],
                          ),
                          if (detail != null) ...[
                            const SizedBox(height: 4),
                            Text(detail!,
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.schedule,
                                  size: 12, color: AppColors.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Text(date,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                          color: AppColors.onSurfaceVariant)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8)),
                              child: const Text('Join Zoom Meeting',
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    color: isDone
                                        ? AppColors.primary
                                        : AppColors.onSurfaceVariant,
                                    fontWeight: FontWeight.w600)),
                        Text(date,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.onSurfaceVariant)),
                      ],
                    ),
            ),
          ),
        ],
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
