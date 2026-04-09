import 'package:flutter/material.dart';

import '../shared/app_page.dart';
import '../shared/section_title.dart';
import '../shared/soft_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: '回忆岛',
      subtitle: 'Sunny mode',
      badge: '今天适合捡回忆',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
        children: const [
          _HeroCard(),
          SizedBox(height: 18),
          _StatsRow(),
          SizedBox(height: 18),
          SectionTitle(label: 'PLAY', title: '下一步做什么'),
          SizedBox(height: 10),
          _ActionCard(
            tag: '最快',
            title: '投下一条新回忆',
            body: '一句也可以，先把它留下来。',
          ),
          SizedBox(height: 10),
          _ActionCard(
            tag: '地图',
            title: '给小岛添一个地点',
            body: '让回忆有落点。',
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFEBB0),
                  Color(0xFFB5EEF2),
                  Color(0xFF54C7D7),
                ],
              ),
            ),
            child: Stack(
              children: const [
                Positioned(left: 24, top: 40, child: _BubbleSpot(icon: '🏠', label: '童年')),
                Positioned(right: 24, top: 70, child: _BubbleSpot(icon: '🌊', label: '海边')),
                Positioned(left: 120, bottom: 18, child: _BubbleSpot(icon: '🫧', label: '今天')),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('今天，捡一枚回忆上岛。', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 10),
          Text(
            '先写一句。先投下去。以后再回来补。',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _StatCard(value: '24', label: '已上岛')),
        SizedBox(width: 10),
        Expanded(child: _StatCard(value: '3', label: '地点')),
        SizedBox(width: 10),
        Expanded(child: _StatCard(value: '5', label: '待补写')),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF224158),
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.tag,
    required this.title,
    required this.body,
  });

  final String tag;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF224158),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(body, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleSpot extends StatelessWidget {
  const _BubbleSpot({required this.icon, required this.label});

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF224158),
            ),
          ),
        ],
      ),
    );
  }
}
