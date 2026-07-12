import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/shared_widgets.dart';
import '../auth/auth_helpers.dart';

class FounderProfileScreen extends StatelessWidget {
  const FounderProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppProvider>().user;
    final startup = user?.startupName ?? 'Your Startup';
    final isVerified =
        user?.verificationStatus == VerificationStatus.approved;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero banner
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 160,
                  color: AppColors.surfaceContainerHigh,
                  child: const Center(
                    child: Icon(Icons.business, size: 64, color: AppColors.outlineVariant),
                  ),
                ),
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.inverseSurface.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.outlineVariant),
                        ),
                        child: const Icon(Icons.rocket_launch,
                            color: AppColors.primary, size: 36),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(startup,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                if (isVerified) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryContainer,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.verified,
                                            size: 12,
                                            color: AppColors.onPrimaryContainer),
                                        const SizedBox(width: 4),
                                        Text('ALU Verified',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                    color: AppColors
                                                        .onPrimaryContainer)),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              'Pioneering Intelligent Supply Chain Automation',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Connect with Founder'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sidebar
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        _InfoCard(
                          title: 'Company Details',
                          children: [
                            _InfoRow(
                                icon: Icons.location_on_outlined,
                                label: 'Headquarters',
                                value: 'Kigali Innovation City, Rwanda'),
                            _InfoRow(
                                icon: Icons.language,
                                label: 'Website',
                                value: 'nexusflow.tech',
                                valueColor: AppColors.primary),
                            _InfoRow(
                                icon: Icons.mail_outline,
                                label: 'Direct Contact',
                                value: 'sarah.m@nexusflow.tech'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _SuccessesCard(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Main content
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        _AboutCard(),
                        const SizedBox(height: 12),
                        _TeamCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => handleSignOut(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _InfoCard({required this.title, required this.children});

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
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  const _InfoRow(
      {required this.icon,
      required this.label,
      required this.value,
      this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant)),
                Text(value,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: valueColor ?? AppColors.onSurface)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessesCard extends StatelessWidget {
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
          Text('Recent Successes',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          _TimelineItem(
            date: 'JAN 2024',
            title: 'Series A Funding Secured',
            description: 'Raised \$4.2M to expand AI logistics infrastructure.',
            isFirst: true,
          ),
          _TimelineItem(
            date: 'OCT 2023',
            title: 'ALU Talent Partnership',
            description: 'Successfully onboarded 15 ALU interns.',
            isFirst: false,
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String date;
  final String title;
  final String description;
  final bool isFirst;
  const _TimelineItem(
      {required this.date,
      required this.title,
      required this.description,
      required this.isFirst});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isFirst ? AppColors.primary : AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
            ),
            Container(width: 2, height: 60, color: AppColors.primaryContainer),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date,
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold)),
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
              Text(description,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }
}

class _AboutCard extends StatelessWidget {
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
          Text('About NexusFlow',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            'NexusFlow is transforming how businesses navigate complex logistics in emerging markets. Founded in 2021, our proprietary AI engine analyzes fragmented supply chain data to predict delays and optimize routing in real-time.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.onSurfaceVariant, height: 1.5),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: ['Artificial Intelligence', 'Logistics', 'SaaS', 'Emerging Markets']
                .map((t) => SkillTag(label: t))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Core Team',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
            TextButton(
              onPressed: () {},
              child: const Text('View All 12 Members',
                  style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...[
          _TeamMember(
              name: 'Sarah Mutoni',
              role: 'CEO & Co-Founder',
              badge: 'MIT Alumna',
              icon: Icons.school),
          _TeamMember(
              name: 'David Okoro',
              role: 'CTO',
              badge: 'Ex-Google Engineer',
              icon: Icons.code),
          _TeamMember(
              name: 'Grace Uwase',
              role: 'Head of Operations',
              badge: '10+ Years Experience',
              icon: Icons.settings_suggest),
          _TeamMember(
              name: 'Jean Bahizi',
              role: 'Machine Learning Intern',
              badge: 'ALU Senior',
              icon: Icons.workspace_premium),
        ].map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: m,
            )),
      ],
    );
  }
}

class _TeamMember extends StatelessWidget {
  final String name;
  final String role;
  final String badge;
  final IconData icon;
  const _TeamMember(
      {required this.name,
      required this.role,
      required this.badge,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.surfaceContainerHigh,
            child: Text(name[0],
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 18)),
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
                Text(role,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(icon, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(badge.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 0.5)),
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
