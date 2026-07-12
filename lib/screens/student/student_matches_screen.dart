import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../utils/app_helpers.dart';
import '../../widgets/shared_widgets.dart';

class StudentMatchesScreen extends StatefulWidget {
  const StudentMatchesScreen({super.key});

  @override
  State<StudentMatchesScreen> createState() => _StudentMatchesScreenState();
}

class _StudentMatchesScreenState extends State<StudentMatchesScreen> {
  final _searchCtrl = TextEditingController();
  String _activeFilter = 'Skills Match';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<JobPosting> _filterJobs(List<JobPosting> jobs) {
    var result = jobs;
    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result
          .where((j) =>
              j.title.toLowerCase().contains(query) ||
              j.company.toLowerCase().contains(query))
          .toList();
    }
    switch (_activeFilter) {
      case 'Remote':
        result = result.where((j) => j.type == 'Remote').toList();
        break;
      case 'Verified Only':
        result = result.where((j) => j.isVerified).toList();
        break;
      case 'Skills Match':
        result = [...result]..sort((a, b) => b.matchScore.compareTo(a.matchScore));
        break;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hub, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('InternBridge',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surfaceContainerHigh,
              child: const Icon(Icons.person, size: 18, color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
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

          final allJobs = snapshot.data ?? [];
          final jobs = _filterJobs(allJobs);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Curated Matches',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Found ${jobs.length} internships tailored to your profile.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchCtrl,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Search by role or startup...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Skills Match', 'Startup', 'Remote', 'Verified Only']
                        .map((f) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(f),
                                selected: _activeFilter == f,
                                onSelected: (_) => setState(() => _activeFilter = f),
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: _activeFilter == f
                                      ? AppColors.onPrimary
                                      : AppColors.onSurfaceVariant,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                backgroundColor: AppColors.surface,
                                side: const BorderSide(color: AppColors.outlineVariant),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
                if (jobs.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'No matches for this filter yet.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
                    ),
                  )
                else ...[
                  _FeaturedMatchCard(job: jobs.first),
                  const SizedBox(height: 12),
                  ...jobs.skip(1).map((job) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _MatchCard(job: job),
                      )),
                ],
                const SizedBox(height: 12),
                _CareerSpotlightCard(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FeaturedMatchCard extends StatelessWidget {
  final JobPosting job;
  const _FeaturedMatchCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(Icons.business, size: 64, color: AppColors.outlineVariant),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified, color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        const Text('ALU Verified',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tech & AI',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                                color: AppColors.onSurfaceVariant,
                                letterSpacing: 1)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${job.matchScore}%',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.tertiaryContainer,
                                  fontWeight: FontWeight.bold,
                                )),
                        const Text('SKILL MATCH',
                            style: TextStyle(
                                fontSize: 9,
                                color: AppColors.outline,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(job.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Text(job.company,
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(
                  'Work directly with our engineering leads to build high-performance data visualizations for global enterprise clients.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.onSurfaceVariant),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: ['R', 'T', 'F'].map((l) {
                        return Container(
                          margin: const EdgeInsets.only(right: 4),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.surface, width: 2),
                          ),
                          child: Center(
                            child: Text(l,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      onPressed: () => applyForJob(context, job),
                      child: const Text('Apply Now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final JobPosting job;
  const _MatchCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: const Icon(Icons.analytics, color: AppColors.primary),
              ),
              StatusChip(
                label: '${job.matchScore}% Match',
                backgroundColor: job.matchScore >= 90
                    ? AppColors.primaryContainer.withOpacity(0.15)
                    : AppColors.surfaceContainerHigh,
                textColor: job.matchScore >= 90
                    ? AppColors.primaryContainer
                    : AppColors.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(job.title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          Text(job.company,
              style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 16, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(job.location,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.payments_outlined,
                  size: 16, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(job.salary,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
          if (job.skills.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              children: job.skills
                  .map((s) => SkillTag(label: s))
                  .toList(),
            ),
          ],
          const SizedBox(height: 12),
          const Divider(color: AppColors.outlineVariant),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Posted ${job.postedDate}',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: AppColors.outline)),
              TextButton(
                onPressed: () {},
                child: const Text('View Details'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CareerSpotlightCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inverseSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Career Spotlight',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primaryFixed,
                    letterSpacing: 1,
                  )),
          const SizedBox(height: 8),
          Text('Ready to go international?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  )),
          const SizedBox(height: 8),
          Text(
            'Check out our remote-first matches for students looking to gain global experience with EU-based startups.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryFixed,
                foregroundColor: AppColors.onSurface,
              ),
              child: const Text('Explore Global'),
            ),
          ),
        ],
      ),
    );
  }
}
