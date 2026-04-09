import 'package:flutter/material.dart';

import '../shared/app_page.dart';
import '../shared/soft_card.dart';
import '../shared/stubs.dart';

class MemoryPage extends StatelessWidget {
  const MemoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: '回忆宝箱',
      subtitle: 'Treasure box',
      badge: '按情绪翻找',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
        children: const [
          _FilterCard(),
          SizedBox(height: 18),
          _MemoryCard(
            category: '童年楼',
            date: '2026.04.09',
            title: '楼下小卖部门口的风',
            body: '只是想起了玻璃汽水的声音和太阳快落下去那一段。',
          ),
          SizedBox(height: 10),
          _MemoryCard(
            category: '海边',
            date: '2026.04.08',
            title: '我把拖鞋提在手上走回去',
            body: '脚底都是潮湿的沙，走得很慢。',
          ),
        ],
      ),
    );
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        children: const [
          InputStub(label: '搜标题、内容或地点'),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: InputStub(label: '日期')),
              SizedBox(width: 10),
              Expanded(child: ChipStub(label: '怀念')),
              SizedBox(width: 10),
              Expanded(child: ChipStub(label: '平静')),
            ],
          ),
        ],
      ),
    );
  }
}

class _MemoryCard extends StatelessWidget {
  const _MemoryCard({
    required this.category,
    required this.date,
    required this.title,
    required this.body,
  });

  final String category;
  final String date;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                category,
                style: const TextStyle(
                  color: Color(0xFF6E8798),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                date,
                style: const TextStyle(
                  color: Color(0xFF6E8798),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          const Row(
            children: [
              ChipStub(label: '编辑'),
              SizedBox(width: 8),
              ChipStub(label: '删除'),
            ],
          ),
        ],
      ),
    );
  }
}
