import 'package:flutter/material.dart';

import '../../app/model/island_memory.dart';
import '../../app/model/island_spot.dart';
import '../../app/state/memory_land_store.dart';
import '../shared/app_page.dart';
import '../shared/detail_sheets.dart';
import '../shared/section_title.dart';
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
        final recent = store.recentMemories();
        return AppPage(
          title: '回忆岛',
          subtitle: 'Sunny mode',
          badge: store.dailyHint,
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
              _HeroCard(
                progress: store.islandProgress,
                memoryCount: store.totalMemories,
                streakDays: store.streakDays,
              ),
              const SizedBox(height: 18),
              _QuestCard(
                progress: store.questProgress / store.questTarget,
                title: store.questTitle,
                rewardLabel: store.nextRewardLabel,
                onTap: onOpenCompose,
              ),
              const SizedBox(height: 18),
              _StatsRow(store: store),
              const SizedBox(height: 18),
              _MoodBoard(store: store),
              const SizedBox(height: 18),
              _BadgeWall(store: store, onOpenIsland: onOpenIsland),
              const SizedBox(height: 18),
              const SectionTitle(label: 'PLAY', title: '今天怎么继续点亮'),
              const SizedBox(height: 10),
              _ActionCard(
                tag: '最快',
                title: '投下一条新回忆',
                body: '一句也可以，先把它留在沙滩上。',
                color: const Color(0xFF2FC8C2),
                onTap: onOpenCompose,
              ),
              const SizedBox(height: 10),
              _ActionCard(
                tag: '地图',
                title: '去看地点长成了什么样',
                body: '每多一条回忆，岛就更清晰一点。',
                color: const Color(0xFFFFB957),
                onTap: onOpenIsland,
              ),
              const SizedBox(height: 18),
              const SectionTitle(label: 'RECENT', title: '刚落下的几枚碎片'),
              const SizedBox(height: 10),
              for (final memory in recent)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _RecentMemoryCard(
                    memory: memory,
                    onTap: () => showMemoryDetailSheet(context, memory: memory),
                  ),
                ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: onOpenMemories,
                child: const Text('去宝箱继续翻找'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.progress,
    required this.memoryCount,
    required this.streakDays,
  });

  final double progress;
  final int memoryCount;
  final int streakDays;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFEBB0),
                  Color(0xFFB5EEF2),
                  Color(0xFF54C7D7),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 22,
                  top: 22,
                  child: _FloatBadge(
                    icon: Icons.auto_awesome_rounded,
                    label: '$memoryCount 枚已上岛',
                  ),
                ),
                Positioned(
                  right: 22,
                  top: 22,
                  child: _FloatBadge(
                    icon: Icons.local_fire_department_rounded,
                    label: '$streakDays 天连着捡',
                  ),
                ),
                const Positioned(
                  left: 26,
                  top: 76,
                  child: _BubbleSpot(icon: Icons.cottage_rounded, label: '童年'),
                ),
                const Positioned(
                  right: 22,
                  top: 84,
                  child: _BubbleSpot(icon: Icons.waves_rounded, label: '海边'),
                ),
                const Positioned(
                  left: 130,
                  bottom: 18,
                  child: _BubbleSpot(icon: Icons.wb_sunny_rounded, label: '今天'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('把今天的闪光捡回来。', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 10),
          Text(
            '不用写完整故事，先留下味道、风声，或者一个动作。',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.55),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFFF9A62)),
            ),
          ),
        ],
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

class _QuestCard extends StatelessWidget {
  const _QuestCard({
    required this.progress,
    required this.title,
    required this.rewardLabel,
    required this.onTap,
  });

  final double progress;
  final String title;
  final String rewardLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: SoftCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2FC8C2).withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'TODAY QUEST',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF224158),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text('${(progress * 100).round()}%', style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(rewardLabel, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  minHeight: 9,
                  value: progress.clamp(0, 1),
                  backgroundColor: Colors.white.withValues(alpha: 0.48),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF2FC8C2)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.store});

  final MemoryLandStore store;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(value: '${store.totalMemories}', label: '已上岛'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(value: '${store.totalSpots}', label: '地点'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(value: '${store.sparkleCount}', label: '短闪光'),
        ),
      ],
    );
  }
}

class _MoodBoard extends StatelessWidget {
  const _MoodBoard({required this.store});

  final MemoryLandStore store;

  @override
  Widget build(BuildContext context) {
    final moods = store.moodCounts.entries.toList();
    final total = store.totalMemories == 0 ? 1 : store.totalMemories;

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('今天的情绪海面', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              Text('MOODS', style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final mood in moods)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _MoodBubble(
                      label: mood.key,
                      value: mood.value,
                      ratio: mood.value / total,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BadgeWall extends StatelessWidget {
  const _BadgeWall({
    required this.store,
    required this.onOpenIsland,
  });

  final MemoryLandStore store;
  final VoidCallback onOpenIsland;

  @override
  Widget build(BuildContext context) {
    final badges = store.earnedBadges;

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('地点徽章墙', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              TextButton(onPressed: onOpenIsland, child: const Text('去地图')),
            ],
          ),
          const SizedBox(height: 8),
          if (badges.isEmpty)
            Text('还没有点亮的地点，先去投第一条。', style: Theme.of(context).textTheme.bodyMedium)
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final badge in badges)
                  _BadgeChip(
                    spot: badge,
                    label: store.growthLabelForSpot(badge.id),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF224158),
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.tag,
    required this.title,
    required this.body,
    required this.color,
    required this.onTap,
  });

  final String tag;
  final String title;
  final String body;
  final Color color;
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF224158),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(body, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF224158)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentMemoryCard extends StatelessWidget {
  const _RecentMemoryCard({
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
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF47C8D6).withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.star_rounded, color: Color(0xFF224158)),
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

class _MoodBubble extends StatelessWidget {
  const _MoodBubble({
    required this.label,
    required this.value,
    required this.ratio,
  });

  final String label;
  final int value;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    final size = 56 + (ratio * 44);

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(size / 2),
          ),
          child: Center(
            child: Text(
              '$value',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF224158),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({
    required this.spot,
    required this.label,
  });

  final IslandSpot spot;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: spot.accent.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(spot.icon, size: 18, color: const Color(0xFF224158)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                spot.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF224158),
                ),
              ),
              Text(label, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ],
      ),
    );
  }
}

class _FloatBadge extends StatelessWidget {
  const _FloatBadge({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF224158)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF224158),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleSpot extends StatelessWidget {
  const _BubbleSpot({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF224158), size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF224158),
            ),
          ),
        ],
      ),
    );
  }
}
