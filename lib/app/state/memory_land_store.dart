import 'package:flutter/material.dart';

import '../model/island_memory.dart';
import '../model/island_spot.dart';

class MemoryLandStore extends ChangeNotifier {
  MemoryLandStore.seeded()
      : _spots = [
          const IslandSpot(
            id: 'childhood',
            name: '旧教室',
            description: '玻璃汽水、木门缝里的风，和放学后慢慢拉长的影子。',
            icon: Icons.cottage_rounded,
            accent: Color(0xFFFFB957),
          ),
          const IslandSpot(
            id: 'seaside',
            name: '沙滩',
            description: '盐味、拖鞋和傍晚快落下去的太阳。',
            icon: Icons.waves_rounded,
            accent: Color(0xFF47C8D6),
          ),
          const IslandSpot(
            id: 'today',
            name: '今天',
            description: '刚刚发生的小事，先别让它散掉。',
            icon: Icons.wb_sunny_rounded,
            accent: Color(0xFFFF8A5B),
          ),
        ],
        _memories = [
          const IslandMemory(
            id: 'm1',
            spotId: 'childhood',
            spotName: '旧教室',
            title: '小卖部门口的晚风',
            body: '玻璃汽水贴着掌心，楼道口被夕阳染成橘色。',
            mood: '想念',
            weather: '晴朗',
            dateLabel: '04.09',
          ),
          const IslandMemory(
            id: 'm2',
            spotId: 'seaside',
            spotName: '沙滩',
            title: '把拖鞋提在手里走回去',
            body: '脚底都是潮湿的沙，海风很慢，路灯还没亮。',
            mood: '平静',
            weather: '海风',
            dateLabel: '04.08',
          ),
          const IslandMemory(
            id: 'm3',
            spotId: 'today',
            spotName: '今天',
            title: '午后那杯冰橘子',
            body: '杯壁的水珠一路滑到手腕，整个人忽然轻了一点。',
            mood: '轻快',
            weather: '午后',
            dateLabel: '04.08',
          ),
        ];

  final List<IslandSpot> _spots;
  final List<IslandMemory> _memories;
  int _seed = 4;
  String? _celebrationMessage;

  String get islandName => '主岛 01';

  int get ownedIslandCount => 1;

  bool get isPremium => false;

  int get islandCapacity => 365;

  List<IslandSpot> get spots => List.unmodifiable(_spots);

  List<IslandMemory> get memories => List.unmodifiable(_memories.reversed);

  int get totalMemories => _memories.length;

  int get totalSpots => _spots.length;

  int get sparkleCount =>
      _memories.where((memory) => memory.body.length <= 18).length;

  double get islandProgress => (_memories.length / islandCapacity).clamp(0, 1);

  int get streakDays => 2 + (_memories.length ~/ 2);

  int get questTarget => 6;

  int get questProgress => _memories.length.clamp(0, questTarget);

  String get questTitle {
    if (_memories.length < 4) {
      return '再写 1 条今天的小事，让这座岛真正住下来';
    }
    if (_spots.length < 4) {
      return '给岛上添 1 个地点，让回忆有新的落脚处';
    }
    return '把总回忆写到 $questTarget 条，解锁下一座岛的申请';
  }

  String get nextRewardLabel {
    final nextGoal = ((_memories.length ~/ 3) + 1) * 3;
    return '距离下一次扩容还差 ${nextGoal - _memories.length} 条';
  }

  String get dailyHint {
    if (_memories.length < 4) {
      return '再留一条今天的光线或气味';
    }
    if (_spots.length < 4) {
      return '给这座岛补一个新的地名';
    }
    return '写下今天最不想忘的一瞬间';
  }

  String get islandCapacityLabel => '一座岛，收下一整年的日记';

  String? get celebrationMessage => _celebrationMessage;

  Map<String, int> get moodCounts {
    final result = <String, int>{
      '轻快': 0,
      '平静': 0,
      '想念': 0,
    };
    for (final memory in _memories) {
      result.update(memory.mood, (value) => value + 1, ifAbsent: () => 1);
    }
    return result;
  }

  List<IslandSpot> get earnedBadges {
    return _spots
        .where((spot) => memoryCountForSpot(spot.id) > 0)
        .toList(growable: false);
  }

  List<IslandMemory> recentMemories({int limit = 3}) {
    return memories.take(limit).toList(growable: false);
  }

  List<WeekPulse> get weeklyPulses {
    final now = DateTime.now();
    final pulses = <WeekPulse>[];

    for (var index = 6; index >= 0; index--) {
      final day = now.subtract(Duration(days: index));
      final label =
          '${day.month.toString().padLeft(2, '0')}.${day.day.toString().padLeft(2, '0')}';
      final dayMemories = _memories
          .where((memory) => memory.dateLabel == label)
          .toList(growable: false);
      final mood = dayMemories.isEmpty ? '留白' : dayMemories.last.mood;
      pulses.add(
        WeekPulse(
          dayLabel: _weekdayLabel(day.weekday),
          dateLabel: label,
          count: dayMemories.length,
          mood: mood,
        ),
      );
    }

    return pulses;
  }

  List<MonthAnchor> get monthAnchors {
    return List.generate(12, (index) {
      final month = index + 1;
      final count = _memories
          .where((memory) =>
              memory.dateLabel.startsWith(month.toString().padLeft(2, '0')))
          .length;
      return MonthAnchor(month: month, count: count);
    });
  }

  IslandSpot? spotById(String id) {
    for (final spot in _spots) {
      if (spot.id == id) {
        return spot;
      }
    }
    return null;
  }

  List<IslandMemory> memoriesForSpot(String spotId) {
    return memories
        .where((memory) => memory.spotId == spotId)
        .toList(growable: false);
  }

  int memoryCountForSpot(String spotId) {
    return _memories.where((memory) => memory.spotId == spotId).length;
  }

  String growthLabelForSpot(String spotId) {
    return growthLabelForCount(memoryCountForSpot(spotId));
  }

  String growthLabelForCount(int count) {
    if (count >= 5) {
      return '已经成片';
    }
    if (count >= 3) {
      return '慢慢长出来';
    }
    if (count >= 1) {
      return '刚刚落笔';
    }
    return '等待命名';
  }

  String growthLabelAfterNextMemory(String spotId) {
    return growthLabelForCount(memoryCountForSpot(spotId) + 1);
  }

  void clearCelebration() {
    if (_celebrationMessage == null) {
      return;
    }
    _celebrationMessage = null;
    notifyListeners();
  }

  void addSpot({
    required String name,
    required String description,
  }) {
    final trimmedName = name.trim();
    final trimmedDescription = description.trim();
    if (trimmedName.isEmpty || trimmedDescription.isEmpty) {
      return;
    }

    final accents = [
      const Color(0xFFFFB957),
      const Color(0xFF47C8D6),
      const Color(0xFFFF8A5B),
      const Color(0xFF87D96C),
    ];
    final icons = [
      Icons.deck_rounded,
      Icons.local_florist_rounded,
      Icons.sailing_rounded,
      Icons.icecream_rounded,
    ];

    _spots.add(
      IslandSpot(
        id: 'spot_${DateTime.now().microsecondsSinceEpoch}',
        name: trimmedName,
        description: trimmedDescription,
        icon: icons[_seed % icons.length],
        accent: accents[_seed % accents.length],
      ),
    );
    _seed += 1;
    _celebrationMessage = '$trimmedName 已经落在岛上。';
    notifyListeners();
  }

  void addMemory({
    required String spotId,
    required String title,
    required String body,
    required String mood,
    required String weather,
  }) {
    final spot = spotById(spotId);
    final trimmedTitle = title.trim();
    final trimmedBody = body.trim();
    if (spot == null || trimmedTitle.isEmpty || trimmedBody.isEmpty) {
      return;
    }

    final now = DateTime.now();
    _memories.add(
      IslandMemory(
        id: 'memory_${now.microsecondsSinceEpoch}',
        spotId: spot.id,
        spotName: spot.name,
        title: trimmedTitle,
        body: trimmedBody,
        mood: mood.trim().isEmpty ? '轻快' : mood.trim(),
        weather: weather.trim().isEmpty ? '晴朗' : weather.trim(),
        dateLabel:
            '${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}',
      ),
    );

    final countAfterAdd = memoryCountForSpot(spot.id);
    if (countAfterAdd == 3 || countAfterAdd == 5) {
      _celebrationMessage = '${spot.name} 变得更清楚了，像一段正在成形的旧路。';
    } else if (_memories.length % 3 == 0) {
      _celebrationMessage = '今天的岛又多收住了一点光。';
    } else {
      _celebrationMessage = '新的回忆已经靠岸。';
    }
    notifyListeners();
  }

  String _weekdayLabel(int weekday) {
    return const {
      DateTime.monday: '一',
      DateTime.tuesday: '二',
      DateTime.wednesday: '三',
      DateTime.thursday: '四',
      DateTime.friday: '五',
      DateTime.saturday: '六',
      DateTime.sunday: '日',
    }[weekday]!;
  }
}

class WeekPulse {
  const WeekPulse({
    required this.dayLabel,
    required this.dateLabel,
    required this.count,
    required this.mood,
  });

  final String dayLabel;
  final String dateLabel;
  final int count;
  final String mood;
}

class MonthAnchor {
  const MonthAnchor({
    required this.month,
    required this.count,
  });

  final int month;
  final int count;
}
