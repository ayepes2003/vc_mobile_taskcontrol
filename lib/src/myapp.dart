import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/providers/theme_provider.dart';
import 'package:vc_taskcontrol/src/settings/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Manual Time Task Control',
      themeAnimationDuration: Duration(milliseconds: 500),
      themeAnimationCurve: Curves.easeInOut,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode:
          themeProvider.currentTheme.brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
    );
  }
}
