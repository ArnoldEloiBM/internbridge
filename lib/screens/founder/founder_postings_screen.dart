import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';

class FounderPostingsScreen extends StatefulWidget {
  const FounderPostingsScreen({super.key});

  @override
  State<FounderPostingsScreen> createState() => _FounderPostingsScreenState();
}

class _FounderPostingsScreenState extends State<FounderPostingsScreen> {
  Future<void> _showPostDialog() async {
    final titleCtrl = TextEditingController();
    final locationCtrl = TextEditingController(text: 'Remote');
    final salaryCtrl = TextEditingController(text: 'Stipend TBD');
    final skillsCtrl = TextEditingController(text: 'Flutter, Teamwork');
    String workType = 'Remote';

    final posted = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Post New Internship'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Role title'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: locationCtrl,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: workType,
                decoration: const InputDecoration(labelText: 'Work type'),
                items: ['Remote', 'Hybrid', 'On-site']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => workType = v ?? 'Remote',
              ),
              const SizedBox(height: 8),
              TextField(
                controller: salaryCtrl,
                decoration: const InputDecoration(labelText: 'Stipend / salary'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: skillsCtrl,
                decoration: const InputDecoration(
                  labelText: 'Skills (comma separated)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Publish')),
        ],
      ),
    );

    if (posted != true || !mounted) return;
    if (titleCtrl.text.trim().isEmpty) return;

    try {
      await context.read<AppProvider>().createPosting(
            title: titleCtrl.text.trim(),
            location: locationCtrl.text.trim(),
            type: workType,
            salary: salaryCtrl.text.trim(),
            skills: skillsCtrl.text
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Internship posted to Firestore.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final founderId = app.user?.id;

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
      body: founderId == null
          ? const Center(child: Text('Sign in as a founder to manage postings.'))
          : StreamBuilder<List<JobPosting>>(
              stream: app.db.watchFounderOpportunities(founderId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final postings = snapshot.data ?? [];
                final activeCount = postings.where((p) => p.isActive).length;
                final totalApplicants =
                    postings.fold<int>(0, (sum, p) => sum + p.applicantCount);

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Active Postings',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.w700)),
                              Text('Manage your internship listings.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: AppColors.onSurfaceVariant)),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: _showPostDialog,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Post New'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.outlineVariant),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('TOTAL APPLICATIONS',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                              color: AppColors.onSurfaceVariant,
                                              letterSpacing: 0.5)),
                                  Text('$totalApplicants',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ACTIVE',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                              color: AppColors.onPrimaryContainer
                                                  .withValues(alpha: 0.8),
                                              letterSpacing: 0.5)),
                                  Text('$activeCount',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                              color: AppColors.onPrimaryContainer,
                                              fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (postings.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Text(
                              'No postings yet. Tap Post New to create your first listing.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                            ),
                          ),
                        )
                      else
                        ...postings.map(
                          (job) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _PostingCard(
                              job: job,
                              onToggle: (val) =>
                                  app.db.toggleOpportunity(job.id, val),
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

class _PostingCard extends StatelessWidget {
  final JobPosting job;
  final ValueChanged<bool> onToggle;

  const _PostingCard({required this.job, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: job.isActive ? 1.0 : 0.6,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryFixed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.work_outline, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 12,
                    children: [
                      Text('Posted ${job.postedDate}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.onSurfaceVariant)),
                      Text('${job.applicantCount} Applicants',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.onSurfaceVariant)),
                      if (job.type.isNotEmpty)
                        Text(job.type,
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Switch(
                  value: job.isActive,
                  onChanged: onToggle,
                  activeThumbColor: AppColors.primaryContainer,
                ),
                Text(
                  job.isActive ? 'Active' : 'Closed',
                  style: TextStyle(
                      fontSize: 11,
                      color: job.isActive
                          ? AppColors.onSurface
                          : AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
