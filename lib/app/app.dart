import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'widgets/app_shell.dart';

class MemoryLandApp extends StatelessWidget {
  const MemoryLandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memory Land',
      theme: buildAppTheme(),
      home: const AppShell(),
    );
  }
}
