import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../utils/app_helpers.dart';
import '../../widgets/shared_widgets.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final name = app.user?.name ?? 'Student';

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundColor: AppColors.surfaceContainerHigh,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          'InternBridge',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.outlineVariant),
        ),
      ),
      body: StreamBuilder<List<JobPosting>>(
        stream: app.db.watchOpportunities(studentSkills: app.user?.skills ?? []),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final jobs = snapshot.data ?? [];
          if (jobs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No opportunities yet. Check back soon — ALU startups are posting regularly.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ),
            );
          }

          final featured = jobs.first;
          final others = jobs.length > 1 ? jobs.sublist(1, jobs.length.clamp(1, 3)) : <JobPosting>[];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '👋 Welcome ${firstName(name)}',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ready to accelerate your professional momentum today?',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                StreamBuilder<List<Application>>(
                  stream: app.user == null
                      ? null
                      : app.db.watchStudentApplications(app.user!.id),
                  builder: (context, appSnap) {
                    final apps = appSnap.data ?? [];
                    return Row(
                      children: [
                        Expanded(child: _ApplicationsCard(applications: apps)),
                        const SizedBox(width: 12),
                        const Expanded(child: _BookmarksCard()),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Recommended For You',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                _FeaturedJobCard(job: featured),
                if (others.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (others.isNotEmpty)
                        Expanded(child: _SmallJobCard(job: others[0])),
                      if (others.length > 1) ...[
                        const SizedBox(width: 12),
                        Expanded(child: _SmallJobCard(job: others[1])),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ApplicationsCard extends StatelessWidget {
  final List<Application> applications;
  const _ApplicationsCard({required this.applications});

  @override
  Widget build(BuildContext context) {
    final pending = applications
        .where((a) => ['Applied', 'Viewed'].contains(a.status))
        .length;
    final accepted = applications.where((a) => a.status == 'Accepted').length;
    final rejected = applications.where((a) => a.status == 'Rejected').length;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Applications',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const Icon(Icons.assignment_turned_in, color: AppColors.primary, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatBadge(count: '$pending', label: 'Pending', color: const Color(0xFFFFEB3B)),
              _StatBadge(
                  count: '$accepted',
                  label: 'Accepted',
                  color: const Color(0xFF4CAF50),
                  textColor: Colors.white),
              _StatBadge(
                  count: '$rejected',
                  label: 'Rejected',
                  color: const Color(0xFFFF5630),
                  textColor: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String count;
  final String label;
  final Color color;
  final Color textColor;

  const _StatBadge({
    required this.count,
    required this.label,
    required this.color,
    this.textColor = const Color(0xFF191C1E),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(count,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 9, fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookmarksCard extends StatelessWidget {
  const _BookmarksCard();

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bookmarks',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  Text('Opportunities you\'re watching',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('—',
                      style: TextStyle(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Save roles from Matches to track them here.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedJobCard extends StatelessWidget {
  final JobPosting job;
  const _FeaturedJobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.code, color: AppColors.primary, size: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    Text(job.company,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.onSurfaceVariant)),
                    const SizedBox(width: 4),
                    if (job.isVerified)
                      const Icon(Icons.verified, color: AppColors.primary, size: 14),
                    const SizedBox(width: 2),
                    if (job.isVerified)
                      Text('ALU Verified',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => applyForJob(context, job),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Apply Now', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          MatchScoreRing(score: job.matchScore),
        ],
      ),
    );
  }
}

class _SmallJobCard extends StatelessWidget {
  final JobPosting job;
  const _SmallJobCard({required this.job});

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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.trending_up, color: AppColors.primary, size: 20),
              ),
              MatchScoreRing(score: job.matchScore, size: 40),
            ],
          ),
          const SizedBox(height: 8),
          Text(job.title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text(job.company,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.onSurfaceVariant)),
              const SizedBox(width: 2),
              if (job.isVerified)
                const Icon(Icons.verified, color: AppColors.primary, size: 12),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            children: job.skills
                .map((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(s,
                          style: const TextStyle(
                              fontSize: 9, color: AppColors.onSurfaceVariant)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => applyForJob(context, job),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Apply Now', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
