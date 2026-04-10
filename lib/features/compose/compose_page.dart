import 'package:flutter/material.dart';

import '../../app/model/island_spot.dart';
import '../../app/state/memory_land_store.dart';
import '../../app/theme/app_theme.dart';
import '../shared/app_page.dart';
import '../shared/diary_reveal.dart';
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
    if (widget.initialSpotId != null &&
        widget.initialSpotId != oldWidget.initialSpotId) {
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
      const SnackBar(content: Text('新的回忆已经安静靠岸。')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final spots = widget.store.spots;
        final targetSpotId = selectedSpotId ?? spots.first.id;
        final selectedSpot =
            spots.firstWhere((spot) => spot.id == targetSpotId);
        final growthPreview =
            widget.store.growthLabelAfterNextMemory(targetSpotId);

        return AppPage(
          title: '写下今天',
          subtitle: '像在一页稿纸上慢慢落笔，把今天的光线、声音和气味记下来。',
          badge: '正在写给 ${selectedSpot.name}',
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
            children: [
              if (showSuccessCard) ...[
                DiaryReveal(
                  child: _SuccessBanner(
                    message: widget.store.celebrationMessage ?? '新的回忆已经靠岸。',
                    onClose: () {
                      setState(() => showSuccessCard = false);
                      widget.store.clearCelebration();
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
              DiaryReveal(
                delay: const Duration(milliseconds: 60),
                child: _PreviewSheet(
                  spot: selectedSpot,
                  mood: selectedMood,
                  growthPreview: growthPreview,
                ),
              ),
              const SizedBox(height: 14),
              DiaryReveal(
                delay: const Duration(milliseconds: 140),
                child: _SelectionSheet(
                  selectedMood: selectedMood,
                  selectedSpotId: selectedSpotId,
                  spots: spots,
                  onMoodChanged: (mood) => setState(() => selectedMood = mood),
                  onSpotChanged: (spotId) =>
                      setState(() => selectedSpotId = spotId),
                ),
              ),
              const SizedBox(height: 14),
              DiaryReveal(
                delay: const Duration(milliseconds: 220),
                offset: const Offset(0, 0.06),
                child: _WritingPaper(
                  titleController: _titleController,
                  bodyController: _bodyController,
                  weatherController: _weatherController,
                  prompt: _promptForMood(selectedMood),
                  onSubmit: _submit,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PreviewSheet extends StatelessWidget {
  const _PreviewSheet({
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
              tone.withValues(alpha: 0.16),
              Colors.white.withValues(alpha: 0.58),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'today preview',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.seaDeep,
                    letterSpacing: 1.2,
                  ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.56),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(spot.icon, color: AppColors.ink),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('今天会落在 ${spot.name}',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(spot.description,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoPill(label: mood, tone: tone),
                _InfoPill(label: growthPreview, tone: spot.accent),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionSheet extends StatelessWidget {
  const _SelectionSheet({
    required this.selectedMood,
    required this.selectedSpotId,
    required this.spots,
    required this.onMoodChanged,
    required this.onSpotChanged,
  });

  final String selectedMood;
  final String? selectedSpotId;
  final List<IslandSpot> spots;
  final ValueChanged<String> onMoodChanged;
  final ValueChanged<String> onSpotChanged;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('写之前，先定一下今天的语气。', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 14),
          Text('心情', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final mood in const ['轻快', '平静', '想念'])
                ChoiceChip(
                  label: Text(mood),
                  selected: selectedMood == mood,
                  onSelected: (_) => onMoodChanged(mood),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Text('地点', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final spot in spots)
                ChoiceChip(
                  label: Text(spot.name),
                  selected: selectedSpotId == spot.id,
                  onSelected: (_) => onSpotChanged(spot.id),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WritingPaper extends StatelessWidget {
  const _WritingPaper({
    required this.titleController,
    required this.bodyController,
    required this.weatherController,
    required this.prompt,
    required this.onSubmit,
  });

  final TextEditingController titleController;
  final TextEditingController bodyController;
  final TextEditingController weatherController;
  final String prompt;
  final VoidCallback onSubmit;

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
              Colors.white.withValues(alpha: 0.96),
              AppColors.paper.withValues(alpha: 0.98),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              child: Row(
                children: [
                  Text(
                    'journal page',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.seaDeep,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 118,
                    child: TextField(
                      controller: weatherController,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        isDense: true,
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: '天气 / 氛围',
                      ),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.softText,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 6, 18, 0),
              child: Text(
                prompt,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.softText,
                    ),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: '标题，例如：窗边那阵风刚好吹进来',
                ),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 24,
                      color: AppColors.charcoal,
                    ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white.withValues(alpha: 0.42),
              ),
              child: Stack(
                children: [
                  const Positioned.fill(child: _PaperLines()),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
                    child: TextField(
                      controller: bodyController,
                      minLines: 10,
                      maxLines: 12,
                      decoration: const InputDecoration(
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: '写下声音、味道、动作，或者你忽然想起的一小块画面。',
                      ),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.charcoal,
                            height: 1.85,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onSubmit,
                  icon: const Icon(Icons.edit_note_rounded),
                  label: const Text('把今天收进册子'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaperLines extends StatelessWidget {
  const _PaperLines();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PaperLinesPainter(),
    );
  }
}

class _PaperLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.paperLine.withValues(alpha: 0.9)
      ..strokeWidth = 1;

    for (double y = 28; y < size.height; y += 34) {
      canvas.drawLine(
        Offset(12, y),
        Offset(size.width - 12, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
    '想念' => '抓住那个忽然回来的旧画面，写下它为什么又来敲门。',
    '平静' => '写下周围最安静的东西，和你此刻没说出口的感受。',
    _ => '先把今天最亮的一瞬间记下来，哪怕只是一小块。',
  };
}

Color _moodTone(String mood) {
  return switch (mood) {
    '想念' => AppColors.coral,
    '平静' => AppColors.sea,
    _ => AppColors.gold,
  };
}
