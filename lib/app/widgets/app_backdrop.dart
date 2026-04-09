import 'package:flutter/material.dart';

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
                  Color(0xFFFFF4D8),
                  Color(0xFFFFEFCF),
                  Color(0xFFC7F5F0),
                  Color(0xFF91E1F0),
                ],
              ),
            ),
          ),
          Positioned(
            top: -40,
            right: -20,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xE6FFDB65),
                    Color(0x4DFFDB65),
                    Color(0x00FFDB65),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: -50,
            right: -50,
            bottom: 140,
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(160),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
