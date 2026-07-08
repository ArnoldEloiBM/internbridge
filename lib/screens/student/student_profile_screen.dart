import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/shared_widgets.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

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
            // Profile header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 44,
                            backgroundColor: AppColors.surfaceContainerHigh,
                            child: Text('J',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold)),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.verified,
                                  size: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Jordan Mensah',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.w700)),
                                const SizedBox(width: 8),
                                StatusChip(
                                  label: 'ALU Student',
                                  backgroundColor: AppColors.primaryContainer,
                                  textColor: AppColors.onPrimaryContainer,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('Software Engineering Undergrad & UI Enthusiast',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.onSurfaceVariant)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 14, color: AppColors.onSurfaceVariant),
                                const SizedBox(width: 4),
                                Text('Kigali, Rwanda',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                            color: AppColors.onSurfaceVariant,
                                            letterSpacing: 0.5)),
                                const SizedBox(width: 12),
                                const Icon(Icons.calendar_today_outlined,
                                    size: 14, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text('Available Summer 2024',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                            color: AppColors.primary,
                                            letterSpacing: 0.5)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Hire Jordan'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                          ),
                          child: const Text('Message'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      _SectionCard(
                        icon: Icons.school,
                        title: 'Education',
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.account_balance,
                                  color: AppColors.primary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('African Leadership University',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(fontWeight: FontWeight.bold)),
                                  Text('B.Sc. (Hons) in Software Engineering',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              color: AppColors.onSurfaceVariant)),
                                  Text('2021 — 2025 (Expected)',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(color: AppColors.outline)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SectionCard(
                        icon: Icons.psychology,
                        title: 'Skills',
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            const SkillTag(label: 'React.js'),
                            const SkillTag(label: 'Python'),
                            SkillTag(label: 'UI/UX Design', highlighted: true),
                            const SkillTag(label: 'Tailwind CSS'),
                            const SkillTag(label: 'Node.js'),
                            const SkillTag(label: 'Git/GitHub'),
                            const SkillTag(label: 'Project Management'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Right column
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      _SectionCard(
                        icon: Icons.link,
                        title: 'Portfolio',
                        child: Column(
                          children: [
                            _PortfolioLink(icon: Icons.code, label: 'GitHub'),
                            _PortfolioLink(icon: Icons.work_outline, label: 'LinkedIn'),
                            _PortfolioLink(
                                icon: Icons.language, label: 'Personal Portfolio'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Profile strength
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text('PROFILE STRENGTH',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                        color: Colors.white70,
                                        letterSpacing: 1)),
                            const SizedBox(height: 8),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white30, width: 4),
                              ),
                              child: Center(
                                child: Text('92%',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Excellent candidate for Junior Dev Roles',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Featured project
            Text('Featured Project',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(Icons.code, size: 64, color: AppColors.outlineVariant),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                        ),
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('AgriTech Analytics Dashboard',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                                Text(
                                  'A real-time monitoring tool for sustainable farming built with React and IoT sensors.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Icon(Icons.arrow_forward,
                                color: Colors.white, size: 18),
                          ),
                        ],
                      ),
                    ),
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

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  const _SectionCard(
      {required this.icon, required this.title, required this.child});

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
            children: [
              Icon(icon, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _PortfolioLink extends StatelessWidget {
  final IconData icon;
  final String label;
  const _PortfolioLink({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label,
                style: Theme.of(context).textTheme.bodySmall),
          ),
          const Icon(Icons.open_in_new, size: 14, color: AppColors.outline),
        ],
      ),
    );
  }
}
