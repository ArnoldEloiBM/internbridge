import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/models.dart';
import '../../widgets/shared_widgets.dart';

const _jobs = [
  JobPosting(
    id: '1',
    title: 'Software Developer',
    company: 'NexGen Systems',
    location: 'Remote',
    type: 'Remote',
    applicantCount: 42,
    isActive: true,
    matchScore: 90,
    skills: ['React', 'Node.js'],
    salary: '\$800/mo',
    postedDate: 'Oct 12, 2023',
    isVerified: true,
  ),
  JobPosting(
    id: '2',
    title: 'Marketing Assistant',
    company: 'GrowthHackers Co.',
    location: 'Lagos, Nigeria',
    type: 'Hybrid',
    applicantCount: 28,
    isActive: true,
    matchScore: 85,
    skills: ['Social Media', 'Content'],
    salary: '\$600/mo',
    postedDate: 'Oct 05, 2023',
    isVerified: true,
  ),
  JobPosting(
    id: '3',
    title: 'UI Designer',
    company: 'PixelPerfect Lab',
    location: 'Kigali, Rwanda',
    type: 'On-site',
    applicantCount: 15,
    isActive: true,
    matchScore: 70,
    skills: ['Figma', 'Design Ops'],
    salary: '\$700/mo',
    postedDate: 'Sept 20, 2023',
    isVerified: true,
  ),
];

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundColor: AppColors.surfaceContainerHigh,
            child: const Icon(Icons.person, color: AppColors.onSurfaceVariant, size: 20),
          ),
        ),
        title: Text(
          'InternBridge',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz, color: AppColors.primary),
            onPressed: () {},
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
            // Welcome
            Text(
              '👋 Welcome Arnold',
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
            // Stats row
            Row(
              children: [
                Expanded(child: _ApplicationsCard()),
                const SizedBox(width: 12),
                Expanded(child: _BookmarksCard()),
              ],
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
            // Featured job card
            _FeaturedJobCard(job: _jobs[0]),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _SmallJobCard(job: _jobs[1])),
                const SizedBox(width: 12),
                Expanded(child: _SmallJobCard(job: _jobs[2])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplicationsCard extends StatelessWidget {
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
              _StatBadge(count: '2', label: 'Pending', color: const Color(0xFFFFEB3B)),
              _StatBadge(count: '1', label: 'Accepted', color: const Color(0xFF4CAF50), textColor: Colors.white),
              _StatBadge(count: '1', label: 'Rejected', color: const Color(0xFFFF5630), textColor: Colors.white),
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
                  child: Text('8',
                      style: TextStyle(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: ['GT', 'MS', 'AP', '+5'].map((label) {
              return Container(
                margin: const EdgeInsets.only(right: 4),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(label,
                      style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurfaceVariant)),
                ),
              );
            }).toList(),
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Apply Now', style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                      ),
                      child: const Text('Details', style: TextStyle(fontSize: 12)),
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
              onPressed: () {},
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
