import 'package:flutter/material.dart';

import '../../app/model/island_memory.dart';
import '../../app/model/island_spot.dart';
import 'soft_card.dart';

Future<void> showMemoryDetailSheet(
  BuildContext context, {
  required IslandMemory memory,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _SheetFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _Pill(label: memory.spotName),
                const SizedBox(width: 8),
                _Pill(label: memory.mood),
                const Spacer(),
                Text(memory.dateLabel, style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 16),
            Text(memory.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 10),
            Text(memory.body, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 18),
            Row(
              children: [
                const Icon(Icons.wb_sunny_outlined, size: 18, color: Color(0xFF6E8798)),
                const SizedBox(width: 6),
                Text(memory.weather, style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future<void> showSpotDetailSheet(
  BuildContext context, {
  required IslandSpot spot,
  required List<IslandMemory> memories,
  required VoidCallback onCompose,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _SheetFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
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
                      Text(spot.name, style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 4),
                      Text(spot.description, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text('这里已经收住 ${memories.length} 条回忆', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            if (memories.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _TimelineStrip(memories: memories),
              ),
            if (memories.isEmpty)
              Text('这里还空着，先投下一条试试。', style: Theme.of(context).textTheme.bodyMedium)
            else
              ...memories.take(3).map(
                (memory) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SoftCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(memory.dateLabel, style: Theme.of(context).textTheme.labelMedium),
                            const Spacer(),
                            _Pill(label: memory.mood),
                          ],
                        ),
                        const SizedBox(height: 8),
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
                ),
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onCompose();
                },
                child: const Text('往这里投一条新回忆'),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 20, 14, 14),
      child: SafeArea(
        top: false,
        child: SoftCard(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0x33224158),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF224158),
        ),
      ),
    );
  }
}

class _TimelineStrip extends StatelessWidget {
  const _TimelineStrip({required this.memories});

  final List<IslandMemory> memories;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('最近的落点时间线', style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 8),
        SizedBox(
          height: 66,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: memories.length.clamp(0, 4),
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final memory = memories[index];
              return Container(
                width: 120,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(memory.dateLabel, style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 4),
                    Text(
                      memory.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF224158),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
