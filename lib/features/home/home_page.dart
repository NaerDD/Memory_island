import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/state/memory_land_store.dart';
import '../shared/app_page.dart';

class HomePage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return AppPage(
          title: store.islandName,
          subtitle: 'Annual memory island',
          badge: store.islandCapacityLabel,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
            child: _IslandScene(
              store: store,
              onOpenCompose: onOpenCompose,
              onOpenMemories: onOpenMemories,
            ),
          ),
        );
      },
    );
  }
}

class _IslandScene extends StatelessWidget {
  const _IslandScene({
    required this.store,
    required this.onOpenCompose,
    required this.onOpenMemories,
  });

  final MemoryLandStore store;
  final VoidCallback onOpenCompose;
  final VoidCallback onOpenMemories;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final sceneHeight = math.max(560.0, constraints.maxHeight);
        final months = store.monthAnchors;
        final centerX = width * 0.5;
        final centerY = sceneHeight * 0.39;
        final routeX = width * 0.39;
        final routeY = sceneHeight * 0.25;

        return SizedBox(
          height: sceneHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFC8F3FF),
                        Color(0xFF7CDAEA),
                        Color(0xFF2FB6D0),
                        Color(0xFF188FAA),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: _SeaDepthPainter(),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: _RingRoutePainter(
                    center: Offset(centerX, centerY),
                    radiusX: routeX,
                    radiusY: routeY,
                  ),
                ),
              ),
              Positioned(
                left: 18,
                top: 18,
                child: _ScenePill(
                  icon: Icons.liquor_rounded,
                  label: '${store.totalMemories}/${store.islandCapacity}',
                ),
              ),
              Positioned(
                right: 18,
                top: 18,
                child: _ScenePill(
                  icon: Icons.workspace_premium_rounded,
                  label: store.isPremium ? '已解锁多岛' : '单岛模式',
                ),
              ),
              for (var index = 0; index < months.length; index++)
                Positioned(
                  left: centerX + routeX * math.cos((-90 + index * 30) * math.pi / 180) - 24,
                  top: centerY + routeY * math.sin((-90 + index * 30) * math.pi / 180) - 24,
                  child: _MonthMarker(
                    month: months[index],
                    onTap: onOpenMemories,
                  ),
                ),
              Positioned(
                left: width * 0.12,
                right: width * 0.12,
                top: sceneHeight * 0.23,
                child: _Island3DMonolith(progress: store.islandProgress),
              ),
              Positioned(
                left: width * 0.16,
                right: width * 0.16,
                bottom: 36,
                child: Column(
                  children: [
                    Text(
                      '一座岛，存一年的回忆',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: const Color(0xFF13384A),
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '环岛一圈是 12 个月。把今天的记忆装进漂流瓶，放进海里，它会自己靠岸。',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: const Color(0xCC224158),
                          ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: onOpenCompose,
                        child: const Text('放一只漂流瓶'),
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

class _Island3DMonolith extends StatelessWidget {
  const _Island3DMonolith({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.06,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 0,
            left: 26,
            right: 26,
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0x3313384A),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Positioned(
            bottom: 28,
            child: Transform.translate(
              offset: const Offset(8, 38),
              child: Transform.scale(
                scaleY: 0.8,
                child: ClipPath(
                  clipper: HainanIslandClipper(),
                  child: Container(
                    width: 254,
                    height: 214,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF43893B),
                          Color(0xFF2F6C2A),
                          Color(0xFF214F21),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 58,
            child: ClipPath(
              clipper: HainanIslandClipper(),
              child: Container(
                width: 254,
                height: 214,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF4E2A1),
                      Color(0xFFB9D97D),
                      Color(0xFF73C25D),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 54,
                      top: 72,
                      child: Container(
                        width: 78,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFA6E8F6),
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1A224158),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 36,
                      bottom: 42,
                      child: Container(
                        width: 64,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6D891),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 92,
                      top: 38,
                      child: Container(
                        width: 54,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD5EDAF),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 38,
            child: Container(
              width: 176,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.78),
                borderRadius: BorderRadius.circular(999),
              ),
              child: FractionallySizedBox(
                widthFactor: (progress * 18).clamp(0.08, 1),
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFFBE73),
                        Color(0xFFFF8A5B),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HainanIslandClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.12);
    path.cubicTo(
      size.width * 0.36,
      size.height * 0.02,
      size.width * 0.64,
      size.height * 0.04,
      size.width * 0.78,
      size.height * 0.18,
    );
    path.cubicTo(
      size.width * 0.94,
      size.height * 0.28,
      size.width * 0.95,
      size.height * 0.5,
      size.width * 0.86,
      size.height * 0.68,
    );
    path.cubicTo(
      size.width * 0.78,
      size.height * 0.88,
      size.width * 0.62,
      size.height * 0.97,
      size.width * 0.46,
      size.height * 0.95,
    );
    path.cubicTo(
      size.width * 0.28,
      size.height * 0.95,
      size.width * 0.12,
      size.height * 0.8,
      size.width * 0.1,
      size.height * 0.58,
    );
    path.cubicTo(
      size.width * 0.02,
      size.height * 0.38,
      size.width * 0.06,
      size.height * 0.2,
      size.width * 0.2,
      size.height * 0.12,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _ScenePill extends StatelessWidget {
  const _ScenePill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF224158)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF224158),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthMarker extends StatelessWidget {
  const _MonthMarker({
    required this.month,
    required this.onTap,
  });

  final MonthAnchor month;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = month.count > 0;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white.withValues(alpha: 0.42),
            borderRadius: BorderRadius.circular(18),
            boxShadow: active
                ? const [
                    BoxShadow(
                      color: Color(0x26349BB2),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${month.month}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF224158),
                ),
              ),
              Text(
                '${month.count}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: active ? const Color(0xFF224158) : const Color(0xFF6E8798),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SeaDepthPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0x20FFFFFF);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.24),
        width: size.width * 0.88,
        height: size.height * 0.28,
      ),
      paint,
    );
    paint.color = const Color(0x18224158);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.76),
        width: size.width * 1.1,
        height: size.height * 0.32,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RingRoutePainter extends CustomPainter {
  const _RingRoutePainter({
    required this.center,
    required this.radiusX,
    required this.radiusY,
  });

  final Offset center;
  final double radiusX;
  final double radiusY;

  @override
  void paint(Canvas canvas, Size size) {
    final routePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0x7FFFFFFF);

    const dash = 12.0;
    const gap = 10.0;
    final path = Path()
      ..addOval(
        Rect.fromCenter(
          center: center,
          width: radiusX * 2,
          height: radiusY * 2,
        ),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = math.min(distance + dash, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), routePaint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RingRoutePainter oldDelegate) {
    return oldDelegate.center != center ||
        oldDelegate.radiusX != radiusX ||
        oldDelegate.radiusY != radiusY;
  }
}
