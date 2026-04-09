import 'package:flutter/material.dart';

import '../shared/app_page.dart';
import '../shared/soft_card.dart';
import '../shared/stubs.dart';

class ComposePage extends StatelessWidget {
  const ComposePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: '投放回忆',
      subtitle: 'Drop a memory',
      badge: '先写最亮的一下',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
        children: const [
          _ComposeCard(),
        ],
      ),
    );
  }
}

class _ComposeCard extends StatelessWidget {
  const _ComposeCard();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('投下一枚新碎片', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          Text('不用完整，先把它留下来。', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 18),
          const InputStub(label: '地点'),
          const SizedBox(height: 12),
          const InputStub(label: '日期'),
          const SizedBox(height: 12),
          const InputStub(label: '标题'),
          const SizedBox(height: 12),
          const AreaStub(label: '写下味道、光线、风，或者一个动作。'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: null,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2FC8C2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('下一轮接入真实表单'),
            ),
          ),
        ],
      ),
    );
  }
}
