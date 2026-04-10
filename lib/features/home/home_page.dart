import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/model/island_memory.dart';
import '../../app/state/memory_land_store.dart';
import '../../app/theme/app_theme.dart';
import '../shared/app_page.dart';
import '../shared/soft_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.store,
    required this.onOpenCompose,
    required this.onOpenIsland,
    required this.onOpenMemories,
    super.key,
  });

  final MemoryLandStore store;
  final VoidCallback onOpenCompose;
  final VoidCallback onOpenIsland;
  final VoidCallback onOpenMemories;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int selectedMonth;
  Offset islandTilt = Offset.zero;

  @override
  void initState() {
    super.initState();
    selectedMonth = _suggestedMonth(widget.store);
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.store != widget.store) {
      selectedMonth = _suggestedMonth(widget.store);
    }
  }

  int _suggestedMonth(MemoryLandStore store) {
    final currentMonth = DateTime.now().month;
    final current = store.monthAnchors.firstWhere(
      (item) => item.month == currentMonth,
      orElse: () => const MonthAnchor(month: 1, count: 0),
    );
    if (current.count > 0) {
      return currentMonth;
    }

    for (final item in store.monthAnchors) {
      if (item.count > 0) {
        return item.month;
      }
    }
    return currentMonth;
  }

  void _handlePan(DragUpdateDetails details, Size size) {
    final dx = ((details.localPosition.dx / size.width) - 0.5).clamp(-0.5, 0.5);
    final dy = ((details.localPosition.dy / size.height) - 0.5).clamp(-0.5, 0.5);
    setState(() => islandTilt = Offset(dx * 0.36, dy * 0.24));
  }

  void _resetTilt([_]) {
    setState(() => islandTilt = Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final monthMemories = _memoriesForMonth(widget.store.memories, selectedMonth);
        return AppPage(
          title: widget.store.islandName,
          subtitle: '一座岛承载一年回忆，把每天的落点都绕成航线。',
          badge: '${widget.store.totalMemories}/${widget.store.islandCapacity} 条记忆已靠岸',
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
            children: [
              _IslandCommandCard(
                store: widget.store,
                selectedMonth: selectedMonth,
                islandTilt: islandTilt,
                onPanUpdate: _handlePan,
                onPanEnd: _resetTilt,
                onMonthSelected: (month) => setState(() => selectedMonth = month),
                onOpenCompose: widget.onOpenCompose,
                onOpenMemories: widget.onOpenMemories,
              ),
              const SizedBox(height: 16),
              _MonthRouteCard(
                month: selectedMonth,
                memories: monthMemories,
                onOpenCompose: widget.onOpenCompose,
                onOpenMemories: widget.onOpenMemories,
              ),
              const SizedBox(height: 16),
              _IslandPlanCard(
                store: widget.store,
                onOpenIsland: widget.onOpenIsland,
              ),
              const SizedBox(height: 16),
              _DockedMemoriesCard(
                memories: widget.store.recentMemories(limit: 3),
                onOpenMemories: widget.onOpenMemories,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _IslandCommandCard extends StatelessWidget {
  const _IslandCommandCard({
    required this.store,
    required this.selectedMonth,
    required this.islandTilt,
    required this.onPanUpdate,
    required this.onPanEnd,
    required this.onMonthSelected,
    required this.onOpenCompose,
    required this.onOpenMemories,
  });

  final MemoryLandStore store;
  final int selectedMonth;
  final Offset islandTilt;
  final void Function(DragUpdateDetails details, Size size) onPanUpdate;
  final GestureDragEndCallback onPanEnd;
  final ValueChanged<int> onMonthSelected;
  final VoidCallback onOpenCompose;
  final VoidCallback onOpenMemories;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: EdgeInsets.zero,
      tone: AppColors.mist,
      radius: 36,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF173F58),
              Color(0xFF206A85),
              Color(0xFF47A9B6),
              Color(0xFF73D2D0),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const _GlassBadge(icon: Icons.public_rounded, label: '主岛模式'),
                const SizedBox(width: 8),
                _GlassBadge(
                  icon: Icons.workspace_premium_rounded,
                  label: store.isPremium ? '已开启多岛' : '单岛可用',
                ),
                const Spacer(),
                TextButton(
                  onPressed: onOpenMemories,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white.withValues(alpha: 0.12),
                  ),
                  child: const Text('查看全部'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              '把一年铺成\n一圈可走的海路',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              '围绕海南岛主岛外圈记录 12 个月。点开月份，再往下看每天靠岸的记忆。',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.84),
                  ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 420,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final sceneSize = Size(constraints.maxWidth, constraints.maxHeight);
                  final center = Offset(sceneSize.width / 2, sceneSize.height * 0.48);
                  final radiusX = sceneSize.width * 0.38;
                  final radiusY = sceneSize.height * 0.24;

                  return GestureDetector(
                    onPanUpdate: (details) => onPanUpdate(details, sceneSize),
                    onPanEnd: onPanEnd,
                    onPanCancel: () => onPanEnd(DragEndDetails()),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(child: CustomPaint(painter: _SeaScenePainter())),
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _MonthOrbitPainter(
                              center: center,
                              radiusX: radiusX,
                              radiusY: radiusY,
                            ),
                          ),
                        ),
                        for (final anchor in store.monthAnchors)
                          _MonthOrbitMarker(
                            anchor: anchor,
                            center: center,
                            radiusX: radiusX,
                            radiusY: radiusY,
                            selected: anchor.month == selectedMonth,
                            onTap: () => onMonthSelected(anchor.month),
                          ),
                        Positioned(
                          left: sceneSize.width * 0.12,
                          right: sceneSize.width * 0.12,
                          top: sceneSize.height * 0.16,
                          child: _Island3DStage(
                            tilt: islandTilt,
                            progress: store.islandProgress,
                            streakDays: store.streakDays,
                            totalMemories: store.totalMemories,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: _SceneFooter(
                            selectedMonth: selectedMonth,
                            monthCount: store.monthAnchors
                                .firstWhere((item) => item.month == selectedMonth)
                                .count,
                            onOpenCompose: onOpenCompose,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Island3DStage extends StatelessWidget {
  const _Island3DStage({
    required this.tilt,
    required this.progress,
    required this.streakDays,
    required this.totalMemories,
  });

  final Offset tilt;
  final double progress;
  final int streakDays;
  final int totalMemories;

  @override
  Widget build(BuildContext context) {
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0012)
      ..rotateX(tilt.dy)
      ..rotateY(-tilt.dx);

    return Transform(
      alignment: Alignment.center,
      transform: transform,
      child: AspectRatio(
        aspectRatio: 1.02,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 4,
              child: Container(
                width: 228,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0x3313364D),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Positioned(
              bottom: 46,
              child: Transform.translate(
                offset: const Offset(12, 30),
                child: Transform.scale(
                  scaleY: 0.8,
                  child: ClipPath(
                    clipper: HainanIslandClipper(),
                    child: Container(
                      width: 256,
                      height: 214,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF326D31),
                            Color(0xFF28582A),
                            Color(0xFF1E4323),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 70,
              child: ClipPath(
                clipper: HainanIslandClipper(),
                child: Container(
                  width: 256,
                  height: 214,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFF0E1A9),
                        Color(0xFFC9DD89),
                        Color(0xFF71C86A),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 40,
                        top: 56,
                        child: Container(
                          width: 84,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFF9DE2EF),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 34,
                        bottom: 42,
                        child: Container(
                          width: 70,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6D88F),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 98,
                        top: 34,
                        child: Container(
                          width: 56,
                          height: 26,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8EDAF),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 68,
              child: _FloatingSceneMetric(label: '连续', value: '$streakDays 天'),
            ),
            Positioned(
              right: 10,
              top: 110,
              child: _FloatingSceneMetric(label: '靠岸', value: '$totalMemories 条'),
            ),
            Positioned(
              bottom: 42,
              child: Container(
                width: 184,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: FractionallySizedBox(
                  widthFactor: (progress * 12).clamp(0.08, 1.0),
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: const LinearGradient(
                        colors: [AppColors.gold, AppColors.coral],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingSceneMetric extends StatelessWidget {
  const _FloatingSceneMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _SceneFooter extends StatelessWidget {
  const _SceneFooter({
    required this.selectedMonth,
    required this.monthCount,
    required this.onOpenCompose,
  });

  final int selectedMonth;
  final int monthCount;
  final VoidCallback onOpenCompose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$selectedMonth 月航线',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  monthCount == 0 ? '这个月还没有记忆靠岸，先投下第一条。' : '这个月已经有 $monthCount 条记忆挂在环线上。',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.78),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: onOpenCompose,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.ink,
            ),
            child: const Text('写进本月'),
          ),
        ],
      ),
    );
  }
}

class _MonthOrbitMarker extends StatelessWidget {
  const _MonthOrbitMarker({
    required this.anchor,
    required this.center,
    required this.radiusX,
    required this.radiusY,
    required this.selected,
    required this.onTap,
  });

  final MonthAnchor anchor;
  final Offset center;
  final double radiusX;
  final double radiusY;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final angle = (-90 + ((anchor.month - 1) * 30)) * math.pi / 180;
    final x = center.dx + radiusX * math.cos(angle) - 24;
    final y = center.dy + radiusY * math.sin(angle) - 24;
    final active = anchor.count > 0;

    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: selected ? 56 : 48,
          height: selected ? 56 : 48,
          decoration: BoxDecoration(
            color: selected
                ? Colors.white
                : active
                    ? Colors.white.withValues(alpha: 0.76)
                    : Colors.white.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.gold : Colors.white.withValues(alpha: 0.2),
              width: selected ? 2 : 1,
            ),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x28FFD780),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${anchor.month}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: selected ? AppColors.ink : const Color(0xFF1B5168),
                ),
              ),
              Text(
                '${anchor.count}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? AppColors.ink
                      : active
                          ? const Color(0xFF1B5168)
                          : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthRouteCard extends StatelessWidget {
  const _MonthRouteCard({
    required this.month,
    required this.memories,
    required this.onOpenCompose,
    required this.onOpenMemories,
  });

  final int month;
  final List<IslandMemory> memories;
  final VoidCallback onOpenCompose;
  final VoidCallback onOpenMemories;

  @override
  Widget build(BuildContext context) {
    final density = (memories.length / 31).clamp(0.0, 1.0);

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$month 月日航线', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text(
                      memories.isEmpty ? '这段海路还空着，可以先留下这个月的第一条记忆。' : '每天的记忆会在这条短航线上依次靠岸。',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              TextButton(onPressed: onOpenMemories, child: const Text('进入宝箱'))
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.58),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _MetricPill(label: '月记忆', value: '${memories.length}'),
                    const SizedBox(width: 8),
                    _MetricPill(label: '密度', value: '${(density * 100).round()}%'),
                  ],
                ),
                const SizedBox(height: 18),
                if (memories.isEmpty)
                  _EmptyMonthState(onOpenCompose: onOpenCompose)
                else
                  SizedBox(
                    height: 124,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        for (var index = 0; index < memories.length; index++) ...[
                          Expanded(
                            child: _DayNode(
                              memory: memories[index],
                              prominent: index == 0,
                            ),
                          ),
                          if (index != memories.length - 1)
                            Expanded(
                              child: Container(
                                height: 3,
                                margin: const EdgeInsets.only(bottom: 28),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  gradient: LinearGradient(
                                    colors: [
                                      _moodTone(memories[index].mood).withValues(alpha: 0.34),
                                      _moodTone(memories[index + 1].mood).withValues(alpha: 0.34),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyMonthState extends StatelessWidget {
  const _EmptyMonthState({required this.onOpenCompose});

  final VoidCallback onOpenCompose;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.sailing_rounded, size: 34, color: AppColors.ink),
        const SizedBox(height: 8),
        Text('这个月的环线还没亮', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Text(
          '先写一条今天的片段，让这条海路开始有落点。',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 14),
        FilledButton.icon(
          onPressed: onOpenCompose,
          icon: const Icon(Icons.add_rounded),
          label: const Text('写第一条'),
        ),
      ],
    );
  }
}

class _DayNode extends StatelessWidget {
  const _DayNode({
    required this.memory,
    required this.prominent,
  });

  final IslandMemory memory;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    final tone = _moodTone(memory.mood);
    final day = memory.dateLabel.split('.').last;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: prominent ? 56 : 46,
          height: prominent ? 56 : 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: tone.withValues(alpha: prominent ? 0.92 : 0.76),
            boxShadow: [
              BoxShadow(
                color: tone.withValues(alpha: 0.26),
                blurRadius: prominent ? 18 : 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              day,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          memory.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.ink,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _IslandPlanCard extends StatelessWidget {
  const _IslandPlanCard({
    required this.store,
    required this.onOpenIsland,
  });

  final MemoryLandStore store;
  final VoidCallback onOpenIsland;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      tone: AppColors.gold,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('岛屿规划', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            '默认用户先拥有一座主岛，用来收纳一整年的记忆。升级后可申请多座岛屿，把不同年份、主题或人生阶段分开管理。',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _PlanCard(
                  title: '当前方案',
                  subtitle: '主岛 01',
                  detail: '可记录一年回忆',
                  active: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PlanCard(
                  title: '进阶方案',
                  subtitle: store.isPremium ? '多岛已解锁' : '多岛待解锁',
                  detail: store.isPremium ? '可管理多座岛屿' : '适合年度归档与主题分岛',
                  active: store.isPremium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  '当前已拥有 ${store.ownedIslandCount} 座岛屿',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              OutlinedButton(
                onPressed: onOpenIsland,
                child: const Text('查看岛屿规划'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.active,
  });

  final String title;
  final String subtitle;
  final String detail;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: active ? Colors.white.withValues(alpha: 0.7) : Colors.white.withValues(alpha: 0.46),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(detail, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _DockedMemoriesCard extends StatelessWidget {
  const _DockedMemoriesCard({
    required this.memories,
    required this.onOpenMemories,
  });

  final List<IslandMemory> memories;
  final VoidCallback onOpenMemories;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('最近靠岸的几条', style: Theme.of(context).textTheme.titleLarge),
              ),
              TextButton(onPressed: onOpenMemories, child: const Text('看全部'))
            ],
          ),
          const SizedBox(height: 10),
          ...memories.map(
            (memory) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _DockedMemoryTile(memory: memory),
            ),
          ),
        ],
      ),
    );
  }
}

class _DockedMemoryTile extends StatelessWidget {
  const _DockedMemoryTile({required this.memory});

  final IslandMemory memory;

  @override
  Widget build(BuildContext context) {
    final tone = _moodTone(memory.mood);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.56),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: tone.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.anchor_rounded, color: tone),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(memory.title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  '${memory.spotName} · ${memory.dateLabel}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
          Text(
            memory.mood,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.64),
        borderRadius: BorderRadius.circular(999),
      ),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.ink),
          children: [
            TextSpan(text: label),
            TextSpan(
              text: '  $value',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassBadge extends StatelessWidget {
  const _GlassBadge({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _SeaScenePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0x20FFFFFF);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.2),
        width: size.width * 0.84,
        height: size.height * 0.28,
      ),
      paint,
    );
    paint.color = const Color(0x15213D51);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.82),
        width: size.width * 1.08,
        height: size.height * 0.24,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MonthOrbitPainter extends CustomPainter {
  const _MonthOrbitPainter({
    required this.center,
    required this.radiusX,
    required this.radiusY,
  });

  final Offset center;
  final double radiusX;
  final double radiusY;

  @override
  void paint(Canvas canvas, Size size) {
    final orbitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0x88FFFFFF);

    const dash = 14.0;
    const gap = 10.0;
    final orbit = Path()
      ..addOval(
        Rect.fromCenter(
          center: center,
          width: radiusX * 2,
          height: radiusY * 2,
        ),
      );

    for (final metric in orbit.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = math.min(distance + dash, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), orbitPaint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MonthOrbitPainter oldDelegate) {
    return oldDelegate.center != center ||
        oldDelegate.radiusX != radiusX ||
        oldDelegate.radiusY != radiusY;
  }
}

class HainanIslandClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.12);
    path.cubicTo(
      size.width * 0.36,
      size.height * 0.02,
      size.width * 0.64,
      size.height * 0.04,
      size.width * 0.78,
      size.height * 0.18,
    );
    path.cubicTo(
      size.width * 0.94,
      size.height * 0.28,
      size.width * 0.95,
      size.height * 0.5,
      size.width * 0.86,
      size.height * 0.68,
    );
    path.cubicTo(
      size.width * 0.78,
      size.height * 0.88,
      size.width * 0.62,
      size.height * 0.97,
      size.width * 0.46,
      size.height * 0.95,
    );
    path.cubicTo(
      size.width * 0.28,
      size.height * 0.95,
      size.width * 0.12,
      size.height * 0.8,
      size.width * 0.1,
      size.height * 0.58,
    );
    path.cubicTo(
      size.width * 0.02,
      size.height * 0.38,
      size.width * 0.06,
      size.height * 0.2,
      size.width * 0.2,
      size.height * 0.12,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

List<IslandMemory> _memoriesForMonth(List<IslandMemory> memories, int month) {
  final prefix = month.toString().padLeft(2, '0');
  final monthMemories = memories.where((memory) => memory.dateLabel.startsWith(prefix)).toList(growable: false);
  monthMemories.sort((a, b) => a.dateLabel.compareTo(b.dateLabel));
  return monthMemories;
}

Color _moodTone(String mood) {
  return switch (mood) {
    '怀念' => AppColors.coral,
    '平静' => AppColors.sea,
    '轻快' => AppColors.gold,
    _ => AppColors.leaf,
  };
}
