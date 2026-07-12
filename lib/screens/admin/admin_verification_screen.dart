import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/shared_widgets.dart';

class AdminVerificationScreen extends StatefulWidget {
  const AdminVerificationScreen({super.key});

  @override
  State<AdminVerificationScreen> createState() =>
      _AdminVerificationScreenState();
}

class _AdminVerificationScreenState extends State<AdminVerificationScreen> {
  String _filter = 'All';

  List<AppUser> _filtered(List<AppUser> founders) {
    if (_filter == 'Pending') {
      return founders
          .where((s) => s.verificationStatus == VerificationStatus.pending)
          .toList();
    }
    if (_filter == 'Approved') {
      return founders
          .where((s) => s.verificationStatus == VerificationStatus.approved)
          .toList();
    }
    if (_filter == 'Declined') {
      return founders
          .where((s) => s.verificationStatus == VerificationStatus.declined)
          .toList();
    }
    return founders;
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return StreamBuilder<List<AppUser>>(
      stream: app.db.watchAllFounders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final founders = snapshot.data ?? [];
        final filtered = _filtered(founders);
        final pending = founders
            .where((s) => s.verificationStatus == VerificationStatus.pending)
            .length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Startup Verification',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      Text(
                        'Review and approve startup accounts before they go live.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                  if (pending > 0)
                    StatusChip(
                      label: '$pending Pending',
                      backgroundColor: const Color(0xFFFFF4E5),
                      textColor: const Color(0xFFB76E00),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: ['All', 'Pending', 'Approved', 'Declined'].map((f) {
                  final isActive = _filter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(f),
                      selected: isActive,
                      onSelected: (_) => setState(() => _filter = f),
                      selectedColor: AppColors.primaryContainer,
                      labelStyle: TextStyle(
                        color: isActive
                            ? AppColors.onPrimary
                            : AppColors.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: AppColors.surfaceContainerLowest,
                      side: const BorderSide(color: AppColors.outlineVariant),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: const Row(
                        children: [
                          Expanded(flex: 3, child: _ColHeader('Startup')),
                          Expanded(flex: 2, child: _ColHeader('Founder')),
                          Expanded(flex: 2, child: _ColHeader('Submitted')),
                          Expanded(child: _ColHeader('Status')),
                          _ColHeader('Actions'),
                        ],
                      ),
                    ),
                    if (filtered.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(
                          child: Text(
                            founders.isEmpty
                                ? 'No founder accounts yet. They appear here after registration.'
                                : 'No startups in this category.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ),
                      )
                    else
                      ...filtered.asMap().entries.map(
                            (e) => _StartupRow(
                              founder: e.value,
                              onApprove: e.value.verificationStatus ==
                                      VerificationStatus.pending
                                  ? () => app.db.updateVerification(
                                        e.value.id,
                                        VerificationStatus.approved,
                                      )
                                  : null,
                              onDecline: e.value.verificationStatus ==
                                      VerificationStatus.pending
                                  ? () => app.db.updateVerification(
                                        e.value.id,
                                        VerificationStatus.declined,
                                      )
                                  : null,
                              showDivider: e.key < filtered.length - 1,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ColHeader extends StatelessWidget {
  final String text;
  const _ColHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5));
  }
}

class _StartupRow extends StatelessWidget {
  final AppUser founder;
  final VoidCallback? onApprove;
  final VoidCallback? onDecline;
  final bool showDivider;

  const _StartupRow({
    required this.founder,
    required this.onApprove,
    required this.onDecline,
    required this.showDivider,
  });

  Color get _statusBg {
    switch (founder.verificationStatus) {
      case VerificationStatus.approved:
        return const Color(0xFFE6F4EA);
      case VerificationStatus.declined:
        return const Color(0xFFFFDAD6);
      default:
        return const Color(0xFFFFF4E5);
    }
  }

  Color get _statusFg {
    switch (founder.verificationStatus) {
      case VerificationStatus.approved:
        return const Color(0xFF1E7E34);
      case VerificationStatus.declined:
        return AppColors.error;
      default:
        return const Color(0xFFB76E00);
    }
  }

  String get _statusLabel {
    switch (founder.verificationStatus) {
      case VerificationStatus.approved:
        return 'Approved';
      case VerificationStatus.declined:
        return 'Declined';
      default:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.business,
                          color: AppColors.onSurfaceVariant, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text(founder.startupName ?? 'Unnamed startup',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(founder.name,
                        style: Theme.of(context).textTheme.bodySmall),
                    Text(founder.email,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  _formatDate(founder.createdAt),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ),
              Expanded(
                child: StatusChip(
                  label: _statusLabel,
                  backgroundColor: _statusBg,
                  textColor: _statusFg,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    color: onDecline != null
                        ? AppColors.error
                        : AppColors.outlineVariant,
                    tooltip: 'Decline',
                    onPressed: onDecline,
                  ),
                  IconButton(
                    icon: const Icon(Icons.check, size: 18),
                    color: onApprove != null
                        ? AppColors.primary
                        : AppColors.outlineVariant,
                    tooltip: 'Approve',
                    onPressed: onApprove,
                  ),
                ],
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

String _formatDate(DateTime date) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
