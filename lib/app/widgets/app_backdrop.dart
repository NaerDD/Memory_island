import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppBackdrop extends StatelessWidget {
  const AppBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF3D8),
                  Color(0xFFFBECCB),
                  Color(0xFFD6F1EE),
                  Color(0xFFA9DFE6),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: _BackdropPainter(),
            ),
          ),
          Positioned(
            top: -56,
            right: -10,
            child: Container(
              width: 240,
              height: 240,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xE6FFE198),
                    Color(0x4DFFE198),
                    Color(0x00FFE198),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: -70,
            bottom: 180,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x7AE4FFFE),
                    Color(0x14E4FFFE),
                    Color(0x00E4FFFE),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: -44,
            right: -44,
            bottom: 112,
            child: Container(
              height: 132,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(180),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final horizon = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x00FFFFFF),
          Color(0x4CFFFFFF),
          Color(0x00FFFFFF),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final seaBand = Path()
      ..moveTo(0, size.height * 0.58)
      ..quadraticBezierTo(
        size.width * 0.22,
        size.height * 0.53,
        size.width * 0.5,
        size.height * 0.57,
      )
      ..quadraticBezierTo(
        size.width * 0.77,
        size.height * 0.61,
        size.width,
        size.height * 0.55,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      seaBand,
      Paint()..color = AppColors.sea.withValues(alpha: 0.12),
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.25, size.height * 0.36),
        width: size.width * 0.52,
        height: size.height * 0.16,
      ),
      horizon,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.78, size.height * 0.74),
        width: size.width * 0.6,
        height: size.height * 0.18,
      ),
      Paint()..color = AppColors.ink.withValues(alpha: 0.04),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
