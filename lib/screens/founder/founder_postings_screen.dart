import 'package:flutter/material.dart';
import '../../core/theme.dart';

class FounderPostingsScreen extends StatefulWidget {
  const FounderPostingsScreen({super.key});

  @override
  State<FounderPostingsScreen> createState() => _FounderPostingsScreenState();
}

class _FounderPostingsScreenState extends State<FounderPostingsScreen> {
  final List<_Posting> _postings = [
    _Posting(
        icon: Icons.code,
        iconBg: AppColors.primaryFixed,
        iconColor: AppColors.primary,
        title: 'Software Engineer Intern',
        date: 'Oct 12, 2023',
        applicants: 42,
        type: 'Remote',
        isActive: true),
    _Posting(
        icon: Icons.campaign,
        iconBg: Color(0xFFFFDAD2),
        iconColor: AppColors.secondary,
        title: 'Marketing Assistant',
        date: 'Oct 05, 2023',
        applicants: 28,
        type: 'On-site',
        isActive: true),
    _Posting(
        icon: Icons.brush,
        iconBg: AppColors.surfaceContainer,
        iconColor: AppColors.outline,
        title: 'UI/UX Design Intern',
        date: 'Sept 20, 2023',
        applicants: 15,
        type: '',
        isActive: false),
  ];

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
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Post New'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Stats
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('TOTAL APPLICATIONS',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                        letterSpacing: 0.5)),
                            Text('148',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Container(
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
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
                                        .withOpacity(0.8),
                                    letterSpacing: 0.5)),
                        Text('12',
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
            // Posting cards
            ..._postings.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PostingCard(
                    posting: e.value,
                    onToggle: (val) => setState(
                        () => _postings[e.key] = e.value.copyWith(isActive: val)),
                  ),
                )),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text('View 12 More Archived Postings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Posting {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String date;
  final int applicants;
  final String type;
  final bool isActive;

  const _Posting({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.date,
    required this.applicants,
    required this.type,
    required this.isActive,
  });

  _Posting copyWith({bool? isActive}) => _Posting(
        icon: icon,
        iconBg: iconBg,
        iconColor: iconColor,
        title: title,
        date: date,
        applicants: applicants,
        type: type,
        isActive: isActive ?? this.isActive,
      );
}

class _PostingCard extends StatelessWidget {
  final _Posting posting;
  final ValueChanged<bool> onToggle;

  const _PostingCard({required this.posting, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: posting.isActive ? 1.0 : 0.6,
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
                color: posting.iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(posting.icon, color: posting.iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(posting.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 12,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 14, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text('Posted ${posting.date}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.group_outlined,
                              size: 14, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text('${posting.applicants} Applicants',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                      if (posting.type.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: posting.type == 'Remote'
                                ? AppColors.primaryFixed.withOpacity(0.3)
                                : AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: posting.type == 'Remote'
                                    ? AppColors.primary.withOpacity(0.3)
                                    : AppColors.outlineVariant),
                          ),
                          child: Text(posting.type,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: posting.type == 'Remote'
                                      ? AppColors.primary
                                      : AppColors.onSurfaceVariant,
                                  fontWeight: FontWeight.w600)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Switch(
                  value: posting.isActive,
                  onChanged: onToggle,
                  activeColor: AppColors.primaryContainer,
                ),
                Text(
                  posting.isActive ? 'Active' : 'Closed',
                  style: TextStyle(
                      fontSize: 11,
                      color: posting.isActive
                          ? AppColors.onSurface
                          : AppColors.onSurfaceVariant),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
