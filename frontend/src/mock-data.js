export const mockOverview = {
  islandName: '雾灯岛',
  bio: '给容易遗失的记忆一块能停靠的岸。把人生阶段变成建筑，把共同经历变成可以被反复补写的空间。',
  memoryCount: 4,
  currentMood: {
    key: 'nostalgia',
    label: '怀念',
    icon: '🌥️'
  },
  moods: [
    { key: 'calm', label: '平静', icon: '🌤️' },
    { key: 'happy', label: '轻快', icon: '☀️' },
    { key: 'nostalgia', label: '怀念', icon: '🌥️' },
    { key: 'lonely', label: '孤单', icon: '🌊' }
  ],
  buildings: [
    {
      id: 1,
      name: '童年花房',
      type: '人生阶段',
      icon: '🌼',
      summary: '放那些气味很重、细节却容易散掉的小时候片段。',
      memories: [
        {
          id: 101,
          title: '夏天午睡后，听见风扇一直转',
          happenedAt: '2008-07-12',
          weather: '闷热午后',
          mediaTypes: ['文字', '语音'],
          emotions: ['安心', '困倦'],
          content: '外婆家的竹席有一点凉，醒来时客厅没人，只有风扇在转，阳光把窗帘照得很白。'
        },
        {
          id: 102,
          title: '第一次自己去小卖部',
          happenedAt: '2009-03-04',
          weather: '放学后',
          mediaTypes: ['文字', '图片'],
          emotions: ['紧张', '得意'],
          content: '手里一直攥着两块钱，来回确认口袋有没有破，回来的路上才敢把糖纸拆开。'
        }
      ]
    },
    {
      id: 2,
      name: '求学灯塔',
      type: '人生阶段',
      icon: '📗',
      summary: '记录学校时期的人、考场、走廊和那个年龄的自我认识。',
      memories: [
        {
          id: 201,
          title: '晚自习停电的十分钟',
          happenedAt: '2016-11-18',
          weather: '初冬晚风',
          mediaTypes: ['文字'],
          emotions: ['松弛', '想笑'],
          content: '整层楼突然暗下来，走廊里全是压不住的笑声，黑暗反而让那天的关系变得松一点。'
        }
      ]
    },
    {
      id: 3,
      name: '远行码头',
      type: '关系圈子',
      icon: '🧳',
      summary: '存放旅行、迁移、离开和抵达，一切和路有关的时刻。',
      memories: [
        {
          id: 301,
          title: '凌晨四点的火车站',
          happenedAt: '2021-08-26',
          weather: '潮湿微凉',
          mediaTypes: ['文字', '视频'],
          emotions: ['漂浮感', '期待'],
          content: '站前广场灯很白，行李箱轮子一直卡在砖缝里，困意和期待叠在一起。'
        }
      ]
    }
  ],
  bottles: [
    {
      id: 1,
      senderIsland: '北栀岛',
      mood: 'nostalgia',
      moodLabel: '怀念',
      content: '今天突然想起奶奶晾衣服时夹子碰撞的声音。原来我记住的不一定是画面，也可能是声音。'
    },
    {
      id: 2,
      senderIsland: '晴湾岛',
      mood: 'happy',
      moodLabel: '轻快',
      content: '刚翻到一张旧车票，发现那次临时起意的出门，后来成了我最喜欢的一年。'
    }
  ],
  collections: [
    {
      id: 1,
      name: '2019 海边夏夜',
      members: ['阿宁', '你'],
      summary: '把那次临时看海的片段拼回完整版本。',
      items: [
        '阿宁补充：到海边时鞋里已经进沙了',
        '你补充：便利店买的是荔枝味汽水',
        '待补：返程时广播里放的那首歌'
      ]
    },
    {
      id: 2,
      name: '大学宿舍碎片',
      members: ['小周', '你', '阿祺'],
      summary: '不是大事，而是日后才会怀念的细节。',
      items: [
        '小周记得：有一次全宿舍一起在阳台吹风',
        '阿祺记得：毕业前一晚谁都没睡',
        '你记得：搬空书桌时抽屉里还有旧便签'
      ]
    }
  ]
};

export const mockTopic = {
  question: '你第一次认真看海，是在什么地方，和谁一起，风是什么味道？',
  guide: '不要只写发生了什么，也写温度、气味、衣服颜色和身体感受。'
};
