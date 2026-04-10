import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/model/island_memory.dart';
import '../../app/state/memory_land_store.dart';
import '../shared/app_page.dart';
import '../shared/detail_sheets.dart';
import '../shared/soft_card.dart';

class HomePage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final recent = store.recentMemories(limit: 2);
        return AppPage(
          title: store.islandName,
          subtitle: 'Island memory atlas',
          badge: store.islandCapacityLabel,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
            children: [
              if (store.celebrationMessage != null) ...[
                _CelebrationCard(
                  message: store.celebrationMessage!,
                  onClose: store.clearCelebration,
                ),
                const SizedBox(height: 12),
              ],
              _IslandHero3D(
                store: store,
                onOpenCompose: onOpenCompose,
              ),
              const SizedBox(height: 18),
              _IslandOwnershipCard(store: store),
              const SizedBox(height: 18),
              _WeekRhythmCard(store: store),
              const SizedBox(height: 18),
              _QuickActionsRow(
                onOpenCompose: onOpenCompose,
                onOpenIsland: onOpenIsland,
                onOpenMemories: onOpenMemories,
              ),
              const SizedBox(height: 18),
              if (recent.isNotEmpty) ...[
                Text('刚靠岸的漂流瓶', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                for (final memory in recent)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _BottleCard(
                      memory: memory,
                      onTap: () => showMemoryDetailSheet(context, memory: memory),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _IslandHero3D extends StatelessWidget {
  const _IslandHero3D({
    required this.store,
    required this.onOpenCompose,
  });

  final MemoryLandStore store;
  final VoidCallback onOpenCompose;

  @override
  Widget build(BuildContext context) {
    final months = store.monthAnchors;

    return SoftCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('环岛记忆路线', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              Text('${store.totalMemories}/${store.islandCapacity}', style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 360,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                const centerXFactor = 0.5;
                const centerY = 168.0;
                final centerX = width * centerXFactor;
                const radiusX = 144.0;
                const radiusY = 126.0;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFBCEEFF),
                              Color(0xFF74D5E4),
                              Color(0xFF39B9CF),
                            ],
                          ),
                        ),
                      ),
                    ),
                    for (var index = 0; index < months.length; index++)
                      Positioned(
                        left: centerX + radiusX * math.cos((-90 + index * 30) * math.pi / 180) - 26,
                        top: centerY + radiusY * math.sin((-90 + index * 30) * math.pi / 180) - 26,
                        child: _MonthNode(month: months[index]),
                      ),
                    Positioned(
                      left: width * 0.18,
                      right: width * 0.18,
                      bottom: 54,
                      child: _Island3DShape(progress: store.islandProgress),
                    ),
                    Positioned(
                      left: 18,
                      top: 18,
                      child: _TopPill(
                        icon: Icons.local_fire_department_rounded,
                        label: '${store.streakDays} 天连着靠岸',
                      ),
                    ),
                    Positioned(
                      right: 18,
                      top: 18,
                      child: _TopPill(
                        icon: Icons.workspace_premium_rounded,
                        label: store.isPremium ? '已解锁多岛' : '单岛模式',
                      ),
                    ),
                    Positioned(
                      left: 18,
                      right: 18,
                      bottom: 16,
                      child: FilledButton(
                        onPressed: onOpenCompose,
                        child: const Text('放一只新漂流瓶'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _IslandOwnershipCard extends StatelessWidget {
  const _IslandOwnershipCard({required this.store});

  final MemoryLandStore store;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('岛屿仓位', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  '当前拥有 ${store.ownedIslandCount} 座岛。免费用户默认 1 座，后续可为新年份或新主题申请更多岛屿。',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD96B).withValues(alpha: 0.24),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Text(
                  'PRO',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF224158),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '多岛',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF224158),
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

class _WeekRhythmCard extends StatelessWidget {
  const _WeekRhythmCard({required this.store});

  final MemoryLandStore store;

  @override
  Widget build(BuildContext context) {
    final pulses = store.weeklyPulses;

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('近 7 天上岸节奏', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              Text('WEEK', style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final pulse in pulses)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _WeekBar(pulse: pulse),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow({
    required this.onOpenCompose,
    required this.onOpenIsland,
    required this.onOpenMemories,
  });

  final VoidCallback onOpenCompose;
  final VoidCallback onOpenIsland;
  final VoidCallback onOpenMemories;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionTile(
            icon: Icons.send_rounded,
            title: '漂流瓶',
            subtitle: '丢一只新的',
            color: const Color(0xFF2FC8C2),
            onTap: onOpenCompose,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionTile(
            icon: Icons.map_rounded,
            title: '图鉴',
            subtitle: '看地点成长',
            color: const Color(0xFFFFB957),
            onTap: onOpenIsland,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionTile(
            icon: Icons.inventory_2_rounded,
            title: '宝箱',
            subtitle: '回看回忆',
            color: const Color(0xFFFF8A5B),
            onTap: onOpenMemories,
          ),
        ),
      ],
    );
  }
}

class _BottleCard extends StatelessWidget {
  const _BottleCard({
    required this.memory,
    required this.onTap,
  });

  final IslandMemory memory;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: SoftCard(
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFAFE9F0).withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.liquor_rounded, color: Color(0xFF224158)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(memory.spotName, style: Theme.of(context).textTheme.labelMedium),
                        const Spacer(),
                        Text(memory.dateLabel, style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(memory.title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      memory.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CelebrationCard extends StatelessWidget {
  const _CelebrationCard({
    required this.message,
    required this.onClose,
  });

  final String message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD96B).withValues(alpha: 0.32),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.celebration_rounded, color: Color(0xFF224158)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF224158),
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
            color: const Color(0xFF224158),
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,
        child: SoftCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: const Color(0xFF224158)),
              ),
              const SizedBox(height: 10),
              Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Island3DShape extends StatelessWidget {
  const _Island3DShape({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.18,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 8,
            left: 18,
            right: 18,
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0x33224158),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            child: Transform.scale(
              scaleY: 0.86,
              child: ClipPath(
                clipper: HainanIslandClipper(),
                child: Container(
                  width: 220,
                  height: 168,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF87D96C),
                        Color(0xFF58B64F),
                        Color(0xFF3C8E39),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 58,
            child: ClipPath(
              clipper: HainanIslandClipper(),
              child: Container(
                width: 220,
                height: 168,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFE8D88E),
                      Color(0xFFC5D97E),
                      Color(0xFF81C861),
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3D224158),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 48,
                      top: 56,
                      child: Container(
                        width: 72,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFA8E9F2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 36,
                      bottom: 38,
                      child: Container(
                        width: 56,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAE4A0),
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
            bottom: 24,
            child: Container(
              width: 160,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(999),
              ),
              child: FractionallySizedBox(
                widthFactor: (progress * 8).clamp(0.12, 1),
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9A62),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HainanIslandClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.18, size.height * 0.12);
    path.cubicTo(
      size.width * 0.34,
      size.height * 0.02,
      size.width * 0.62,
      size.height * 0.04,
      size.width * 0.74,
      size.height * 0.18,
    );
    path.cubicTo(
      size.width * 0.92,
      size.height * 0.28,
      size.width * 0.94,
      size.height * 0.5,
      size.width * 0.84,
      size.height * 0.66,
    );
    path.cubicTo(
      size.width * 0.78,
      size.height * 0.84,
      size.width * 0.62,
      size.height * 0.96,
      size.width * 0.46,
      size.height * 0.94,
    );
    path.cubicTo(
      size.width * 0.28,
      size.height * 0.94,
      size.width * 0.12,
      size.height * 0.76,
      size.width * 0.1,
      size.height * 0.56,
    );
    path.cubicTo(
      size.width * 0.02,
      size.height * 0.38,
      size.width * 0.04,
      size.height * 0.2,
      size.width * 0.18,
      size.height * 0.12,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _MonthNode extends StatelessWidget {
  const _MonthNode({required this.month});

  final MonthAnchor month;

  @override
  Widget build(BuildContext context) {
    final active = month.count > 0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.white.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(18),
        boxShadow: active
            ? const [
                BoxShadow(
                  color: Color(0x26349BB2),
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${month.month}月',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF224158),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${month.count}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: active ? const Color(0xFF224158) : const Color(0xFF6E8798),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopPill extends StatelessWidget {
  const _TopPill({
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
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF224158)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF224158),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekBar extends StatelessWidget {
  const _WeekBar({required this.pulse});

  final WeekPulse pulse;

  @override
  Widget build(BuildContext context) {
    final height = 24.0 + (pulse.count * 20.0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: _toneForMood(pulse.mood),
            borderRadius: BorderRadius.circular(18),
          ),
          child: pulse.count == 0
              ? const SizedBox.shrink()
              : Center(
                  child: Text(
                    '${pulse.count}',
                    style: const TextStyle(
                      color: Color(0xFF224158),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(pulse.dayLabel, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }

  Color _toneForMood(String mood) {
    return switch (mood) {
      '怀念' => const Color(0xFFFFD39A),
      '平静' => const Color(0xFFAFE9F0),
      '轻快' => const Color(0xFFFFE66F),
      _ => const Color(0x33FFFFFF),
    };
  }
}
