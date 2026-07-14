import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/job_apply_button.dart';
import '../../widgets/profile_avatar.dart';
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
    final user = app.user;
    final ratings = user?.skillRatings ?? {};

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
        actions: const [ProfileAvatarButton()],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.outlineVariant),
        ),
      ),
      body: user == null
          ? const Center(child: Text('Sign in to view matches.'))
          : StreamBuilder<List<JobPosting>>(
              stream: app.db.watchOpportunities(skillRatings: ratings),
              builder: (context, jobSnap) {
                if (jobSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final jobs = _filterJobs(jobSnap.data ?? []);

                return StreamBuilder<Map<String, String>>(
                  stream: app.db.watchStudentAppliedMap(user.id),
                  builder: (context, appliedSnap) {
                    final applied = appliedSnap.data ?? {};

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
                              children: ['Skills Match', 'Remote', 'Verified Only']
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
                          else
                            ...jobs.map((job) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _MatchCard(
                                    job: job,
                                    applicationId: applied[job.id],
                                  ),
                                )),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final JobPosting job;
  final String? applicationId;

  const _MatchCard({required this.job, this.applicationId});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Row(
                      children: [
                        Flexible(
                          child: Text(job.company,
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ),
                        if (job.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified,
                              color: AppColors.primary, size: 14),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              MatchScoreRing(score: job.matchScore, size: 44),
            ],
          ),
          const SizedBox(height: 8),
          Text('${job.location} · ${job.type} · ${job.salary}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.onSurfaceVariant)),
          if (job.skills.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              children: job.skills.map((s) => SkillTag(label: s)).toList(),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Posted ${job.postedDate}',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: AppColors.outline)),
              JobApplyButton(job: job, applicationId: applicationId, compact: true),
            ],
          ),
        ],
      ),
    );
  }
}
