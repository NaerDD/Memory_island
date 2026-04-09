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
    setState(() => selectedMood = '轻快');
    setState(() => showSuccessCard = true);
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
        return AppPage(
          title: '投放回忆',
          subtitle: 'Drop a memory',
          badge: '先写最亮的一下',
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
                                  widget.store.celebrationMessage ?? '新的回忆稳稳落地',
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
                    Text('投下一枚新碎片', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text('先把味道、风或者一个动作留住。', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 18),
                    Text('落点', style: Theme.of(context).textTheme.labelMedium),
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
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD96B).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        '这次落下去后，这个地点会进入「$growthPreview」',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF224158),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    const SizedBox(height: 14),
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
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedMood,
                            decoration: const InputDecoration(),
                            items: const [
                              DropdownMenuItem(value: '轻快', child: Text('轻快')),
                              DropdownMenuItem(value: '平静', child: Text('平静')),
                              DropdownMenuItem(value: '怀念', child: Text('怀念')),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => selectedMood = value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _submit,
                        child: const Text('让它上岛'),
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
