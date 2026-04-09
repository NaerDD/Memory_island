import 'package:flutter/material.dart';

import '../shared/app_page.dart';
import '../shared/section_title.dart';
import '../shared/soft_card.dart';

class IslandPage extends StatelessWidget {
  const IslandPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: '小岛地图',
      subtitle: 'Island map',
      badge: '3 个地点已点亮',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
        children: const [
          _IslandCard(),
          SizedBox(height: 18),
          SectionTitle(label: 'MAP', title: '地点工作台'),
          SizedBox(height: 10),
          _SpotCard(icon: '🏠', title: '童年楼', body: '收纳老房间和放学后的事'),
          SizedBox(height: 10),
          _SpotCard(icon: '🌊', title: '海边', body: '收纳旅行和风的味道'),
          SizedBox(height: 10),
          _SpotCard(icon: '🫧', title: '今天', body: '收纳刚刚发生的小事'),
        ],
      ),
    );
  }
}

class _IslandCard extends StatelessWidget {
  const _IslandCard();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
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
                Positioned(left: 60, bottom: 42, child: _BubbleSpot(icon: '🏠', label: '童年楼')),
                Positioned(left: 150, bottom: 34, child: _BubbleSpot(icon: '🌊', label: '海边')),
                Positioned(right: 64, bottom: 46, child: _BubbleSpot(icon: '🫧', label: '今天')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('把碎片慢慢养成地图。', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            '地点是回忆的落点，回忆越多，岛就越清晰。',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _SpotCard extends StatelessWidget {
  const _SpotCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final String icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 24))),
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
