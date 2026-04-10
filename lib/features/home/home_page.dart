import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/model/island_memory.dart';
import '../../app/state/memory_land_store.dart';
import '../../app/theme/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.store,
    required this.onOpenCompose,
    required this.onOpenIsland,
    required this.onOpenMemories,
    super.key,
  });

  final MemoryLandStore store;
  final VoidCallback onOpenCompose;
  final VoidCallback onOpenIsland;
  final VoidCallback onOpenMemories;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _floatController;
  String selectedFeatureId = 'lighthouse';

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 840),
    )..forward();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _introController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final features = _featuresForStore(widget.store);
        final selected = features.firstWhere(
          (item) => item.id == selectedFeatureId,
          orElse: () => features.first,
        );
        final latestMemory =
            widget.store.memories.isEmpty ? null : widget.store.memories.first;

        return SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFF8F2E8),
                        Color(0xFFF2ECE0),
                        Color(0xFFE8EFE8),
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned.fill(
                child: CustomPaint(
                  painter: _SeaSkyPainter(),
                ),
              ),
              Positioned(
                top: 14,
                left: 18,
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _introController,
                    curve: Curves.easeOutCubic,
                  ),
                  child: _IslandRibbon(label: widget.store.islandName),
                ),
              ),
              Positioned(
                top: 14,
                right: 18,
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _introController,
                    curve: Curves.easeOutCubic,
                  ),
                  child: Row(
                    children: [
                      _CornerButton(
                        icon: Icons.auto_stories_rounded,
                        onTap: widget.onOpenMemories,
                      ),
                      const SizedBox(width: 10),
                      _CornerButton(
                        icon: Icons.landscape_rounded,
                        onTap: widget.onOpenIsland,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _introController,
                    curve: const Interval(0.14, 1, curve: Curves.easeOutCubic),
                  ),
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _floatController,
                      builder: (context, child) {
                        final lift =
                            math.sin(_floatController.value * math.pi * 2) * 6;
                        return Transform.translate(
                          offset: Offset(0, lift),
                          child: child,
                        );
                      },
                      child: _IslandStage(
                        features: features,
                        selectedFeatureId: selected.id,
                        latestMemory: latestMemory,
                        onSelectFeature: (id) =>
                            setState(() => selectedFeatureId = id),
                        onPrimaryAction:
                            selected.primaryAction == _PrimaryAction.compose
                                ? widget.onOpenCompose
                                : widget.onOpenIsland,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _IslandStage extends StatelessWidget {
  const _IslandStage({
    required this.features,
    required this.selectedFeatureId,
    required this.latestMemory,
    required this.onSelectFeature,
    required this.onPrimaryAction,
  });

  final List<_IslandFeature> features;
  final String selectedFeatureId;
  final IslandMemory? latestMemory;
  final ValueChanged<String> onSelectFeature;
  final VoidCallback onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    const positions = {
      'lighthouse': Offset(0.78, 0.22),
      'windmill': Offset(0.24, 0.3),
      'palms': Offset(0.23, 0.58),
      'black_soil': Offset(0.63, 0.58),
      'pasture': Offset(0.47, 0.46),
      'red_soil': Offset(0.8, 0.49),
    };
    final selected =
        features.firstWhere((item) => item.id == selectedFeatureId);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = math.min(constraints.maxWidth * 0.9, 360.0);
        final height = width * 0.94;
        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: width * 0.1,
                right: width * 0.1,
                bottom: 16,
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0x180B665E),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Positioned(
                left: width * 0.02,
                right: width * 0.02,
                top: height * 0.08,
                child: Transform.rotate(
                  angle: -0.02,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.matrix([
                      0.24,
                      0.52,
                      0.18,
                      0,
                      36,
                      0.18,
                      0.60,
                      0.16,
                      0,
                      50,
                      0.12,
                      0.32,
                      0.08,
                      0,
                      20,
                      0,
                      0,
                      0,
                      1,
                      0,
                    ]),
                    child: SvgPicture.asset(
                      'assets/illustrations/island.svg',
                      width: width * 0.92,
                      height: height * 0.74,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: width * 0.14,
                right: width * 0.14,
                top: height * 0.12,
                child: IgnorePointer(
                  child: Container(
                    height: height * 0.56,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          const Color(0x2D93D9D9),
                          const Color(0x1098D1D1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              for (final feature in features)
                Positioned(
                  left: width * positions[feature.id]!.dx - 18,
                  top: height * positions[feature.id]!.dy - 18,
                  child: _FeatureDot(
                    feature: feature,
                    selected: feature.id == selectedFeatureId,
                    onTap: () => onSelectFeature(feature.id),
                  ),
                ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 0,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: _IslandFloatTag(
                    key: ValueKey(selected.id),
                    feature: selected,
                    latestMemory: latestMemory,
                    onPrimaryAction: onPrimaryAction,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FeatureDot extends StatelessWidget {
  const _FeatureDot({
    required this.feature,
    required this.selected,
    required this.onTap,
  });

  final _IslandFeature feature;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tone = feature.unlocked ? feature.accent : const Color(0xFFBCB1A1);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: selected ? 1.04 : 1,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? tone : Colors.white,
              width: selected ? 1.8 : 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: _FeatureGlyph(
                  feature: feature,
                  tone: tone,
                ),
              ),
              if (!feature.unlocked)
                const Positioned(
                  right: 3,
                  top: 3,
                  child: Icon(
                    Icons.lock_rounded,
                    size: 10,
                    color: AppColors.charcoal,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureGlyph extends StatelessWidget {
  const _FeatureGlyph({
    required this.feature,
    required this.tone,
  });

  final _IslandFeature feature;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    switch (feature.kind) {
      case _FeatureKind.lighthouse:
        return _SvgGlyph(
          asset: 'assets/illustrations/lighthouse.svg',
          tone: tone,
        );
      case _FeatureKind.windmill:
        return _SvgGlyph(
          asset: 'assets/illustrations/windmill.svg',
          tone: tone,
        );
      case _FeatureKind.palms:
        return _SvgGlyph(
          asset: 'assets/illustrations/palm-tree.svg',
          tone: tone,
        );
      case _FeatureKind.field:
        return Icon(Icons.grid_view_rounded, size: 16, color: tone);
      case _FeatureKind.pasture:
        return Icon(Icons.agriculture_rounded, size: 16, color: tone);
      case _FeatureKind.redField:
        return Icon(Icons.terrain_rounded, size: 16, color: tone);
    }
  }
}

class _SvgGlyph extends StatelessWidget {
  const _SvgGlyph({
    required this.asset,
    required this.tone,
  });

  final String asset;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: 18,
      height: 18,
      colorFilter: ColorFilter.mode(tone, BlendMode.srcIn),
    );
  }
}

class _IslandFloatTag extends StatelessWidget {
  const _IslandFloatTag({
    required this.feature,
    required this.latestMemory,
    required this.onPrimaryAction,
    super.key,
  });

  final _IslandFeature feature;
  final IslandMemory? latestMemory;
  final VoidCallback onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    final actionText = switch (feature.primaryAction) {
      _PrimaryAction.compose => '写今天',
      _PrimaryAction.islands => '岛屿页',
    };

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: const Color(0xFDFEFBF4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0E4D3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.charcoal,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  latestMemory != null
                      ? latestMemory!.title
                      : feature.progressText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.softText,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          FilledButton(
            onPressed: onPrimaryAction,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              minimumSize: Size.zero,
            ),
            child: Text(actionText),
          ),
        ],
      ),
    );
  }
}

class _IslandRibbon extends StatelessWidget {
  const _IslandRibbon({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.04,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBF3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF1E3D1)),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.charcoal,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}

class _CornerButton extends StatelessWidget {
  const _CornerButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.56),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.94)),
          ),
          child: Icon(icon, size: 18, color: AppColors.ink),
        ),
      ),
    );
  }
}

class _SeaSkyPainter extends CustomPainter {
  const _SeaSkyPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final warm = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0x32FFD7AF),
          Color(0x14F5E6CF),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.76, size.height * 0.2),
          radius: size.width * 0.46,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.76, size.height * 0.2),
      size.width * 0.46,
      warm,
    );

    final cool = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0x24B6E0E2),
          Color(0x0FE1EFEB),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.1, size.height * 0.84),
          radius: size.width * 0.5,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.84),
      size.width * 0.5,
      cool,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

List<_IslandFeature> _featuresForStore(MemoryLandStore store) {
  final memoryCount = store.totalMemories;
  final spotCount = store.totalSpots;
  return [
    const _IslandFeature(
      id: 'lighthouse',
      title: '灯塔',
      progressText: '初始建筑，已开放',
      unlocked: true,
      accent: Color(0xFFFFB55F),
      kind: _FeatureKind.lighthouse,
      primaryAction: _PrimaryAction.compose,
    ),
    _IslandFeature(
      id: 'windmill',
      title: '风车',
      progressText: memoryCount >= 2 ? '风车已经开始转动' : '还差 ${2 - memoryCount} 篇回忆',
      unlocked: memoryCount >= 2,
      accent: const Color(0xFF77C0EB),
      kind: _FeatureKind.windmill,
      primaryAction: _PrimaryAction.compose,
    ),
    _IslandFeature(
      id: 'palms',
      title: '椰林',
      progressText: spotCount >= 3 ? '椰林已经长出来' : '还差 ${3 - spotCount} 个地点',
      unlocked: spotCount >= 3,
      accent: const Color(0xFF63B969),
      kind: _FeatureKind.palms,
      primaryAction: _PrimaryAction.compose,
    ),
    _IslandFeature(
      id: 'black_soil',
      title: '黑土地',
      progressText: memoryCount >= 4 ? '可以开垦了' : '还差 ${4 - memoryCount} 篇回忆',
      unlocked: memoryCount >= 4,
      accent: const Color(0xFF6C5140),
      kind: _FeatureKind.field,
      primaryAction: _PrimaryAction.compose,
    ),
    _IslandFeature(
      id: 'pasture',
      title: '牧场',
      progressText: memoryCount >= 6 ? '牧场入口已准备好' : '还差 ${6 - memoryCount} 篇回忆',
      unlocked: memoryCount >= 6,
      accent: const Color(0xFF9EC97B),
      kind: _FeatureKind.pasture,
      primaryAction: _PrimaryAction.islands,
    ),
    const _IslandFeature(
      id: 'red_soil',
      title: '红土地',
      progressText: '多岛计划开启后解锁',
      unlocked: false,
      accent: Color(0xFFB86449),
      kind: _FeatureKind.redField,
      primaryAction: _PrimaryAction.islands,
    ),
  ];
}

class _IslandFeature {
  const _IslandFeature({
    required this.id,
    required this.title,
    required this.progressText,
    required this.unlocked,
    required this.accent,
    required this.kind,
    required this.primaryAction,
  });

  final String id;
  final String title;
  final String progressText;
  final bool unlocked;
  final Color accent;
  final _FeatureKind kind;
  final _PrimaryAction primaryAction;
}

enum _FeatureKind {
  lighthouse,
  windmill,
  palms,
  field,
  pasture,
  redField,
}

enum _PrimaryAction {
  compose,
  islands,
}
