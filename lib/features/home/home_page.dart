import 'dart:math' as math;

import 'package:flutter/material.dart';

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
      duration: const Duration(milliseconds: 900),
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
        final features = _buildFeatures(widget.store);
        final selected = features.firstWhere(
          (item) => item.id == selectedFeatureId,
          orElse: () => features.first,
        );
        final latestMemory =
            widget.store.memories.isEmpty ? null : widget.store.memories.first;
        final topAnimation = CurvedAnimation(
          parent: _introController,
          curve: const Interval(0, 0.32, curve: Curves.easeOutCubic),
        );
        final islandAnimation = CurvedAnimation(
          parent: _introController,
          curve: const Interval(0.12, 1, curve: Curves.easeOutCubic),
        );

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
                        Color(0xFFF1EBDD),
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
                right: 18,
                child: FadeTransition(
                  opacity: topAnimation,
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
                  opacity: islandAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.04),
                      end: Offset.zero,
                    ).animate(islandAnimation),
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          final lift =
                              math.sin(_floatController.value * math.pi * 2) *
                                  8;
                          return Transform.translate(
                            offset: Offset(0, lift),
                            child: child,
                          );
                        },
                        child: _IslandScene(
                          islandName: widget.store.islandName,
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
              ),
            ],
          ),
        );
      },
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

class _IslandScene extends StatelessWidget {
  const _IslandScene({
    required this.islandName,
    required this.features,
    required this.selectedFeatureId,
    required this.latestMemory,
    required this.onSelectFeature,
    required this.onPrimaryAction,
  });

  final String islandName;
  final List<_IslandFeature> features;
  final String selectedFeatureId;
  final IslandMemory? latestMemory;
  final ValueChanged<String> onSelectFeature;
  final VoidCallback onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    const featurePositions = {
      'lighthouse': Offset(0.77, 0.20),
      'windmill': Offset(0.23, 0.28),
      'palms': Offset(0.20, 0.56),
      'black_soil': Offset(0.65, 0.58),
      'pasture': Offset(0.46, 0.44),
      'red_soil': Offset(0.82, 0.49),
    };
    final selected =
        features.firstWhere((item) => item.id == selectedFeatureId);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = math.min(constraints.maxWidth * 0.94, 420.0);
        final height = width * 0.84;

        return SizedBox(
          width: width,
          height: height + 96,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: width * 0.08,
                right: width * 0.08,
                bottom: 8,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0x1B0D6A60),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x18000000),
                        blurRadius: 28,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                ),
              ),
              CustomPaint(
                size: Size(width, height),
                painter: _IslandPainter(),
              ),
              for (final feature in features)
                Positioned(
                  left: width * featurePositions[feature.id]!.dx - 34,
                  top: height * featurePositions[feature.id]!.dy - 30,
                  child: _FeatureNode(
                    feature: feature,
                    selected: feature.id == selectedFeatureId,
                    onTap: () => onSelectFeature(feature.id),
                  ),
                ),
              Positioned(
                left: 16,
                top: 18,
                child: _IslandNameRibbon(label: islandName),
              ),
              Positioned(
                left: 14,
                right: 14,
                bottom: -8,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  child: _FeatureBubble(
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

class _IslandNameRibbon extends StatelessWidget {
  const _IslandNameRibbon({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.06,
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

class _FeatureNode extends StatelessWidget {
  const _FeatureNode({
    required this.feature,
    required this.selected,
    required this.onTap,
  });

  final _IslandFeature feature;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tone = feature.unlocked ? feature.accent : const Color(0xFFB8AC99);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: selected ? 1.08 : 1,
        child: Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color:
                selected ? Colors.white : Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected ? tone : Colors.white,
              width: selected ? 2 : 1.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x18000000),
                blurRadius: 16,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: CustomPaint(
                  size: const Size(34, 34),
                  painter: _FeaturePainter(
                    kind: feature.kind,
                    color: tone,
                  ),
                ),
              ),
              if (!feature.unlocked)
                const Positioned(
                  right: 7,
                  top: 7,
                  child: Icon(
                    Icons.lock_rounded,
                    size: 14,
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

class _FeatureBubble extends StatelessWidget {
  const _FeatureBubble({
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
      _PrimaryAction.islands => '去岛屿页',
    };

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: const Color(0xFDFEFBF4),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFF0E4D3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                feature.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.charcoal,
                    ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: feature.unlocked
                      ? feature.accent.withValues(alpha: 0.14)
                      : const Color(0xFFF1E7D9),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  feature.unlocked ? '已开放' : '待解锁',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.charcoal,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            feature.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.softText,
                  height: 1.6,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _BubbleTag(label: feature.progressText, tone: feature.accent),
              if (latestMemory != null)
                _BubbleTag(
                  label: '最近落笔：${latestMemory!.spotName}',
                  tone: AppColors.seaDeep,
                ),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: onPrimaryAction,
              child: Text(actionText),
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleTag extends StatelessWidget {
  const _BubbleTag({
    required this.label,
    required this.tone,
  });

  final String label;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
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

class _IslandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 12);
    final shadow = Paint()
      ..color = const Color(0x220D685D)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + 50),
        width: size.width * 0.76,
        height: size.height * 0.18,
      ),
      shadow,
    );

    final sea = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF87D7DB),
          Color(0xFF56BFC8),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: size.width * 0.88,
        height: size.height * 0.82,
      ),
      sea,
    );

    final sandPath = Path()
      ..moveTo(size.width * 0.14, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.08, size.height * 0.34,
          size.width * 0.24, size.height * 0.18)
      ..quadraticBezierTo(size.width * 0.38, size.height * 0.06,
          size.width * 0.58, size.height * 0.14)
      ..quadraticBezierTo(size.width * 0.84, size.height * 0.2,
          size.width * 0.88, size.height * 0.42)
      ..quadraticBezierTo(size.width * 0.92, size.height * 0.62,
          size.width * 0.72, size.height * 0.74)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.88,
          size.width * 0.28, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.16, size.height * 0.72,
          size.width * 0.14, size.height * 0.6)
      ..close();
    canvas.drawPath(sandPath, Paint()..color = const Color(0xFFF5D69A));

    final grassPath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.58)
      ..quadraticBezierTo(size.width * 0.18, size.height * 0.36,
          size.width * 0.28, size.height * 0.24)
      ..quadraticBezierTo(size.width * 0.42, size.height * 0.12,
          size.width * 0.58, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.78, size.height * 0.26,
          size.width * 0.8, size.height * 0.42)
      ..quadraticBezierTo(size.width * 0.82, size.height * 0.58,
          size.width * 0.66, size.height * 0.68)
      ..quadraticBezierTo(size.width * 0.46, size.height * 0.8,
          size.width * 0.3, size.height * 0.72)
      ..quadraticBezierTo(size.width * 0.22, size.height * 0.66,
          size.width * 0.2, size.height * 0.58)
      ..close();
    canvas.drawPath(
      grassPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF99DB7A),
            Color(0xFF6BC269),
          ],
        ).createShader(Offset.zero & size),
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.68, size.height * 0.58),
        width: size.width * 0.18,
        height: size.height * 0.12,
      ),
      Paint()..color = const Color(0xFF4F392B),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.82, size.height * 0.5),
        width: size.width * 0.14,
        height: size.height * 0.1,
      ),
      Paint()..color = const Color(0xFFA45A43),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.48, size.height * 0.44),
        width: size.width * 0.16,
        height: size.height * 0.11,
      ),
      Paint()..color = const Color(0xFFCDE4B3),
    );

    final pathPaint = Paint()
      ..color = const Color(0xFFD5B57F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final route = Path()
      ..moveTo(size.width * 0.28, size.height * 0.58)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.46,
          size.width * 0.52, size.height * 0.44)
      ..quadraticBezierTo(size.width * 0.62, size.height * 0.42,
          size.width * 0.72, size.height * 0.28);
    canvas.drawPath(route, pathPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FeaturePainter extends CustomPainter {
  const _FeaturePainter({
    required this.kind,
    required this.color,
  });

  final _FeatureKind kind;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    switch (kind) {
      case _FeatureKind.lighthouse:
        _paintLighthouse(canvas, size);
      case _FeatureKind.windmill:
        _paintWindmill(canvas, size);
      case _FeatureKind.palms:
        _paintPalms(canvas, size);
      case _FeatureKind.field:
        _paintField(canvas, size, dark: true);
      case _FeatureKind.pasture:
        _paintPasture(canvas, size);
      case _FeatureKind.redField:
        _paintField(canvas, size, dark: false);
    }
  }

  void _paintLighthouse(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.34, size.height * 0.18, size.width * 0.22,
            size.height * 0.48),
        const Radius.circular(5),
      ),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.34, size.height * 0.32, size.width * 0.22,
          size.height * 0.1),
      Paint()..color = color,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.28, size.height * 0.14, size.width * 0.34,
          size.height * 0.06),
      Paint()..color = color,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.36, size.height * 0.66, size.width * 0.18,
          size.height * 0.1),
      Paint()..color = const Color(0xFF7B6450),
    );
  }

  void _paintWindmill(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.46, size.height * 0.28, size.width * 0.08,
          size.height * 0.42),
      Paint()..color = const Color(0xFF816952),
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.3),
      3,
      Paint()..color = color,
    );
    for (final angle in [0.0, math.pi / 2, math.pi, math.pi * 1.5]) {
      final path = Path()
        ..moveTo(size.width * 0.5, size.height * 0.3)
        ..lineTo(
          size.width * 0.5 + math.cos(angle - 0.22) * 10,
          size.height * 0.3 + math.sin(angle - 0.22) * 10,
        )
        ..lineTo(
          size.width * 0.5 + math.cos(angle) * 15,
          size.height * 0.3 + math.sin(angle) * 15,
        )
        ..close();
      canvas.drawPath(path, Paint()..color = color.withValues(alpha: 0.92));
    }
  }

  void _paintPalms(Canvas canvas, Size size) {
    final leaves = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (final x in [0.36, 0.58]) {
      canvas.drawRect(
        Rect.fromLTWH(size.width * x, size.height * 0.38, size.width * 0.06,
            size.height * 0.28),
        Paint()..color = const Color(0xFF87644D),
      );
      for (final offset in [-0.7, -0.25, 0.25, 0.7]) {
        final path = Path()
          ..moveTo(size.width * (x + 0.03), size.height * 0.38)
          ..quadraticBezierTo(
            size.width * (x + 0.03 + offset * 0.18),
            size.height * 0.24,
            size.width * (x + 0.03 + offset * 0.28),
            size.height * 0.34,
          );
        canvas.drawPath(path, leaves);
      }
    }
  }

  void _paintField(Canvas canvas, Size size, {required bool dark}) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.18, size.height * 0.3, size.width * 0.64,
            size.height * 0.42),
        const Radius.circular(8),
      ),
      Paint()..color = dark ? const Color(0xFF4C382B) : const Color(0xFFA55B43),
    );
    final line = Paint()
      ..color = Colors.white.withValues(alpha: 0.24)
      ..strokeWidth = 2;
    for (var i = 1; i < 4; i++) {
      final y = size.height * (0.3 + i * 0.1);
      canvas.drawLine(
        Offset(size.width * 0.22, y),
        Offset(size.width * 0.78, y),
        line,
      );
    }
  }

  void _paintPasture(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.16, size.height * 0.34, size.width * 0.68,
          size.height * 0.3),
      Paint()..color = const Color(0xFFBEE39B),
    );
    final fence = Paint()
      ..color = const Color(0xFF87644D)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.56),
      Offset(size.width * 0.8, size.height * 0.56),
      fence,
    );
    for (final x in [0.24, 0.4, 0.56, 0.72]) {
      canvas.drawLine(
        Offset(size.width * x, size.height * 0.48),
        Offset(size.width * x, size.height * 0.62),
        fence,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

List<_IslandFeature> _buildFeatures(MemoryLandStore store) {
  final memoryCount = store.totalMemories;
  final spotCount = store.totalSpots;

  return [
    const _IslandFeature(
      id: 'lighthouse',
      title: '灯塔',
      description: '主岛的第一座建筑。每写下一篇回忆，灯就会亮一点。',
      progressText: '初始建筑，已开放',
      unlocked: true,
      accent: Color(0xFFFFB55F),
      kind: _FeatureKind.lighthouse,
      primaryAction: _PrimaryAction.compose,
    ),
    _IslandFeature(
      id: 'windmill',
      title: '风车',
      description: '累计 2 篇回忆后解锁。风车转起来，岛就不再静止。',
      progressText: memoryCount >= 2 ? '风车已经开始转动' : '还差 ${2 - memoryCount} 篇回忆',
      unlocked: memoryCount >= 2,
      accent: const Color(0xFF77C0EB),
      kind: _FeatureKind.windmill,
      primaryAction: _PrimaryAction.compose,
    ),
    _IslandFeature(
      id: 'palms',
      title: '椰子林',
      description: '地点数达到 3 个时，主岛会长出第一片椰子林。',
      progressText: spotCount >= 3 ? '椰子林已经长出来' : '还差 ${3 - spotCount} 个地点',
      unlocked: spotCount >= 3,
      accent: const Color(0xFF63B969),
      kind: _FeatureKind.palms,
      primaryAction: _PrimaryAction.compose,
    ),
    _IslandFeature(
      id: 'black_soil',
      title: '黑土地',
      description: '累计 4 篇回忆后解锁黑土地，适合种会反复回来的旧记忆。',
      progressText: memoryCount >= 4 ? '黑土地可以开垦了' : '还差 ${4 - memoryCount} 篇回忆',
      unlocked: memoryCount >= 4,
      accent: const Color(0xFF6C5140),
      kind: _FeatureKind.field,
      primaryAction: _PrimaryAction.compose,
    ),
    _IslandFeature(
      id: 'pasture',
      title: '牧场',
      description: '累计 6 篇回忆后，主岛旁会分出牧场区。',
      progressText: memoryCount >= 6 ? '牧场入口已准备好' : '还差 ${6 - memoryCount} 篇回忆',
      unlocked: memoryCount >= 6,
      accent: const Color(0xFF9EC97B),
      kind: _FeatureKind.pasture,
      primaryAction: _PrimaryAction.islands,
    ),
    const _IslandFeature(
      id: 'red_soil',
      title: '红土地',
      description: '更高等级的副岛内容，适合放稀有和长期经营的主题。',
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
    required this.description,
    required this.progressText,
    required this.unlocked,
    required this.accent,
    required this.kind,
    required this.primaryAction,
  });

  final String id;
  final String title;
  final String description;
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
