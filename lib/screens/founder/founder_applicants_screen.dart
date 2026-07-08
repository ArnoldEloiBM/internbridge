import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/models.dart';
import '../../widgets/shared_widgets.dart';

const _applicants = [
  Applicant(
    id: '1',
    name: 'Amara Okafor',
    university: 'ALU (African Leadership University)',
    jobApplied: 'Product Design Intern',
    matchScore: 94,
    status: 'New',
    avatarUrl: '',
  ),
  Applicant(
    id: '2',
    name: 'Kwame Mensah',
    university: 'ALU (African Leadership University)',
    jobApplied: 'Software Engineer Intern',
    matchScore: 88,
    status: 'Shortlisted',
    avatarUrl: '',
  ),
  Applicant(
    id: '3',
    name: 'Sara Hassan',
    university: 'ALU (African Leadership University)',
    jobApplied: 'Marketing Associate',
    matchScore: 65,
    status: 'Interviewing',
    avatarUrl: '',
  ),
  Applicant(
    id: '4',
    name: 'Jean-Luc Bizimana',
    university: 'ALU (African Leadership University)',
    jobApplied: 'Product Design Intern',
    matchScore: 92,
    status: 'New',
    avatarUrl: '',
  ),
];

Color _statusBg(String status) {
  switch (status) {
    case 'New':
      return const Color(0xFFFFF4E5);
    case 'Shortlisted':
      return const Color(0xFFE3F2FD);
    case 'Interviewing':
      return const Color(0xFFE6FFFA);
    default:
      return AppColors.surfaceContainerHigh;
  }
}

Color _statusFg(String status) {
  switch (status) {
    case 'New':
      return const Color(0xFFB76E00);
    case 'Shortlisted':
      return const Color(0xFF0052CC);
    case 'Interviewing':
      return const Color(0xFF00695C);
    default:
      return AppColors.onSurfaceVariant;
  }
}

class FounderApplicantsScreen extends StatefulWidget {
  const FounderApplicantsScreen({super.key});

  @override
  State<FounderApplicantsScreen> createState() =>
      _FounderApplicantsScreenState();
}

class _FounderApplicantsScreenState extends State<FounderApplicantsScreen> {
  String _roleFilter = 'Job Title: All Roles';
  String _scoreFilter = 'Match Score: Highest First';

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Applicants',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('Review and manage talent across all your open internship positions.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 16),
            // Filters
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _roleFilter,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.filter_list, size: 18),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      'Job Title: All Roles',
                      'Product Design Intern',
                      'Software Engineer Intern',
                      'Marketing Associate',
                    ]
                        .map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(fontSize: 12))))
                        .toList(),
                    onChanged: (v) => setState(() => _roleFilter = v!),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _scoreFilter,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.insights, size: 18),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      'Match Score: Highest First',
                      '80% - 100% Match',
                      '50% - 79% Match',
                    ]
                        .map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(fontSize: 12))))
                        .toList(),
                    onChanged: (v) => setState(() => _scoreFilter = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10)),
                  child: const Text('Apply Filters'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => setState(() {
                    _roleFilter = 'Job Title: All Roles';
                    _scoreFilter = 'Match Score: Highest First';
                  }),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.onSurfaceVariant,
                      side: const BorderSide(color: AppColors.outlineVariant),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10)),
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Applicant cards grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: _applicants.length,
              itemBuilder: (_, i) => _ApplicantCard(applicant: _applicants[i]),
            ),
            const SizedBox(height: 16),
            // Recruitment momentum banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recruitment Momentum',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.onPrimaryContainer,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    'You have 12 active internship roles with over 140 applicants. The average match score across top-tier talent is 82%.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onPrimaryContainer.withValues(alpha: 0.9)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _MomentumStat(value: '142', label: 'Total Applicants'),
                      const SizedBox(width: 24),
                      _MomentumStat(value: '28', label: 'Interviews Set'),
                      const SizedBox(width: 24),
                      _MomentumStat(value: '14', label: 'Final Stage'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplicantCard extends StatelessWidget {
  final Applicant applicant;
  const _ApplicantCard({required this.applicant});

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
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primaryFixed,
                child: Text(
                  applicant.name[0],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 16),
                ),
              ),
              StatusChip(
                label: applicant.status,
                backgroundColor: _statusBg(applicant.status),
                textColor: _statusFg(applicant.status),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(applicant.name,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          Text(applicant.university,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariant, letterSpacing: 0.5),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Job Applied',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: AppColors.onSurfaceVariant)),
                      Text(applicant.jobApplied,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                MatchScoreRing(score: applicant.matchScore, size: 40),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: const TextStyle(fontSize: 11),
                  ),
                  child: const Text('View Profile'),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.more_vert,
                      size: 18, color: AppColors.onSurfaceVariant),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MomentumStat extends StatelessWidget {
  final String value;
  final String label;
  const _MomentumStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.onPrimaryContainer,
                fontWeight: FontWeight.bold)),
        Text(label.toUpperCase(),
            style: TextStyle(
                fontSize: 9,
                color: AppColors.onPrimaryContainer.withValues(alpha: 0.8),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5)),
      ],
    );
  }
}
