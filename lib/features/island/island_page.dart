import 'package:flutter/material.dart';

import '../../app/model/island_spot.dart';
import '../../app/state/memory_land_store.dart';
import '../../app/theme/app_theme.dart';
import '../shared/app_page.dart';
import '../shared/detail_sheets.dart';
import '../shared/soft_card.dart';

class IslandPage extends StatelessWidget {
  const IslandPage({
    required this.store,
    required this.onOpenCompose,
    super.key,
  });

  final MemoryLandStore store;
  final ValueChanged<String> onOpenCompose;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final featured = store.spots.take(3).toList(growable: false);
        return AppPage(
          title: '岛屿图鉴',
          subtitle: '地点越清楚，回忆就越容易回来。',
          badge: '${store.totalSpots} 个地点已点亮',
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
            children: [
              _OverviewCard(store: store),
              const SizedBox(height: 16),
              _FeaturedStrip(
                spots: featured,
                store: store,
                onOpenCompose: onOpenCompose,
              ),
              const SizedBox(height: 16),
              Text('全部地点', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text('每个地点都是一块正在成形的记忆地貌。', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              for (final spot in store.spots)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _SpotCard(
                    spot: spot,
                    store: store,
                    onTap: () => showSpotDetailSheet(
                      context,
                      spot: spot,
                      memories: store.memoriesForSpot(spot.id),
                      onCompose: () => onOpenCompose(spot.id),
                    ),
                  ),
                ),
              _AddSpotCard(store: store),
            ],
          ),
        );
      },
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.store});

  final MemoryLandStore store;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: EdgeInsets.zero,
      tone: AppColors.mist,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFE9B8),
              Color(0xFFD9F2E9),
              Color(0xFFAFDDEC),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('岛屿总览', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.seaDeep)),
            const SizedBox(height: 8),
            Text('把碎片慢慢养成地图', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 10),
            Text(
              '地点越多，回忆就不会只停留在一句话，它会开始拥有方向、气味和轮廓。',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 18),
            Container(
              height: 170,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.42),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Stack(
                children: [
                  const Positioned.fill(child: _IslandDecor()),
                  for (var index = 0; index < store.spots.length; index++)
                    Positioned(
                      left: 24.0 + (index * 92) % 220,
                      top: 26.0 + (index.isEven ? 24 : 72),
                      child: _SpotBubble(
                        spot: store.spots[index],
                        count: store.memoryCountForSpot(store.spots[index].id),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _OverviewMetric(
                    label: '已点亮地点',
                    value: '${store.totalSpots}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _OverviewMetric(
                    label: '累计回忆',
                    value: '${store.totalMemories}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _OverviewMetric(
                    label: '正在发光',
                    value: '${store.earnedBadges.length}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedStrip extends StatelessWidget {
  const _FeaturedStrip({
    required this.spots,
    required this.store,
    required this.onOpenCompose,
  });

  final List<IslandSpot> spots;
  final MemoryLandStore store;
  final ValueChanged<String> onOpenCompose;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('本周重点地点', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text('先把最常回头看的地方讲得更具体一些。', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        SizedBox(
          height: 212,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: spots.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final spot = spots[index];
              return SizedBox(
                width: 220,
                child: _FeaturedCard(
                  spot: spot,
                  count: store.memoryCountForSpot(spot.id),
                  growthLabel: store.growthLabelForSpot(spot.id),
                  onTap: () => showSpotDetailSheet(
                    context,
                    spot: spot,
                    memories: store.memoriesForSpot(spot.id),
                    onCompose: () => onOpenCompose(spot.id),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.spot,
    required this.count,
    required this.growthLabel,
    required this.onTap,
  });

  final IslandSpot spot;
  final int count;
  final String growthLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: SoftCard(
          tone: spot.accent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 96,
                decoration: BoxDecoration(
                  color: spot.accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Icon(spot.icon, size: 36, color: AppColors.ink),
                ),
              ),
              const SizedBox(height: 14),
              Text(spot.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(
                spot.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              Text(
                '$count 条回忆 · $growthLabel',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpotCard extends StatelessWidget {
  const _SpotCard({
    required this.spot,
    required this.store,
    required this.onTap,
  });

  final IslandSpot spot;
  final MemoryLandStore store;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final count = store.memoryCountForSpot(spot.id);
    final progress = (count / 5).clamp(0.0, 1.0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: SoftCard(
          tone: spot.accent,
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: spot.accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(spot.icon, color: AppColors.ink),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(spot.name, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(spot.description, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        value: progress,
                        backgroundColor: Colors.white.withValues(alpha: 0.56),
                        valueColor: AlwaysStoppedAnimation<Color>(spot.accent),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      store.growthLabelForSpot(spot.id),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.ink,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$count', style: Theme.of(context).textTheme.headlineMedium),
                  Text('回忆', style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddSpotCard extends StatefulWidget {
  const _AddSpotCard({required this.store});

  final MemoryLandStore store;

  @override
  State<_AddSpotCard> createState() => _AddSpotCardState();
}

class _AddSpotCardState extends State<_AddSpotCard> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    if (name.isEmpty || description.isEmpty) {
      return;
    }

    widget.store.addSpot(
      name: name,
      description: description,
    );
    _nameController.clear();
    _descriptionController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('新地点已经落在海岛上')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      tone: AppColors.leaf,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('添加新地点', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text('先起一个名字，再写一句它的气味或光线。', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 14),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: '例如：夏天阳台'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            minLines: 2,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: '例如：被风吹翻的课本、晾衣杆的影子、傍晚刚亮的灯。',
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.add_location_alt_rounded),
              label: const Text('点亮这个地点'),
            ),
          ),
        ],
      ),
    );
  }
}

class _IslandDecor extends StatelessWidget {
  const _IslandDecor();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _IslandDecorPainter(),
    );
  }
}

class _IslandDecorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sand = Paint()..color = const Color(0x2AFFFFFF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.08, size.height * 0.58, size.width * 0.84, size.height * 0.22),
        const Radius.circular(90),
      ),
      sand,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.62, size.height * 0.38),
        width: size.width * 0.56,
        height: size.height * 0.42,
      ),
      Paint()..color = const Color(0x18FFFFFF),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SpotBubble extends StatelessWidget {
  const _SpotBubble({
    required this.spot,
    required this.count,
  });

  final IslandSpot spot;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(spot.icon, size: 22, color: AppColors.ink),
          const SizedBox(height: 6),
          Text(
            spot.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 2),
          Text('$count', style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.54),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
