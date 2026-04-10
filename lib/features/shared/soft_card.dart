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
    final baseTone = tone ?? AppColors.shell;
    final top = Color.lerp(Colors.white, baseTone, 0.24) ?? Colors.white;
    final bottom = Color.lerp(AppColors.shell, baseTone, 0.58) ?? AppColors.shell;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            top.withValues(alpha: 0.96),
            bottom.withValues(alpha: 0.88),
          ],
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.74)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: child,
    );
  }
}
