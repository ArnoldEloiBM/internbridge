import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

mixin ShellTabMixin<T extends StatefulWidget> on State<T> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<AppProvider>().addListener(_onTabRequest);
  }

  @override
  void dispose() {
    context.read<AppProvider>().removeListener(_onTabRequest);
    super.dispose();
  }

  void _onTabRequest() {
    final tab = context.read<AppProvider>().requestedTab;
    if (tab != null && tab != currentIndex) {
      setState(() => currentIndex = tab);
      context.read<AppProvider>().clearTabRequest();
    }
  }
}
