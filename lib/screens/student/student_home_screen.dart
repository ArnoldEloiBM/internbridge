import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../utils/app_helpers.dart';
import '../../widgets/job_apply_button.dart';
import '../../widgets/profile_avatar.dart';
import '../../widgets/shared_widgets.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final user = app.user;
    final name = user?.name ?? 'Student';
    final ratings = user?.skillRatings ?? {};

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () => app.requestTab(3),
            child: CircleAvatar(
              backgroundColor: AppColors.surfaceContainerHigh,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
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
        actions: const [ProfileAvatarButton()],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.outlineVariant),
        ),
      ),
      body: StreamBuilder<List<JobPosting>>(
        stream: app.db.watchOpportunities(skillRatings: ratings),
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
                  'No opportunities yet. Check back soon.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ),
            );
          }

          final featured = jobs.first;
          final others =
              jobs.length > 1 ? jobs.sublist(1, jobs.length.clamp(1, 3)) : <JobPosting>[];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '👋 Welcome ${firstName(name)}',
                  overflow: TextOverflow.ellipsis,
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
                if (user != null)
                  StreamBuilder<List<Application>>(
                    stream: app.db.watchStudentApplications(user.id),
                    builder: (context, appSnap) {
                      return _ApplicationsCard(applications: appSnap.data ?? []);
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
                if (user != null)
                  StreamBuilder<Map<String, String>>(
                    stream: app.db.watchStudentAppliedMap(user.id),
                    builder: (context, appliedSnap) {
                      final applied = appliedSnap.data ?? {};
                      return Column(
                        children: [
                          _FeaturedJobCard(
                            job: featured,
                            applicationId: applied[featured.id],
                          ),
                          if (others.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _SmallJobCard(
                                    job: others[0],
                                    applicationId: applied[others[0].id],
                                  ),
                                ),
                                if (others.length > 1) ...[
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _SmallJobCard(
                                      job: others[1],
                                      applicationId: applied[others[1].id],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ],
                      );
                    },
                  ),
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
        .where((a) => ['Applied', 'Viewed', 'Shortlisted'].contains(a.status))
        .length;
    final accepted = applications.where((a) => a.status == 'Accepted').length;
    final rejected = applications
        .where((a) => ['Rejected', 'Declined', 'Withdrawn'].contains(a.status))
        .length;

    return Container(
      width: double.infinity,
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
            children: [
              Expanded(child: _StatBadge(count: '$pending', label: 'Pending', color: const Color(0xFFFFEB3B))),
              const SizedBox(width: 8),
              Expanded(
                  child: _StatBadge(
                      count: '$accepted',
                      label: 'Accepted',
                      color: const Color(0xFF4CAF50),
                      textColor: Colors.white)),
              const SizedBox(width: 8),
              Expanded(
                  child: _StatBadge(
                      count: '$rejected',
                      label: 'Rejected',
                      color: const Color(0xFFFF5630),
                      textColor: Colors.white)),
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          FittedBox(
            child: Text(count,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 2),
          FittedBox(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                label,
                style: TextStyle(
                    fontSize: 8, fontWeight: FontWeight.bold, color: textColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedJobCard extends StatelessWidget {
  final JobPosting job;
  final String? applicationId;
  const _FeaturedJobCard({required this.job, this.applicationId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.work_outline, color: AppColors.primary, size: 26),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job.title,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    Flexible(
                      child: Text(job.company,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.onSurfaceVariant)),
                    ),
                    if (job.isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified,
                          color: AppColors.primary, size: 14),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                JobApplyButton(job: job, applicationId: applicationId, compact: true),
              ],
            ),
          ),
          const SizedBox(width: 8),
          MatchScoreRing(score: job.matchScore),
        ],
      ),
    );
  }
}

class _SmallJobCard extends StatelessWidget {
  final JobPosting job;
  final String? applicationId;
  const _SmallJobCard({required this.job, this.applicationId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
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
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.trending_up, color: AppColors.primary, size: 17),
              ),
              MatchScoreRing(score: job.matchScore, size: 34),
            ],
          ),
          const SizedBox(height: 7),
          Text(job.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                child: Text(job.company,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.onSurfaceVariant)),
              ),
              if (job.isVerified)
                const Icon(Icons.verified, color: AppColors.primary, size: 14),
            ],
          ),
          const SizedBox(height: 7),
          SizedBox(
            width: double.infinity,
            child: JobApplyButton(job: job, applicationId: applicationId, compact: true),
          ),
        ],
      ),
    );
  }
}
