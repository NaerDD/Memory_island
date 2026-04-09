import 'package:flutter/material.dart';

void main() {
  runApp(const MemoryLandApp());
}

class MemoryLandApp extends StatelessWidget {
  const MemoryLandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memory Land',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF4D8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2FC8C2),
          brightness: Brightness.light,
          primary: const Color(0xFF2FC8C2),
          secondary: const Color(0xFF3B8CFF),
          surface: const Color(0xFFFFF8EB),
        ),
      ),
      home: const ShellPage(),
    );
  }
}

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int currentIndex = 0;

  final pages = const [
    HomePage(),
    IslandPage(),
    MemoryPage(),
    ComposePage(),
  ];

  final items = const [
    _TabItem('沙滩', Icons.beach_access_rounded),
    _TabItem('小岛', Icons.landscape_rounded),
    _TabItem('宝箱', Icons.auto_awesome_rounded),
    _TabItem('投放', Icons.edit_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            child: KeyedSubtree(
              key: ValueKey(currentIndex),
              child: pages[currentIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xF7FFF9EE),
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Color(0x26B67E3A),
                blurRadius: 28,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: List.generate(items.length, (index) {
                final item = items[index];
                final selected = index == currentIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => currentIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: selected
                            ? const LinearGradient(
                                colors: [Color(0x472FC8C2), Color(0x59FFB74F)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.icon,
                            color: selected
                                ? const Color(0xFF224158)
                                : const Color(0xFF7890A0),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                              color: selected
                                  ? const Color(0xFF224158)
                                  : const Color(0xFF7890A0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

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
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: '回忆岛',
      subtitle: 'Sunny mode',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
        children: const [
          HeroCard(),
          SizedBox(height: 18),
          StatsRow(),
          SizedBox(height: 18),
          SectionTitle(label: 'PLAY', title: '下一步做什么'),
          SizedBox(height: 10),
          ActionCard(
            tag: '最快',
            title: '投下一条新回忆',
            body: '一句也可以，先把它留下来。',
          ),
          SizedBox(height: 10),
          ActionCard(
            tag: '地图',
            title: '给小岛添一个地点',
            body: '让回忆有落点。',
          ),
        ],
      ),
    );
  }
}

class IslandPage extends StatelessWidget {
  const IslandPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: '小岛地图',
      subtitle: 'Island map',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
        children: const [
          IslandCard(),
          SizedBox(height: 18),
          SectionTitle(label: 'MAP', title: '地点工作台'),
          SizedBox(height: 10),
          SpotCard(icon: '🏠', title: '童年楼', body: '收纳老房间和放学后的事'),
          SizedBox(height: 10),
          SpotCard(icon: '🌊', title: '海边', body: '收纳旅行和风的味道'),
          SizedBox(height: 10),
          SpotCard(icon: '🫧', title: '今天', body: '收纳刚刚发生的小事'),
        ],
      ),
    );
  }
}

class MemoryPage extends StatelessWidget {
  const MemoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: '回忆宝箱',
      subtitle: 'Treasure box',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
        children: const [
          FilterCard(),
          SizedBox(height: 18),
          MemoryCard(
            category: '童年楼',
            date: '2026.04.09',
            title: '楼下小卖部门口的风',
            body: '只是想起了玻璃汽水的声音和太阳快落下去那一段。',
          ),
          SizedBox(height: 10),
          MemoryCard(
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

class ComposePage extends StatelessWidget {
  const ComposePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: '投放回忆',
      subtitle: 'Drop a memory',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
        children: const [
          ComposeCard(),
        ],
      ),
    );
  }
}

class AppPage extends StatelessWidget {
  const AppPage({
    required this.title,
    required this.subtitle,
    required this.child,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFFFFD96B),
                  child: Icon(Icons.wb_sunny_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF224158),
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6E8798),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.62),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'iPhone 优先',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF224158),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class HeroCard extends StatelessWidget {
  const HeroCard({super.key});

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
                Positioned(left: 24, top: 40, child: BubbleSpot(icon: '🏠', label: '童年')),
                Positioned(right: 24, top: 70, child: BubbleSpot(icon: '🌊', label: '海边')),
                Positioned(left: 120, bottom: 18, child: BubbleSpot(icon: '🫧', label: '今天')),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            '今天，捡一枚回忆上岛。',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color(0xFF224158),
              height: 0.96,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '先写一句。先投下去。以后再回来补。',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF6E8798),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class IslandCard extends StatelessWidget {
  const IslandCard({super.key});

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
                Positioned(left: 60, bottom: 42, child: BubbleSpot(icon: '🏠', label: '童年楼')),
                Positioned(left: 150, bottom: 34, child: BubbleSpot(icon: '🌊', label: '海边')),
                Positioned(right: 64, bottom: 46, child: BubbleSpot(icon: '🫧', label: '今天')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '把碎片慢慢养成地图。',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF224158),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '地点是回忆的落点，回忆越多，岛就越清晰。',
            style: TextStyle(color: Color(0xFF6E8798), height: 1.6),
          ),
        ],
      ),
    );
  }
}

class ComposeCard extends StatelessWidget {
  const ComposeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '投下一枚新碎片',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF224158),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '不用完整，先把它留下来。',
            style: TextStyle(color: Color(0xFF6E8798)),
          ),
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
              child: const Text('等待 Flutter 环境后接入表单'),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterCard extends StatelessWidget {
  const FilterCard({super.key});

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

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: StatCard(value: '24', label: '已上岛')),
        SizedBox(width: 10),
        Expanded(child: StatCard(value: '3', label: '地点')),
        SizedBox(width: 10),
        Expanded(child: StatCard(value: '5', label: '待补写')),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({required this.label, required this.title, super.key});

  final String label;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6E8798),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF224158),
          ),
        ),
      ],
    );
  }
}

class SoftCard extends StatelessWidget {
  const SoftCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
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

class StatCard extends StatelessWidget {
  const StatCard({required this.value, required this.label, super.key});

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
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6E8798),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  const ActionCard({
    required this.tag,
    required this.title,
    required this.body,
    super.key,
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
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF224158),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(
                    color: Color(0xFF6E8798),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SpotCard extends StatelessWidget {
  const SpotCard({
    required this.icon,
    required this.title,
    required this.body,
    super.key,
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
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF224158),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(
                    color: Color(0xFF6E8798),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MemoryCard extends StatelessWidget {
  const MemoryCard({
    required this.category,
    required this.date,
    required this.title,
    required this.body,
    super.key,
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF224158),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              color: Color(0xFF6E8798),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
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

class BubbleSpot extends StatelessWidget {
  const BubbleSpot({required this.icon, required this.label, super.key});

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

class InputStub extends StatelessWidget {
  const InputStub({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF6E8798),
          fontSize: 14,
        ),
      ),
    );
  }
}

class AreaStub extends StatelessWidget {
  const AreaStub({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF6E8798),
          fontSize: 14,
        ),
      ),
    );
  }
}

class ChipStub extends StatelessWidget {
  const ChipStub({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF224158),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem(this.label, this.icon);

  final String label;
  final IconData icon;
}
