import 'dart:ui';

import 'package:flutter/material.dart';

class AppBackdrop extends StatelessWidget {
  const AppBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF6F1E7),
                    Color(0xFFF1EAE1),
                    Color(0xFFE8EEF1),
                    Color(0xFFD7E5EC),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(
            top: -120,
            left: -40,
            child: _GlowOrb(
              size: 300,
              colors: [
                Color(0x66F7D9B1),
                Color(0x00F7D9B1),
              ],
            ),
          ),
          const Positioned(
            right: -80,
            top: 120,
            child: _GlowOrb(
              size: 260,
              colors: [
                Color(0x55BDD8E8),
                Color(0x00BDD8E8),
              ],
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 110,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                child: Container(
                  height: 120,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.size,
    required this.colors,
  });

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }
}
