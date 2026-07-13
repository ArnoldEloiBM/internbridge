import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../utils/app_helpers.dart';

class JobApplyButton extends StatelessWidget {
  final JobPosting job;
  final String? applicationId;
  final bool compact;

  const JobApplyButton({
    super.key,
    required this.job,
    this.applicationId,
    this.compact = false,
  });

  bool get _isApplied => applicationId != null;

  Future<void> _withdraw(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Withdraw application?'),
        content: Text('Remove your application to ${job.title} at ${job.company}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Withdraw')),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;
    try {
      await context.read<AppProvider>().withdrawApplication(applicationId!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application withdrawn.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isApplied) {
      return OutlinedButton(
        onPressed: () => _withdraw(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.onSurfaceVariant,
          side: const BorderSide(color: AppColors.outlineVariant),
          padding: compact
              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
              : null,
          minimumSize: compact ? Size.zero : null,
          tapTargetSize: compact ? MaterialTapTargetSize.shrinkWrap : null,
        ),
        child: Text(compact ? 'Withdraw' : 'Applied — Withdraw', style: const TextStyle(fontSize: 12)),
      );
    }

    return ElevatedButton(
      onPressed: () => applyForJob(context, job),
      style: ElevatedButton.styleFrom(
        padding: compact
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
            : null,
        minimumSize: compact ? Size.zero : null,
        tapTargetSize: compact ? MaterialTapTargetSize.shrinkWrap : null,
      ),
      child: Text(compact ? 'Apply Now' : 'Apply Now', style: const TextStyle(fontSize: 12)),
    );
  }
}
