import 'package:flutter/material.dart';

class DiaryReveal extends StatefulWidget {
  const DiaryReveal({
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 0.04),
    this.duration = const Duration(milliseconds: 520),
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Offset offset;
  final Duration duration;

  @override
  State<DiaryReveal> createState() => _DiaryRevealState();
}

class _DiaryRevealState extends State<DiaryReveal> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (mounted) {
        setState(() => _visible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _visible ? Offset.zero : widget.offset,
      duration: widget.duration,
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
