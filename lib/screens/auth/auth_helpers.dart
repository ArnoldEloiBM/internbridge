import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../admin/admin_shell.dart';
import '../founder/founder_shell.dart';
import '../student/student_shell.dart';
import 'login_screen.dart';

/// Routes user to the right shell after login.
void navigateForUser(BuildContext context, AppUser? user) {
  if (user == null) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
    return;
  }

  Widget destination;
  switch (user.role) {
    case UserRole.admin:
      destination = const AdminShell();
      break;
    case UserRole.founder:
      destination = const FounderShell();
      break;
    case UserRole.student:
      destination = const StudentShell();
      break;
  }

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => destination),
  );
}

/// Login handler.
Future<void> handleLogin(BuildContext context, String email, String password) async {
  final app = context.read<AppProvider>();
  await app.signIn(email, password);

  var user = app.user;
  if (user == null) {
    throw StateError('Profile not found. Try registering again.');
  }

  if (context.mounted) navigateForUser(context, user);
}

Future<void> handleRegisterStudent(
  BuildContext context, {
  required String name,
  required String email,
  required String password,
}) async {
  final app = context.read<AppProvider>();
  await app.registerStudent(name: name, email: email, password: password);
  if (context.mounted) navigateForUser(context, app.user);
}

Future<void> handleRegisterFounder(
  BuildContext context, {
  required String name,
  required String startupName,
  required String email,
  required String password,
}) async {
  final app = context.read<AppProvider>();
  await app.registerFounder(
    name: name,
    startupName: startupName,
    email: email,
    password: password,
  );
  if (context.mounted) navigateForUser(context, app.user);
}

Future<void> handleSignOut(BuildContext context) async {
  await context.read<AppProvider>().signOut();
  if (context.mounted) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }
}
