import 'package:flutter/material.dart';

import '../../app/model/island_memory.dart';
import '../../app/state/memory_land_store.dart';
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
        return AppPage(
          title: '回忆宝箱',
          subtitle: 'Treasure box',
          badge: '${filtered.length} 条正在发光',
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
            children: [
              _FilterCard(
                controller: _searchController,
                moodFilter: moodFilter,
                onChanged: (_) => setState(() {}),
                onMoodChanged: (value) => setState(() => moodFilter = value),
              ),
              const SizedBox(height: 18),
              if (filtered.isEmpty)
                SoftCard(
                  child: Column(
                    children: [
                      const Icon(Icons.search_off_rounded, size: 38, color: Color(0xFF224158)),
                      const SizedBox(height: 10),
                      Text('这里暂时空空的', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 6),
                      Text('换个情绪试试，或者马上去投下一条。', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      FilledButton(onPressed: widget.onOpenCompose, child: const Text('去投放')),
                    ],
                  ),
                ),
              for (final memory in filtered)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _MemoryCard(
                    memory: memory,
                    onTap: () => showMemoryDetailSheet(context, memory: memory),
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
    required this.onChanged,
    required this.onMoodChanged,
  });

  final TextEditingController controller;
  final String moodFilter;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onMoodChanged;

  @override
  Widget build(BuildContext context) {
    const moods = ['全部', '怀念', '平静', '轻快'];

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              hintText: '搜标题、内容或地点',
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final mood in moods)
                ChoiceChip(
                  label: Text(mood),
                  selected: moodFilter == mood,
                  onSelected: (_) => onMoodChanged(mood),
                ),
            ],
          ),
        ],
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
                  _MetaTag(label: memory.spotName),
                  const SizedBox(width: 8),
                  _MetaTag(label: memory.mood),
                  const Spacer(),
                  Text(
                    memory.dateLabel,
                    style: const TextStyle(
                      color: Color(0xFF6E8798),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                height: 122,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _toneForMood(memory.mood).withValues(alpha: 0.5),
                      const Color(0xFFFFF8EB),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 14,
                      top: 14,
                      child: _MediaBadge(
                        icon: Icons.photo_camera_back_rounded,
                        label: '照片感',
                      ),
                    ),
                    const Positioned(
                      right: 14,
                      bottom: 14,
                      child: _MediaBadge(
                        icon: Icons.mic_none_rounded,
                        label: '语音感',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(memory.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                memory.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.wb_sunny_outlined, size: 18, color: Color(0xFF6E8798)),
                  const SizedBox(width: 6),
                  Text(memory.weather, style: Theme.of(context).textTheme.labelMedium),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded, color: Color(0xFF224158)),
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
      '怀念' => const Color(0xFFFFD39A),
      '平静' => const Color(0xFFAFE9F0),
      _ => const Color(0xFFFFE66F),
    };
  }
}

class _MetaTag extends StatelessWidget {
  const _MetaTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF224158),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MediaBadge extends StatelessWidget {
  const _MediaBadge({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF224158)),
          const SizedBox(width: 6),
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
