import 'package:flutter/material.dart';
import '../../core/theme.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('System Overview',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  Text('Real-time metrics for InternBridge ecosystem performance.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: const Text('Past 30 Days'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.onSurface,
                      side: const BorderSide(color: AppColors.outlineVariant),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Export Data'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Primary stats grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: const [
              _StatCard(
                icon: Icons.school,
                iconBg: AppColors.primaryFixed,
                iconColor: AppColors.primary,
                label: 'Total Students',
                value: '1,240',
                badge: '+12%',
                badgeColor: Color(0xFF1E7E34),
                badgeBg: Color(0xFFE6F4EA),
              ),
              _StatCard(
                icon: Icons.corporate_fare,
                iconBg: Color(0xFFD9E2FF),
                iconColor: AppColors.tertiary,
                label: 'Total Startups',
                value: '83',
                badge: '+5.2%',
                badgeColor: Color(0xFF0052CC),
                badgeBg: Color(0xFFE3F2FD),
              ),
              _StatCard(
                icon: Icons.work,
                iconBg: Color(0xFFFFDAD2),
                iconColor: AppColors.secondary,
                label: 'Active Internships',
                value: '218',
                badge: '+8 New',
                badgeColor: Color(0xFFB76E00),
                badgeBg: Color(0xFFFFF4E5),
              ),
              _StatCard(
                icon: Icons.person_add,
                iconBg: AppColors.primary,
                iconColor: AppColors.onPrimary,
                label: 'New Today',
                value: '+42',
                badge: 'Live Now',
                badgeColor: AppColors.primary,
                badgeBg: Colors.transparent,
                highlight: true,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Secondary alert stats
          Row(
            children: [
              Expanded(
                child: _AlertStatCard(
                  icon: Icons.priority_high,
                  iconBg: const Color(0xFFFFDAD6),
                  iconColor: const Color(0xFF93000A),
                  value: '12',
                  label: 'Pending Verifications',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _AlertStatCard(
                  icon: Icons.report,
                  iconBg: AppColors.error,
                  iconColor: Colors.white,
                  value: '3',
                  label: 'Reported Users',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _AlertStatCard(
                  icon: Icons.description,
                  iconBg: const Color(0xFFB2C5FF),
                  iconColor: const Color(0xFF001848),
                  value: '2,950',
                  label: 'Total Applications',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Chart + Categories row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _ApplicationsChartCard()),
              const SizedBox(width: 16),
              Expanded(child: _CategoriesCard()),
            ],
          ),
          const SizedBox(height: 24),

          // Alerts + Verification Queue row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _RecentAlertsCard()),
              const SizedBox(width: 16),
              Expanded(child: _VerificationQueueCard()),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Stat Cards ──────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;
  final String badge;
  final Color badgeColor;
  final Color badgeBg;
  final bool highlight;

  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.badge,
    required this.badgeColor,
    required this.badgeBg,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.primary.withValues(alpha: 0.05)
            : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: iconBg, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              if (badgeBg != Colors.transparent)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(999)),
                  child: Text(badge,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: badgeColor)),
                )
              else
                Text(badge,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: badgeColor)),
            ],
          ),
          const Spacer(),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(
                      color: highlight
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant)),
          Text(value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: highlight ? AppColors.primary : AppColors.onSurface,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _AlertStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String value;
  final String label;

  const _AlertStatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: iconBg,
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text(label,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Chart Card ───────────────────────────────────────────────────────────────

class _ApplicationsChartCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulated daily data points (normalized 0–1)
    const points = [0.8, 0.4, 0.6, 0.3, 0.7, 0.5, 0.9, 0.4, 0.6, 0.8,
                    0.5, 0.7, 0.3, 0.6, 0.8, 0.4, 0.9, 0.6, 0.5, 0.7,
                    0.3, 0.8, 0.6, 0.4, 0.9, 0.5, 0.7, 0.6, 0.8, 1.0];

    return Container(
      padding: const EdgeInsets.all(20),
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
              Text('Applications Over 30 Days',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const Icon(Icons.more_vert, color: AppColors.outline),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: points.map((h) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    height: 120 * h,
                    decoration: BoxDecoration(
                      color: h >= 0.8
                          ? AppColors.primary
                          : AppColors.primaryContainer
                              .withValues(alpha: 0.4 + h * 0.4),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(2)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Day 1', 'Day 10', 'Day 20', 'Day 30']
                .map((l) => Text(l,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: AppColors.outline)))
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _Legend(color: AppColors.primary, label: 'Direct Submissions'),
              const SizedBox(width: 16),
              _Legend(
                  color: AppColors.secondary.withValues(alpha: 0.5),
                  label: 'Referrals'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: AppColors.onSurfaceVariant)),
      ],
    );
  }
}

// ── Categories Donut Card ────────────────────────────────────────────────────

class _CategoriesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Categories',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(120, 120),
                    painter: _DonutPainter(),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('218',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w900)),
                      Text('Active',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color: AppColors.outline, letterSpacing: 1)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...[
            ('Tech', '45%', AppColors.primaryContainer),
            ('Marketing', '30%', AppColors.tertiaryContainer),
            ('Design', '25%', const Color(0xFFB1C6FF)),
          ].map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                                color: e.$3, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text(e.$1,
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    Text(e.$2,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 16.0;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Background
    paint.color = AppColors.outlineVariant;
    canvas.drawCircle(center, radius, paint);

    // Tech 45%
    paint.color = AppColors.primaryContainer;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -1.5708, 2 * 3.14159 * 0.45, false, paint);

    // Marketing 30%
    paint.color = AppColors.tertiaryContainer;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -1.5708 + 2 * 3.14159 * 0.45, 2 * 3.14159 * 0.30, false, paint);

    // Design 25%
    paint.color = const Color(0xFFB1C6FF);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -1.5708 + 2 * 3.14159 * 0.75, 2 * 3.14159 * 0.25, false, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Alerts Card ──────────────────────────────────────────────────────────────

class _RecentAlertsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
              Text('Recent Alerts',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 8),
          ..._alerts.map((a) => _AlertRow(alert: a)),
        ],
      ),
    );
  }
}

const _alerts = [
  _Alert(
    icon: Icons.warning,
    iconBg: Color(0xFFFF5630),
    iconColor: Colors.white,
    title: 'Urgent: Startup Verification',
    body: '"Nexus Innovations" has submitted legal documents for review.',
    time: '2m ago',
  ),
  _Alert(
    icon: Icons.flag,
    iconBg: Color(0xFFFFDAD6),
    iconColor: Color(0xFF93000A),
    title: 'User Reported',
    body: 'Suspicious activity reported on account @student_2921.',
    time: '45m ago',
  ),
  _Alert(
    icon: Icons.celebration,
    iconBg: Color(0xFF2356B5),
    iconColor: Colors.white,
    title: 'New Milestone',
    body: 'System reached 1,000 active internship matches this quarter.',
    time: '3h ago',
  ),
];

class _Alert {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String body;
  final String time;
  const _Alert(
      {required this.icon,
      required this.iconBg,
      required this.iconColor,
      required this.title,
      required this.body,
      required this.time});
}

class _AlertRow extends StatelessWidget {
  final _Alert alert;
  const _AlertRow({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: alert.iconBg,
            child: Icon(alert.icon, color: alert.iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(alert.title,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text(alert.time,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: AppColors.outline)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(alert.body,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Verification Queue Card ──────────────────────────────────────────────────

class _VerificationQueueCard extends StatefulWidget {
  @override
  State<_VerificationQueueCard> createState() => _VerificationQueueCardState();
}

class _VerificationQueueCardState extends State<_VerificationQueueCard> {
  final List<_PendingStartup> _queue = [
    _PendingStartup(name: 'CloudStream AI', submitted: 'Today, 09:12 AM'),
    _PendingStartup(name: 'GreenLeaf Logistics', submitted: 'Yesterday, 04:30 PM'),
    _PendingStartup(name: 'OrbitPay Fintech', submitted: 'Nov 24, 11:20 AM'),
  ];

  void _approve(int i) => setState(() => _queue.removeAt(i));
  void _decline(int i) => setState(() => _queue.removeAt(i));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
              Text('Verification Queue',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('${_queue.length} Pending',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_queue.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('All caught up!',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.onSurfaceVariant)),
              ),
            )
          else
            ..._queue.asMap().entries.map((e) => _QueueRow(
                  startup: e.value,
                  onApprove: () => _approve(e.key),
                  onDecline: () => _decline(e.key),
                  showDivider: e.key < _queue.length - 1,
                )),
        ],
      ),
    );
  }
}

class _PendingStartup {
  final String name;
  final String submitted;
  _PendingStartup({required this.name, required this.submitted});
}

class _QueueRow extends StatelessWidget {
  final _PendingStartup startup;
  final VoidCallback onApprove;
  final VoidCallback onDecline;
  final bool showDivider;

  const _QueueRow({
    required this.startup,
    required this.onApprove,
    required this.onDecline,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.business,
                    color: AppColors.onSurfaceVariant, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(startup.name,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text('Submitted: ${startup.submitted}',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: AppColors.outline)),
                  ],
                ),
              ),
              // Decline
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                color: AppColors.error,
                tooltip: 'Decline',
                onPressed: onDecline,
              ),
              // Approve
              IconButton(
                icon: const Icon(Icons.check, size: 20),
                color: AppColors.primary,
                tooltip: 'Approve',
                onPressed: onApprove,
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, color: AppColors.outlineVariant),
      ],
    );
  }
}
