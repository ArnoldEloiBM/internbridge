import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';

Future<void> showPostInternshipDialog(BuildContext context) async {
  final titleCtrl = TextEditingController();
  final locationCtrl = TextEditingController(text: 'Remote');
  final salaryCtrl = TextEditingController(text: 'Stipend TBD');
  final skillsCtrl = TextEditingController(text: 'Flutter, Teamwork');
  String workType = 'Remote';

  final posted = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Post New Internship'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Role title'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: locationCtrl,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: workType,
              decoration: const InputDecoration(labelText: 'Work type'),
              items: ['Remote', 'Hybrid', 'On-site']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => workType = v ?? 'Remote',
            ),
            const SizedBox(height: 8),
            TextField(
              controller: salaryCtrl,
              decoration: const InputDecoration(labelText: 'Stipend / salary'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: skillsCtrl,
              decoration: const InputDecoration(
                labelText: 'Skills (comma separated)',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Publish')),
      ],
    ),
  );

  if (posted != true || !context.mounted) return;
  if (titleCtrl.text.trim().isEmpty) return;

  try {
    await context.read<AppProvider>().createPosting(
          title: titleCtrl.text.trim(),
          location: locationCtrl.text.trim(),
          type: workType,
          salary: salaryCtrl.text.trim(),
          skills: skillsCtrl.text
              .split(',')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList(),
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Internship posted successfully.')),
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

Future<void> showEditProfileDialog(BuildContext context) async {
  final app = context.read<AppProvider>();
  final user = app.user;
  if (user == null) return;

  final nameCtrl = TextEditingController(text: user.name);
  final bioCtrl = TextEditingController(text: user.bio);
  final locationCtrl = TextEditingController(text: user.location);
  final startupCtrl = TextEditingController(text: user.startupName ?? '');
  final currentPassCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();

  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Full name'),
            ),
            if (user.role == UserRole.founder) ...[
              const SizedBox(height: 8),
              TextField(
                controller: startupCtrl,
                decoration: const InputDecoration(labelText: 'Startup name'),
              ),
            ],
            const SizedBox(height: 8),
            TextField(
              controller: bioCtrl,
              decoration: const InputDecoration(labelText: 'Bio / headline'),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: locationCtrl,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const Divider(height: 24),
            Text('Change password',
                style: Theme.of(ctx).textTheme.titleSmall),
            const SizedBox(height: 8),
            TextField(
              controller: currentPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current password'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: newPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New password'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            try {
              await app.updateProfile(
                name: nameCtrl.text.trim(),
                bio: bioCtrl.text.trim(),
                location: locationCtrl.text.trim(),
                startupName: user.role == UserRole.founder
                    ? startupCtrl.text.trim()
                    : null,
              );
              if (currentPassCtrl.text.isNotEmpty && newPassCtrl.text.isNotEmpty) {
                await app.updatePassword(currentPassCtrl.text, newPassCtrl.text);
              }
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated.')),
                );
              }
            } catch (e) {
              if (ctx.mounted) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

Future<void> showSkillRatingDialog(BuildContext context, String skill) async {
  final app = context.read<AppProvider>();
  final current = app.user?.skillRatings[skill] ?? 70;
  var rating = current.toDouble();

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setLocal) => AlertDialog(
        title: Text('Rate: $skill'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${rating.round()}%',
                style: Theme.of(ctx).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    )),
            Slider(
              value: rating,
              min: 0,
              max: 100,
              divisions: 20,
              label: '${rating.round()}%',
              onChanged: (v) => setLocal(() => rating = v),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await app.setSkillRating(skill, rating.round());
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
}
