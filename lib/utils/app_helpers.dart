import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';

Future<void> applyForJob(BuildContext context, JobPosting job) async {
  final app = context.read<AppProvider>();
  try {
    await app.applyToJob(job);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Applied to ${job.title} at ${job.company}')),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }
}

String firstName(String fullName) {
  final parts = fullName.trim().split(' ');
  return parts.isEmpty ? 'there' : parts.first;
}
