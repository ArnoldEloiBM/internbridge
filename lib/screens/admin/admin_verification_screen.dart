import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/shared_widgets.dart';

enum _VerifStatus { pending, approved, declined }

class _Startup {
  final String name;
  final String founder;
  final String email;
  final String submitted;
  _VerifStatus status;

  _Startup({
    required this.name,
    required this.founder,
    required this.email,
    required this.submitted,
  this.status = _VerifStatus.pending,
  });
}

class AdminVerificationScreen extends StatefulWidget {
  const AdminVerificationScreen({super.key});

  @override
  State<AdminVerificationScreen> createState() =>
      _AdminVerificationScreenState();
}

class _AdminVerificationScreenState extends State<AdminVerificationScreen> {
  final List<_Startup> _startups = [
    _Startup(name: 'CloudStream AI', founder: 'James Osei', email: 'james@cloudstream.ai', submitted: 'Today, 09:12 AM'),
    _Startup(name: 'GreenLeaf Logistics', founder: 'Amina Diallo', email: 'amina@greenleaf.co', submitted: 'Yesterday, 04:30 PM'),
    _Startup(name: 'OrbitPay Fintech', founder: 'Kweku Asante', email: 'kweku@orbitpay.io', submitted: 'Nov 24, 11:20 AM'),
    _Startup(name: 'Nexus Innovations', founder: 'Sara Uwimana', email: 'sara@nexusinno.rw', submitted: 'Nov 23, 02:15 PM'),
    _Startup(name: 'DataBridge Labs', founder: 'Liam Nkosi', email: 'liam@databridge.co', submitted: 'Nov 22, 10:00 AM'),
  ];

  String _filter = 'All';

  List<_Startup> get _filtered {
    if (_filter == 'Pending') return _startups.where((s) => s.status == _VerifStatus.pending).toList();
    if (_filter == 'Approved') return _startups.where((s) => s.status == _VerifStatus.approved).toList();
    if (_filter == 'Declined') return _startups.where((s) => s.status == _VerifStatus.declined).toList();
    return _startups;
  }

  void _approve(int i) {
    final startup = _filtered[i];
    setState(() => startup.status = _VerifStatus.approved);
  }

  void _decline(int i) {
    final startup = _filtered[i];
    setState(() => startup.status = _VerifStatus.declined);
  }

  @override
  Widget build(BuildContext context) {
    final pending = _startups.where((s) => s.status == _VerifStatus.pending).length;

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
                  Text('Review and approve startup accounts before they go live.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.onSurfaceVariant)),
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

          // Filter tabs
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
                    color: isActive ? AppColors.onPrimary : AppColors.onSurfaceVariant,
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

          // Table
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: _ColHeader('Startup')),
                      Expanded(flex: 2, child: _ColHeader('Founder')),
                      Expanded(flex: 2, child: _ColHeader('Submitted')),
                      Expanded(child: _ColHeader('Status')),
                      _ColHeader('Actions'),
                    ],
                  ),
                ),
                // Rows
                if (_filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text('No startups in this category.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.onSurfaceVariant)),
                    ),
                  )
                else
                  ..._filtered.asMap().entries.map((e) => _StartupRow(
                        startup: e.value,
                        onApprove: e.value.status == _VerifStatus.pending
                            ? () => _approve(e.key)
                            : null,
                        onDecline: e.value.status == _VerifStatus.pending
                            ? () => _decline(e.key)
                            : null,
                        showDivider: e.key < _filtered.length - 1,
                      )),
              ],
            ),
          ),
        ],
      ),
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
  final _Startup startup;
  final VoidCallback? onApprove;
  final VoidCallback? onDecline;
  final bool showDivider;

  const _StartupRow({
    required this.startup,
    required this.onApprove,
    required this.onDecline,
    required this.showDivider,
  });

  Color get _statusBg {
    switch (startup.status) {
      case _VerifStatus.approved: return const Color(0xFFE6F4EA);
      case _VerifStatus.declined: return const Color(0xFFFFDAD6);
      default: return const Color(0xFFFFF4E5);
    }
  }

  Color get _statusFg {
    switch (startup.status) {
      case _VerifStatus.approved: return const Color(0xFF1E7E34);
      case _VerifStatus.declined: return AppColors.error;
      default: return const Color(0xFFB76E00);
    }
  }

  String get _statusLabel {
    switch (startup.status) {
      case _VerifStatus.approved: return 'Approved';
      case _VerifStatus.declined: return 'Declined';
      default: return 'Pending';
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
                    Text(startup.name,
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
                    Text(startup.founder,
                        style: Theme.of(context).textTheme.bodySmall),
                    Text(startup.email,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(startup.submitted,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.onSurfaceVariant)),
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
                    color: onDecline != null ? AppColors.error : AppColors.outlineVariant,
                    tooltip: 'Decline',
                    onPressed: onDecline,
                  ),
                  IconButton(
                    icon: const Icon(Icons.check, size: 18),
                    color: onApprove != null ? AppColors.primary : AppColors.outlineVariant,
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
