import 'package:flutter/material.dart';

import '../model/island_memory.dart';
import '../model/island_spot.dart';

class MemoryLandStore extends ChangeNotifier {
  MemoryLandStore.seeded()
      : _spots = [
          const IslandSpot(
            id: 'childhood',
            name: '童年楼',
            description: '玻璃汽水、旧楼梯和放学风声。',
            icon: Icons.cottage_rounded,
            accent: Color(0xFFFFB957),
          ),
          const IslandSpot(
            id: 'seaside',
            name: '海边',
            description: '盐味、拖鞋和太阳掉进海里。',
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
            spotName: '童年楼',
            title: '楼下小卖部门口的风',
            body: '玻璃汽水贴着掌心，晚霞把楼道口染成了橘色。',
            mood: '怀念',
            weather: '晴朗',
            dateLabel: '04.09',
          ),
          const IslandMemory(
            id: 'm2',
            spotId: 'seaside',
            spotName: '海边',
            title: '把拖鞋提在手上走回去',
            body: '脚底都是潮湿的沙，海风很慢，路灯还没亮。',
            mood: '平静',
            weather: '海风',
            dateLabel: '04.08',
          ),
          const IslandMemory(
            id: 'm3',
            spotId: 'today',
            spotName: '今天',
            title: '午后那杯冰橙子',
            body: '杯壁的水珠一路流到手腕，整个人突然轻了一点。',
            mood: '轻快',
            weather: '午后',
            dateLabel: '04.08',
          ),
        ];

  final List<IslandSpot> _spots;
  final List<IslandMemory> _memories;
  int _seed = 4;

  List<IslandSpot> get spots => List.unmodifiable(_spots);

  List<IslandMemory> get memories => List.unmodifiable(_memories.reversed);

  int get totalMemories => _memories.length;

  int get totalSpots => _spots.length;

  int get sparkleCount => _memories.where((memory) => memory.body.length <= 18).length;

  double get islandProgress => (_memories.length / 12).clamp(0, 1);

  String get dailyHint {
    if (_memories.length < 4) {
      return '先点亮第 4 枚回忆';
    }
    if (_spots.length < 4) {
      return '给小岛添一个新地点';
    }
    return '补一条今天发生的小闪光';
    }

  List<IslandMemory> recentMemories({int limit = 3}) {
    return memories.take(limit).toList(growable: false);
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
    return memories.where((memory) => memory.spotId == spotId).toList(growable: false);
  }

  int memoryCountForSpot(String spotId) {
    return _memories.where((memory) => memory.spotId == spotId).length;
  }

  String growthLabelForSpot(String spotId) {
    final count = memoryCountForSpot(spotId);
    if (count >= 5) {
      return '发光中';
    }
    if (count >= 3) {
      return '渐渐清晰';
    }
    if (count >= 1) {
      return '刚刚点亮';
    }
    return '等待命名';
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
        dateLabel: '${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}',
      ),
    );
    notifyListeners();
  }
}
