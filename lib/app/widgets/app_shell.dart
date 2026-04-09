import 'package:flutter/material.dart';

import '../model/memory_tab.dart';
import '../../features/compose/compose_page.dart';
import '../../features/home/home_page.dart';
import '../../features/island/island_page.dart';
import '../../features/memories/memory_page.dart';
import 'app_backdrop.dart';
import 'bottom_tab_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;

  static const items = [
    MemoryTab(label: '沙滩', icon: Icons.beach_access_rounded),
    MemoryTab(label: '小岛', icon: Icons.landscape_rounded),
    MemoryTab(label: '宝箱', icon: Icons.auto_awesome_rounded),
    MemoryTab(label: '投放', icon: Icons.edit_rounded),
  ];

  static const pages = [
    HomePage(),
    IslandPage(),
    MemoryPage(),
    ComposePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            child: KeyedSubtree(
              key: ValueKey(currentIndex),
              child: pages[currentIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomTabBar(
        currentIndex: currentIndex,
        items: items,
        onTap: (next) => setState(() => currentIndex = next),
      ),
    );
  }
}
