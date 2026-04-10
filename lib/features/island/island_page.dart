import 'package:flutter/material.dart';

import '../../app/model/island_spot.dart';
import '../../app/state/memory_land_store.dart';
import '../../app/theme/app_theme.dart';
import '../shared/app_page.dart';
import '../shared/detail_sheets.dart';
import '../shared/diary_reveal.dart';
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
          title: '岛屿图鉴',
          subtitle: '像一本地点索引册，把你反复经过、停留和想念过的地方都编进目录。',
          badge: '${store.totalSpots} 个地点已收录',
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
            children: [
              DiaryReveal(
                child: _IslandLedger(store: store),
              ),
              const SizedBox(height: 14),
              DiaryReveal(
                delay: const Duration(milliseconds: 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('地点目录', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text('每个地点都像一个词条，越写越清楚。',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              for (var index = 0; index < store.spots.length; index++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DiaryReveal(
                    delay: Duration(milliseconds: 150 + (index * 70)),
                    child: _CatalogRow(
                      index: index + 1,
                      spot: store.spots[index],
                      memoryCount:
                          store.memoryCountForSpot(store.spots[index].id),
                      growthLabel:
                          store.growthLabelForSpot(store.spots[index].id),
                      onTap: () => showSpotDetailSheet(
                        context,
                        spot: store.spots[index],
                        memories: store.memoriesForSpot(store.spots[index].id),
                        onCompose: () => onOpenCompose(store.spots[index].id),
                      ),
                    ),
                  ),
                ),
              DiaryReveal(
                delay: Duration(milliseconds: 220 + (store.spots.length * 60)),
                child: _AddSpotSheet(store: store),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _IslandLedger extends StatelessWidget {
  const _IslandLedger({required this.store});

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
              Color(0xFFFFE8C1),
              Color(0xFFF8F4EC),
              Color(0xFFDCEBED),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('索引页',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: AppColors.seaDeep)),
            const SizedBox(height: 8),
            Text('把地点慢慢写成自己的地图',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 10),
            Text(
              '地点越多，回忆就越不会失去方向。它们开始互相连成小路、楼梯、风口和黄昏。',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _LedgerMetric(
                    label: '点亮地点',
                    value: '${store.totalSpots}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _LedgerMetric(
                    label: '累计回忆',
                    value: '${store.totalMemories}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _LedgerMetric(
                    label: '已成片',
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

class _LedgerMetric extends StatelessWidget {
  const _LedgerMetric({
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
        color: Colors.white.withValues(alpha: 0.54),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _CatalogRow extends StatelessWidget {
  const _CatalogRow({
    required this.index,
    required this.spot,
    required this.memoryCount,
    required this.growthLabel,
    required this.onTap,
  });

  final int index;
  final IslandSpot spot;
  final int memoryCount;
  final String growthLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: SoftCard(
          tone: spot.accent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.56),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  index.toString().padLeft(2, '0'),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(spot.name,
                              style: Theme.of(context).textTheme.titleLarge),
                        ),
                        Icon(spot.icon, color: AppColors.ink),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(spot.description,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _CatalogPill(
                            label: '$memoryCount 条回忆', tone: spot.accent),
                        _CatalogPill(label: growthLabel, tone: AppColors.ink),
                      ],
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

class _CatalogPill extends StatelessWidget {
  const _CatalogPill({
    required this.label,
    required this.tone,
  });

  final String label;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.charcoal,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _AddSpotSheet extends StatefulWidget {
  const _AddSpotSheet({required this.store});

  final MemoryLandStore store;

  @override
  State<_AddSpotSheet> createState() => _AddSpotSheetState();
}

class _AddSpotSheetState extends State<_AddSpotSheet> {
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

    widget.store.addSpot(name: name, description: description);
    _nameController.clear();
    _descriptionController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('新的地点已经编入目录。')),
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
          Text('给它取个名字，再补一句会让你想起它的细节。',
              style: Theme.of(context).textTheme.bodyMedium),
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
              label: const Text('编入目录'),
            ),
          ),
        ],
      ),
    );
  }
}
