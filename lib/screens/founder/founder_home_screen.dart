import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../utils/app_helpers.dart';
import '../../utils/profile_dialogs.dart';
import '../../widgets/profile_avatar.dart';

class FounderHomeScreen extends StatelessWidget {
  const FounderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final user = app.user;
    final founderId = user?.id;
    final startup = user?.startupName ?? user?.name ?? 'Startup';
    final verified = user?.verificationStatus == VerificationStatus.approved;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () => app.requestTab(3),
            child: CircleAvatar(
              backgroundColor: AppColors.primaryContainer,
              child: Text(
                startup.isNotEmpty ? startup[0].toUpperCase() : 'S',
                style: const TextStyle(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'InternBridge',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
        ),
        actions: const [ProfileAvatarButton()],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.outlineVariant),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showPostInternshipDialog(context),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Post New'),
      ),
      body: founderId == null
          ? const Center(child: Text('Sign in as a founder.'))
          : StreamBuilder<List<JobPosting>>(
              stream: app.db.watchFounderOpportunities(founderId),
              builder: (context, postSnap) {
                final postings = postSnap.data ?? [];
                final activePosts = postings.where((p) => p.isActive).length;

                return StreamBuilder<List<Applicant>>(
                  stream: app.db.watchFounderApplicants(founderId),
                  builder: (context, appSnap) {
                    final applicants = appSnap.data ?? [];
                    final recent = applicants.take(3).toList();

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  startup,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                              if (verified) ...[
                                const SizedBox(width: 8),
                                const Icon(Icons.verified, color: AppColors.primary, size: 18),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Hi ${firstName(user?.name ?? 'Founder')}, here is your pipeline today.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  label: 'Open roles',
                                  value: '$activePosts',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _StatCard(
                                  label: 'Applicants',
                                  value: '${applicants.length}',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Recent applicants',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600)),
                              TextButton(
                                onPressed: () => app.requestTab(2),
                                child: const Text('View all'),
                              ),
                            ],
                          ),
                          if (recent.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'No applicants yet. Post an internship to get started.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.onSurfaceVariant),
                              ),
                            )
                          else
                            ...recent.map(
                              (a) => _ApplicantRow(
                                name: a.name,
                                role: a.jobApplied,
                                match: a.matchScore,
                                status: a.status,
                              ),
                            ),
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

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

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

class _ApplicantRow extends StatelessWidget {
  final String name;
  final String role;
  final int match;
  final String status;

  const _ApplicantRow({
    required this.name,
    required this.role,
    required this.match,
    required this.status,
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
            radius: 22,
            backgroundColor: AppColors.surfaceContainerHigh,
            child: Text(
              name.isNotEmpty ? name[0] : '?',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Text('$role · $status',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          Text('$match%',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  )),
        ],
      ),
    );
  }
}
