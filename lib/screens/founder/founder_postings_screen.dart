import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../utils/profile_dialogs.dart';

class FounderPostingsScreen extends StatefulWidget {
  const FounderPostingsScreen({super.key});

  @override
  State<FounderPostingsScreen> createState() => _FounderPostingsScreenState();
}

class _FounderPostingsScreenState extends State<FounderPostingsScreen> {
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
                        children: [
                          Expanded(
                            child: Column(
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
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () => showPostInternshipDialog(context),
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Post New'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                            ),
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
