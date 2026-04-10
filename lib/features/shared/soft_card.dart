import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

class SoftCard extends StatelessWidget {
  const SoftCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.tone,
    this.radius = 30,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? tone;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final baseTone = tone ?? AppColors.paper;
    final top = Color.lerp(Colors.white, baseTone, 0.18) ?? Colors.white;
    final bottom = Color.lerp(AppColors.paper, baseTone, 0.42) ?? AppColors.paper;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            top.withValues(alpha: 0.96),
            bottom.withValues(alpha: 0.92),
          ],
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.paperLine.withValues(alpha: 0.9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}
