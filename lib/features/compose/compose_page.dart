import 'package:flutter/material.dart';

import '../../app/model/island_spot.dart';
import '../../app/state/memory_land_store.dart';
import '../../app/theme/app_theme.dart';
import '../shared/app_page.dart';
import '../shared/soft_card.dart';

class ComposePage extends StatefulWidget {
  const ComposePage({
    required this.store,
    required this.initialSpotId,
    required this.onSaved,
    super.key,
  });

  final MemoryLandStore store;
  final String? initialSpotId;
  final VoidCallback onSaved;

  @override
  State<ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _weatherController = TextEditingController(text: '晴朗');
  String? selectedSpotId;
  String selectedMood = '轻快';
  bool showSuccessCard = false;

  @override
  void initState() {
    super.initState();
    selectedSpotId = widget.initialSpotId ?? widget.store.spots.first.id;
  }

  @override
  void didUpdateWidget(covariant ComposePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSpotId != null && widget.initialSpotId != oldWidget.initialSpotId) {
      setState(() => selectedSpotId = widget.initialSpotId);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _weatherController.dispose();
    super.dispose();
  }

  void _submit() {
    final spotId = selectedSpotId;
    if (spotId == null) {
      return;
    }

    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    if (title.isEmpty || body.isEmpty) {
      return;
    }

    widget.store.addMemory(
      spotId: spotId,
      title: title,
      body: body,
      mood: selectedMood,
      weather: _weatherController.text,
    );

    _titleController.clear();
    _bodyController.clear();
    _weatherController.text = '晴朗';
    setState(() {
      selectedMood = '轻快';
      showSuccessCard = true;
    });
    widget.onSaved();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('新的回忆已经稳稳靠岸')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final spots = widget.store.spots;
        final targetSpotId = selectedSpotId ?? spots.first.id;
        final selectedSpot = spots.firstWhere((spot) => spot.id == targetSpotId);
        final growthPreview = widget.store.growthLabelAfterNextMemory(targetSpotId);

        return AppPage(
          title: '漂流瓶',
          subtitle: '先抓住情绪，再把细节慢慢装进去。',
          badge: '准备投向 ${selectedSpot.name}',
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
            children: [
              if (showSuccessCard) ...[
                _SuccessBanner(
                  message: widget.store.celebrationMessage ?? '新的回忆已经靠岸',
                  onClose: () {
                    setState(() => showSuccessCard = false);
                    widget.store.clearCelebration();
                  },
                ),
                const SizedBox(height: 12),
              ],
              _PreviewCard(
                spot: selectedSpot,
                mood: selectedMood,
                growthPreview: growthPreview,
              ),
              const SizedBox(height: 16),
              SoftCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1. 选今天的气氛', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final mood in const ['轻快', '平静', '怀念'])
                          ChoiceChip(
                            label: Text(mood),
                            selected: selectedMood == mood,
                            onSelected: (_) => setState(() => selectedMood = mood),
                          ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text('2. 选择靠岸地点', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final spot in spots)
                          ChoiceChip(
                            label: Text(spot.name),
                            selected: selectedSpotId == spot.id,
                            onSelected: (_) => setState(() => selectedSpotId = spot.id),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SoftCard(
                tone: selectedSpot.accent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('3. 写下此刻', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      _promptForMood(selectedMood),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: '标题，例如：午后那阵风突然吹进来',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _bodyController,
                      minLines: 5,
                      maxLines: 7,
                      decoration: const InputDecoration(
                        hintText: '写下声音、气味、动作，或者你突然想起的一个画面。',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _weatherController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.wb_sunny_outlined),
                        hintText: '天气 / 氛围',
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.sailing_rounded),
                        label: const Text('放进海里'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.spot,
    required this.mood,
    required this.growthPreview,
  });

  final IslandSpot spot;
  final String mood;
  final String growthPreview;

  @override
  Widget build(BuildContext context) {
    final tone = _moodTone(mood);
    return SoftCard(
      padding: EdgeInsets.zero,
      tone: tone,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              tone.withValues(alpha: 0.2),
              Colors.white.withValues(alpha: 0.56),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.54),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(spot.icon, color: AppColors.ink),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('准备投向 ${spot.name}', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(spot.description, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _InfoPill(label: mood, tone: tone),
                const SizedBox(width: 8),
                _InfoPill(label: growthPreview, tone: spot.accent),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  const _SuccessBanner({
    required this.message,
    required this.onClose,
  });

  final String message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      tone: AppColors.gold,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.26),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: AppColors.ink),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.label,
    required this.tone,
  });

  final String label;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.14),
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

String _promptForMood(String mood) {
  return switch (mood) {
    '怀念' => '先抓住那个突然想起的旧画面，写下它为什么会回来。',
    '平静' => '写下周围最安静的东西，和你此刻没有说出口的感受。',
    _ => '先记住今天最亮的一个瞬间，不必完整，先把它留住。',
  };
}

Color _moodTone(String mood) {
  return switch (mood) {
    '怀念' => AppColors.coral,
    '平静' => AppColors.sea,
    _ => AppColors.gold,
  };
}
