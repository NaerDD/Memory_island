import 'package:flutter/material.dart';

import '../../app/model/island_memory.dart';
import '../../app/state/memory_land_store.dart';
import '../../app/theme/app_theme.dart';
import '../shared/app_page.dart';
import '../shared/detail_sheets.dart';
import '../shared/diary_reveal.dart';
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
        final grouped = _groupedByDate(filtered);
        final moodCounts = widget.store.moodCounts;

        return AppPage(
          title: '回忆归档',
          subtitle: '像翻旧册页一样，沿着日期把当天的光线、气味和话语一点点找回来。',
          badge: '${filtered.length} 条回忆已归档',
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
            children: [
              DiaryReveal(
                child: _ArchiveFilterSheet(
                  controller: _searchController,
                  moodFilter: moodFilter,
                  moodCounts: moodCounts,
                  onChanged: (_) => setState(() {}),
                  onMoodChanged: (value) => setState(() => moodFilter = value),
                ),
              ),
              const SizedBox(height: 14),
              if (filtered.isEmpty)
                DiaryReveal(
                  delay: const Duration(milliseconds: 120),
                  child: _EmptyArchive(onOpenCompose: widget.onOpenCompose),
                )
              else ...[
                DiaryReveal(
                  delay: const Duration(milliseconds: 100),
                  child: _ArchiveSummary(memories: filtered),
                ),
                const SizedBox(height: 14),
                for (var index = 0; index < grouped.length; index++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: DiaryReveal(
                      delay: Duration(milliseconds: 160 + (index * 70)),
                      child: _DateArchiveSection(
                        dateLabel: grouped[index].$1,
                        memories: grouped[index].$2,
                      ),
                    ),
                  ),
              ],
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

  List<(String, List<IslandMemory>)> _groupedByDate(
      List<IslandMemory> memories) {
    final grouped = <String, List<IslandMemory>>{};
    for (final memory in memories) {
      grouped.putIfAbsent(memory.dateLabel, () => <IslandMemory>[]).add(memory);
    }
    return grouped.entries
        .map((entry) => (entry.key, entry.value))
        .toList(growable: false);
  }
}

class _ArchiveFilterSheet extends StatelessWidget {
  const _ArchiveFilterSheet({
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
    const moods = ['全部', '想念', '平静', '轻快'];

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
                  _ArchiveChip(
                    label: mood,
                    count: mood == '全部'
                        ? moodCounts.values
                            .fold<int>(0, (sum, item) => sum + item)
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

class _ArchiveChip extends StatelessWidget {
  const _ArchiveChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.charcoal
              : Colors.white.withValues(alpha: 0.68),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? Colors.transparent : AppColors.paperLine,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected ? Colors.white : AppColors.charcoal,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(width: 8),
            Text(
              '$count',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.88)
                        : AppColors.mutedInk,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArchiveSummary extends StatelessWidget {
  const _ArchiveSummary({required this.memories});

  final List<IslandMemory> memories;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Row(
        children: [
          Expanded(
            child: _ArchiveMetric(
              label: '归档日期',
              value: '${memories.map((item) => item.dateLabel).toSet().length}',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ArchiveMetric(
              label: '地点数',
              value: '${memories.map((item) => item.spotName).toSet().length}',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ArchiveMetric(
              label: '最近心情',
              value: memories.first.mood,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchiveMetric extends StatelessWidget {
  const _ArchiveMetric({
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
        color: Colors.white.withValues(alpha: 0.52),
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

class _DateArchiveSection extends StatelessWidget {
  const _DateArchiveSection({
    required this.dateLabel,
    required this.memories,
  });

  final String dateLabel;
  final List<IslandMemory> memories;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.92),
              AppColors.paper.withValues(alpha: 0.96),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
              child: Row(
                children: [
                  Text(
                    dateLabel,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.charcoal,
                        ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${memories.length} 条',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            for (var index = 0; index < memories.length; index++)
              _ArchiveEntry(
                memory: memories[index],
                isLast: index == memories.length - 1,
              ),
          ],
        ),
      ),
    );
  }
}

class _ArchiveEntry extends StatelessWidget {
  const _ArchiveEntry({
    required this.memory,
    required this.isLast,
  });

  final IslandMemory memory;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final tone = _toneForMood(memory.mood);

    return InkWell(
      onTap: () => showMemoryDetailSheet(context, memory: memory),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              top: const BorderSide(color: AppColors.paperLine),
              bottom: isLast ? BorderSide.none : BorderSide.none,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: tone,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            memory.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppColors.charcoal,
                                ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(memory.spotName,
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      memory.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _EntryTag(label: memory.mood, tone: tone),
                        const SizedBox(width: 8),
                        Text(memory.weather,
                            style: Theme.of(context).textTheme.labelMedium),
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

  Color _toneForMood(String mood) {
    return switch (mood) {
      '想念' => AppColors.coral,
      '平静' => AppColors.sea,
      '轻快' => AppColors.gold,
      _ => AppColors.leaf,
    };
  }
}

class _EntryTag extends StatelessWidget {
  const _EntryTag({
    required this.label,
    required this.tone,
  });

  final String label;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.14),
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

class _EmptyArchive extends StatelessWidget {
  const _EmptyArchive({required this.onOpenCompose});

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
            child: const Icon(Icons.search_off_rounded,
                size: 30, color: AppColors.ink),
          ),
          const SizedBox(height: 14),
          Text('这里暂时还是空的', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            '换个情绪试试，或者现在就去写一条新的日记。',
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
