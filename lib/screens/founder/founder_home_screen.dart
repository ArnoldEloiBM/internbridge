import 'package:flutter/material.dart';
import '../../core/theme.dart';

class FounderHomeScreen extends StatelessWidget {
  const FounderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.rocket_launch,
                color: AppColors.onPrimary, size: 18),
          ),
        ),
        title: Text(
          'InternBridge',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            color: AppColors.onSurfaceVariant,
            onPressed: () {},
          ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Post New',
            style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Identity
            Row(
              children: [
                Text(
                  'Stellar Analytics',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                        color: AppColors.primaryContainer.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text('Verified',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Welcome back, Founder. Here is your talent pipeline today.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            // Overview cards
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.work_outline,
                    iconColor: AppColors.primary,
                    iconBg: AppColors.primaryContainer.withOpacity(0.1),
                    badge: 'Active',
                    badgeColor: AppColors.primary,
                    value: '3',
                    label: 'Open Positions',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.description_outlined,
                    iconColor: AppColors.secondary,
                    iconBg: AppColors.secondaryContainer.withOpacity(0.1),
                    badge: '+12%',
                    badgeColor: AppColors.secondary,
                    value: '24',
                    label: 'Applications',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.event_available,
                    iconColor: AppColors.tertiary,
                    iconBg: AppColors.tertiaryContainer.withOpacity(0.1),
                    badge: 'Upcoming',
                    badgeColor: AppColors.tertiary,
                    value: '4',
                    label: 'Interviews',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Analytics
            Text('Analytics',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _AnalyticRow(
                                label: 'Acceptance Rate',
                                value: '68%',
                                progress: 0.68,
                                color: AppColors.primary),
                            const SizedBox(height: 16),
                            _AnalyticRow(
                                label: 'Profile Views',
                                value: '1,240',
                                progress: 0.45,
                                color: AppColors.secondaryContainer),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Mini bar chart
                      SizedBox(
                        width: 100,
                        height: 80,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [0.3, 0.5, 0.4, 0.7, 0.9, 0.6, 0.85]
                              .map((h) => Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 1),
                                      height: 80 * h,
                                      decoration: BoxDecoration(
                                        color: h >= 0.8
                                            ? AppColors.primary
                                            : h >= 0.6
                                                ? AppColors.primaryContainer
                                                : AppColors.primaryContainer
                                                    .withOpacity(0.3),
                                        borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(2)),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Recent applicants
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Applicants',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._applicants.map((a) => _ApplicantRow(
                  name: a['name']!,
                  role: a['role']!,
                  match: int.parse(a['match']!),
                  time: a['time']!,
                  isVerified: a['verified'] == 'true',
                  matchColor: int.parse(a['match']!) >= 90
                      ? AppColors.primary
                      : AppColors.tertiary,
                )),
          ],
        ),
      ),
    );
  }
}

const _applicants = [
  {
    'name': 'Alex Chen',
    'role': 'Full-stack Developer • ALU',
    'match': '94',
    'time': 'Applied 2h ago',
    'verified': 'true',
  },
  {
    'name': 'Sarah Mensah',
    'role': 'Product Designer • Stanford',
    'match': '88',
    'time': 'Applied 5h ago',
    'verified': 'false',
  },
  {
    'name': "Liam O'Connell",
    'role': 'Backend Engineer • MIT',
    'match': '76',
    'time': 'Applied 1d ago',
    'verified': 'true',
  },
];

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String badge;
  final Color badgeColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.badge,
    required this.badgeColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: iconBg, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              Text(badge,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                      letterSpacing: 0.5)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _AnalyticRow extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final Color color;

  const _AnalyticRow(
      {required this.label,
      required this.value,
      required this.progress,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5)),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(
          width: 80,
          height: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surfaceContainer,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
      ],
    );
  }
}

class _ApplicantRow extends StatelessWidget {
  final String name;
  final String role;
  final int match;
  final String time;
  final bool isVerified;
  final Color matchColor;

  const _ApplicantRow({
    required this.name,
    required this.role,
    required this.match,
    required this.time,
    required this.isVerified,
    required this.matchColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.surfaceContainerHigh,
            child: Text(name[0],
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    if (isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified,
                          size: 14, color: AppColors.primary),
                    ],
                  ],
                ),
                Text(role,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text('$match%',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: matchColor, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 2),
                  Text('Match',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: matchColor)),
                ],
              ),
              Text(time,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: AppColors.outline)),
            ],
          ),
        ],
      ),
    );
  }
}
