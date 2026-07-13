import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/profile_avatar.dart';
import '../../widgets/shared_widgets.dart';

Color _statusBg(String status) {
  switch (status) {
    case 'Shortlisted':
      return const Color(0xFFE3F2FD);
    case 'Accepted':
      return const Color(0xFFE6F4EA);
    case 'Rejected':
    case 'Declined':
      return const Color(0xFFFFDAD6);
    default:
      return const Color(0xFFFFF4E5);
  }
}

Color _statusFg(String status) {
  switch (status) {
    case 'Shortlisted':
      return const Color(0xFF0052CC);
    case 'Accepted':
      return const Color(0xFF1E7E34);
    case 'Rejected':
    case 'Declined':
      return AppColors.error;
    default:
      return const Color(0xFFB76E00);
  }
}

class FounderApplicantsScreen extends StatefulWidget {
  const FounderApplicantsScreen({super.key});

  @override
  State<FounderApplicantsScreen> createState() => _FounderApplicantsScreenState();
}

class _FounderApplicantsScreenState extends State<FounderApplicantsScreen> {
  String _roleFilter = 'All roles';
  String _scoreFilter = 'All scores';

  List<Applicant> _filter(List<Applicant> list) {
    var out = [...list];
    if (_roleFilter != 'All roles') {
      out = out.where((a) => a.jobApplied == _roleFilter).toList();
    }
    if (_scoreFilter == '80%+') {
      out = out.where((a) => a.matchScore >= 80).toList();
    } else if (_scoreFilter == '50–79%') {
      out = out.where((a) => a.matchScore >= 50 && a.matchScore < 80).toList();
    }
    out.sort((a, b) => b.matchScore.compareTo(a.matchScore));
    return out;
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
        actions: const [ProfileAvatarButton()],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.outlineVariant),
        ),
      ),
      body: founderId == null
          ? const Center(child: Text('Sign in as a founder.'))
          : StreamBuilder<List<Applicant>>(
              stream: app.db.watchFounderApplicants(founderId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final all = snapshot.data ?? [];
                final shown = _filter(all);
                final roles = {'All roles', ...all.map((a) => a.jobApplied)}.toList();

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text('Applicants',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('Review talent applying to your open roles.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.onSurfaceVariant)),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _roleFilter,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Role',
                        prefixIcon: Icon(Icons.filter_list, size: 18),
                      ),
                      items: roles
                          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                          .toList(),
                      onChanged: (v) => setState(() => _roleFilter = v!),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _scoreFilter,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Match score',
                        prefixIcon: Icon(Icons.insights, size: 18),
                      ),
                      items: ['All scores', '80%+', '50–79%']
                          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                          .toList(),
                      onChanged: (v) => setState(() => _scoreFilter = v!),
                    ),
                    const SizedBox(height: 16),
                    if (shown.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Text(
                          'No applicants yet.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                        ),
                      )
                    else
                      ...shown.map((a) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ApplicantCard(
                              applicant: a,
                              onUpdate: (status) =>
                                  app.db.updateApplicationStatus(a.id, status),
                            ),
                          )),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${all.length} applicants across your listings.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.onPrimaryContainer,
                            ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class _ApplicantCard extends StatelessWidget {
  final Applicant applicant;
  final ValueChanged<String> onUpdate;

  const _ApplicantCard({required this.applicant, required this.onUpdate});

  bool get _isShortlisted => applicant.status == 'Shortlisted';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primaryFixed,
                child: Text(
                  applicant.name.isNotEmpty ? applicant.name[0] : '?',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(applicant.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text(applicant.university,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            )),
                  ],
                ),
              ),
              StatusChip(
                label: applicant.status,
                backgroundColor: _statusBg(applicant.status),
                textColor: _statusFg(applicant.status),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  applicant.jobApplied,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              MatchScoreRing(score: applicant.matchScore, size: 40),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => onUpdate(_isShortlisted ? 'Applied' : 'Shortlisted'),
                child: Text(_isShortlisted ? 'Unshortlist' : 'Shortlist'),
              ),
              ElevatedButton(
                onPressed: () => onUpdate('Accepted'),
                child: const Text('Accept'),
              ),
              OutlinedButton(
                onPressed: () => onUpdate('Declined'),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                child: const Text('Decline'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
