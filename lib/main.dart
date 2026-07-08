import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const InternBridgeApp());
}

class InternBridgeApp extends StatelessWidget {
  const InternBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InternBridge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}
