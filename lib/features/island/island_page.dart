import 'package:flutter/material.dart';

import '../../app/model/island_spot.dart';
import '../../app/state/memory_land_store.dart';
import '../shared/app_page.dart';
import '../shared/detail_sheets.dart';
import '../shared/section_title.dart';
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
        return AppPage(
          title: '小岛地图',
          subtitle: 'Island map',
          badge: '${store.totalSpots} 个地点已点亮',
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
            children: [
              _IslandCard(store: store),
              const SizedBox(height: 18),
              const SectionTitle(label: 'MAP', title: '地点工作台'),
              const SizedBox(height: 10),
              for (final spot in store.spots)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _SpotCard(
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
                ),
              const SizedBox(height: 10),
              _AddSpotCard(store: store),
            ],
          ),
        );
      },
    );
  }
}

class _IslandCard extends StatelessWidget {
  const _IslandCard({required this.store});

  final MemoryLandStore store;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
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
                for (var index = 0; index < store.spots.take(4).length; index++)
                  Positioned(
                    left: 26.0 + (index * 72),
                    bottom: 30 + (index.isEven ? 18 : 6),
                    child: _BubbleSpot(spot: store.spots[index]),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('把碎片慢慢养成地图。', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            '地点越清楚，回忆就越容易回来。',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _SpotCard extends StatelessWidget {
  const _SpotCard({
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
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: spot.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(spot.icon, color: const Color(0xFF224158)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(spot.name, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(spot.description, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text(
                      growthLabel,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: const Color(0xFF224158),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF224158),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '回忆',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6E8798),
                    ),
                  ),
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
    widget.store.addSpot(
      name: _nameController.text,
      description: _descriptionController.text,
    );
    if (_nameController.text.trim().isEmpty || _descriptionController.text.trim().isEmpty) {
      return;
    }
    _nameController.clear();
    _descriptionController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('新地点已经落在沙滩上')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('添一个地点', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('先起个名字，再留一句气味。', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 14),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: '例如：夏天阳台',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            minLines: 2,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: '晒过的衣服、风扇声、傍晚的橘光',
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submit,
              child: const Text('点亮新地点'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleSpot extends StatelessWidget {
  const _BubbleSpot({required this.spot});

  final IslandSpot spot;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(spot.icon, color: const Color(0xFF224158), size: 24),
          const SizedBox(height: 4),
          Text(
            spot.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF224158),
            ),
          ),
        ],
      ),
    );
  }
}
