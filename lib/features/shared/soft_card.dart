import 'package:flutter/material.dart';

class SoftCard extends StatelessWidget {
  const SoftCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xDFFFF8EB),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26B67E3A),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
