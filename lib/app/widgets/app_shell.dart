import 'package:flutter/material.dart';

import '../../features/compose/compose_page.dart';
import '../../features/home/home_page.dart';
import '../../features/island/island_page.dart';
import '../../features/memories/memory_page.dart';
import '../model/memory_tab.dart';
import '../state/memory_land_store.dart';
import 'app_backdrop.dart';
import 'bottom_tab_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;
  final store = MemoryLandStore.seeded();
  String? composeSpotId;

  static const items = [
    MemoryTab(label: '海面', icon: Icons.public_rounded),
    MemoryTab(label: '岛屿', icon: Icons.landscape_rounded),
    MemoryTab(label: '回忆', icon: Icons.auto_stories_rounded),
    MemoryTab(label: '写下', icon: Icons.edit_rounded),
  ];

  void _openCompose([String? spotId]) {
    setState(() {
      composeSpotId = spotId;
      currentIndex = 3;
    });
  }

  List<Widget> get pages => [
        HomePage(
          store: store,
          onOpenCompose: _openCompose,
          onOpenIsland: () => setState(() => currentIndex = 1),
          onOpenMemories: () => setState(() => currentIndex = 2),
        ),
        IslandPage(
          store: store,
          onOpenCompose: _openCompose,
        ),
        MemoryPage(
          store: store,
          onOpenCompose: _openCompose,
        ),
        ComposePage(
          store: store,
          initialSpotId: composeSpotId,
          onSaved: () => setState(() => currentIndex = 2),
        ),
      ];

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              final slide = Tween<Offset>(
                begin: const Offset(0.02, 0.01),
                end: Offset.zero,
              ).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: slide,
                  child: child,
                ),
              );
            },
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
        onTap: (next) => setState(() {
          currentIndex = next;
          if (next != 3) {
            composeSpotId = null;
          }
        }),
      ),
    );
  }
}
