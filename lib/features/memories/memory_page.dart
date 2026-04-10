import 'package:flutter/material.dart';

import '../../app/model/island_memory.dart';
import '../../app/state/memory_land_store.dart';
import '../../app/theme/app_theme.dart';
import '../shared/app_page.dart';
import '../shared/detail_sheets.dart';
import '../shared/soft_card.dart';

class MemoryPage extends StatefulWidget {
  const MemoryPage({
    required this.store,
    required this.onOpenCompose,
    super.key,
  });

  final MemoryLandStore store;
  final VoidCallback onOpenCompose;

  @override
  State<MemoryPage> createState() => _MemoryPageState();
}

class _MemoryPageState extends State<MemoryPage> {
  final _searchController = TextEditingController();
  String moodFilter = '全部';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final filtered = _filteredMemories(widget.store.memories);
        final moodCounts = widget.store.moodCounts;

        return AppPage(
          title: '回忆宝箱',
          subtitle: '可以搜索、筛选，也可以随时回头看。',
          badge: '${filtered.length} 条回忆正在发光',
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
            children: [
              _FilterCard(
                controller: _searchController,
                moodFilter: moodFilter,
                moodCounts: moodCounts,
                onChanged: (_) => setState(() {}),
                onMoodChanged: (value) => setState(() => moodFilter = value),
              ),
              const SizedBox(height: 16),
              if (filtered.isEmpty)
                _EmptyCard(onOpenCompose: widget.onOpenCompose)
              else
                ...filtered.map(
                  (memory) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _MemoryCard(
                      memory: memory,
                      onTap: () => showMemoryDetailSheet(context, memory: memory),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  List<IslandMemory> _filteredMemories(List<IslandMemory> memories) {
    final keyword = _searchController.text.trim().toLowerCase();
    return memories.where((memory) {
      final moodMatches = moodFilter == '全部' || memory.mood == moodFilter;
      final keywordMatches = keyword.isEmpty ||
          memory.title.toLowerCase().contains(keyword) ||
          memory.body.toLowerCase().contains(keyword) ||
          memory.spotName.toLowerCase().contains(keyword);
      return moodMatches && keywordMatches;
    }).toList(growable: false);
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard({
    required this.controller,
    required this.moodFilter,
    required this.moodCounts,
    required this.onChanged,
    required this.onMoodChanged,
  });

  final TextEditingController controller;
  final String moodFilter;
  final Map<String, int> moodCounts;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onMoodChanged;

  @override
  Widget build(BuildContext context) {
    const moods = ['全部', '怀念', '平静', '轻快'];

    return SoftCard(
      tone: AppColors.mist,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              hintText: '搜索标题、正文或地点',
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final mood in moods) ...[
                  _MoodChip(
                    label: mood,
                    count: mood == '全部'
                        ? moodCounts.values.fold<int>(0, (sum, item) => sum + item)
                        : (moodCounts[mood] ?? 0),
                    selected: moodFilter == mood,
                    onTap: () => onMoodChanged(mood),
                  ),
                  if (mood != moods.last) const SizedBox(width: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodChip extends StatelessWidget {
  const _MoodChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.ink : Colors.white.withValues(alpha: 0.58),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected ? Colors.white : AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.12)
                    : AppColors.ink.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$count',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: selected ? Colors.white : AppColors.ink,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoryCard extends StatelessWidget {
  const _MemoryCard({
    required this.memory,
    required this.onTap,
  });

  final IslandMemory memory;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tone = _toneForMood(memory.mood);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: SoftCard(
          tone: tone,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _MetaTag(label: memory.spotName, tone: tone),
                  const SizedBox(width: 8),
                  _MetaTag(label: memory.mood, tone: tone),
                  const Spacer(),
                  Text(memory.dateLabel, style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      tone.withValues(alpha: 0.2),
                      Colors.white.withValues(alpha: 0.5),
                    ],
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.46),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.auto_stories_rounded, color: tone),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(memory.title, style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text(
                            memory.body,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.wb_sunny_outlined, size: 18, color: AppColors.mutedInk),
                  const SizedBox(width: 6),
                  Text(memory.weather, style: Theme.of(context).textTheme.labelMedium),
                  const Spacer(),
                  Icon(Icons.chevron_right_rounded, color: tone),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _toneForMood(String mood) {
    return switch (mood) {
      '怀念' => AppColors.coral,
      '平静' => AppColors.sea,
      '轻快' => AppColors.gold,
      _ => AppColors.leaf,
    };
  }
}

class _MetaTag extends StatelessWidget {
  const _MetaTag({
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
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.onOpenCompose});

  final VoidCallback onOpenCompose;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      tone: AppColors.mist,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.62),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.search_off_rounded, size: 30, color: AppColors.ink),
          ),
          const SizedBox(height: 14),
          Text('这里暂时空空的', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            '换个情绪试试，或者现在去写一条新的漂流瓶。',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onOpenCompose,
            icon: const Icon(Icons.edit_rounded),
            label: const Text('去写一条'),
          ),
        ],
      ),
    );
  }
}
