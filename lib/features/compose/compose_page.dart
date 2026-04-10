import 'package:flutter/material.dart';

import '../../app/state/memory_land_store.dart';
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
  bool expandWriting = false;

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

    widget.store.addMemory(
      spotId: spotId,
      title: _titleController.text,
      body: _bodyController.text,
      mood: selectedMood,
      weather: _weatherController.text,
    );

    if (_titleController.text.trim().isEmpty || _bodyController.text.trim().isEmpty) {
      return;
    }

    _titleController.clear();
    _bodyController.clear();
    _weatherController.text = '晴朗';
    setState(() {
      selectedMood = '轻快';
      showSuccessCard = true;
      expandWriting = false;
    });
    widget.onSaved();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('回忆已经稳稳落地')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final spots = widget.store.spots;
        final targetSpotId = selectedSpotId ?? spots.first.id;
        final growthPreview = widget.store.growthLabelAfterNextMemory(targetSpotId);
        final selectedSpot = spots.firstWhere((spot) => spot.id == targetSpotId);

        return AppPage(
          title: '漂流瓶',
          subtitle: 'Bottle a memory',
          badge: '先收住一种心情',
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                child: showSuccessCard
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SoftCard(
                          key: const ValueKey('success'),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFD96B).withValues(alpha: 0.32),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF224158)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.store.celebrationMessage ?? '新的漂流瓶已经靠岸',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: const Color(0xFF224158),
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => setState(() => showSuccessCard = false),
                                icon: const Icon(Icons.close_rounded),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              SoftCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('先选今天的感觉', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text('像 EMMO 那样，先抓住心情，再慢慢补文字。', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 18),
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
                    const SizedBox(height: 18),
                    Text('把它放进哪里', style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final spot in spots)
                          ChoiceChip(
                            label: Text(spot.name),
                            selected: selectedSpotId == spot.id,
                            onSelected: (_) => setState(() => selectedSpotId = spot.id),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedSpot.accent.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        '这次放进 ${selectedSpot.name} 后，它会进入「$growthPreview」',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF224158),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _MediaStub(
                            icon: Icons.photo_camera_back_rounded,
                            label: '照片位',
                            tone: selectedSpot.accent,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MediaStub(
                            icon: Icons.mic_none_rounded,
                            label: '语音位',
                            tone: const Color(0xFF2FC8C2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 220),
                      crossFadeState: expandWriting ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      firstChild: _QuickWriteCard(
                        mood: selectedMood,
                        onExpand: () => setState(() => expandWriting = true),
                      ),
                      secondChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              hintText: '标题，例如：冰橙子那一下',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _bodyController,
                            minLines: 4,
                            maxLines: 6,
                            decoration: const InputDecoration(
                              hintText: '写下光线、声音、气味，或者一个动作。',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _weatherController,
                                  decoration: const InputDecoration(
                                    hintText: '天气 / 氛围',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FilledButton.tonal(
                                  onPressed: () => setState(() => expandWriting = false),
                                  child: const Text('收起'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _submit,
                        child: const Text('放进海里'),
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

class _QuickWriteCard extends StatelessWidget {
  const _QuickWriteCard({
    required this.mood,
    required this.onExpand,
  });

  final String mood;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    final hint = switch (mood) {
      '怀念' => '先写一句你突然想起来的话',
      '平静' => '先写下现在周围最安静的东西',
      _ => '先写下这一刻最亮的一下',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(hint, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onExpand,
              child: const Text('展开写更多'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaStub extends StatelessWidget {
  const _MediaStub({
    required this.icon,
    required this.label,
    required this.tone,
  });

  final IconData icon;
  final String label;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF224158), size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: const Color(0xFF224158),
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
