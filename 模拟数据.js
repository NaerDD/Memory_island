// 模拟数据
const mockData = {
  // 用户信息
  user: {
    id: 'user1',
    nickname: '记忆探索者',
    avatar: '',
    islandName: '回忆岛',
    currentMood: 'happy',
    shells: 120
  },
  
  // 建筑列表
  buildings: [
    {
      id: 'building1',
      name: '童年小屋',
      type: 'stage',
      position: { x: 30, y: 40 },
      unlocked: true
    },
    {
      id: 'building2',
      name: '大学图书馆',
      type: 'stage',
      position: { x: 60, y: 30 },
      unlocked: true
    },
    {
      id: 'building3',
      name: '职场大厦',
      type: 'stage',
      position: { x: 50, y: 60 },
      unlocked: true
    },
    {
      id: 'building4',
      name: '家庭相册',
      type: 'circle',
      position: { x: 20, y: 60 },
      unlocked: true
    },
    {
      id: 'building5',
      name: '老友酒吧',
      type: 'circle',
      position: { x: 70, y: 50 },
      unlocked: true
    },
    {
      id: 'building6',
      name: '旅行驿站',
      type: 'circle',
      position: { x: 40, y: 20 },
      unlocked: true
    }
  ],
  
  // 回忆记录
  memories: [
    {
      id: 'memory1',
      buildingId: 'building1',
      title: '第一次骑自行车',
      content: '记得那是一个阳光明媚的下午，爸爸在院子里教我骑自行车。刚开始总是摔倒，但爸爸一直鼓励我，最终我成功了！',
      type: 'text',
      mediaUrl: '',
      customDate: '2005-06-15',
      createdDate: '2023-05-10',
      tags: ['童年', '家庭', '成就']
    },
    {
      id: 'memory2',
      buildingId: 'building1',
      title: '生日派对',
      content: '我的7岁生日派对，邀请了很多小伙伴。妈妈做了一个超级大的生日蛋糕，上面有我最喜欢的卡通人物。',
      type: 'text',
      mediaUrl: '',
      customDate: '2006-03-20',
      createdDate: '2023-05-12',
      tags: ['童年', '生日', '朋友']
    },
    {
      id: 'memory3',
      buildingId: 'building2',
      title: '大学入学',
      content: '第一次离开家去上大学，既兴奋又紧张。认识了很多新同学，开启了人生的新篇章。',
      type: 'text',
      mediaUrl: '',
      customDate: '2015-09-01',
      createdDate: '2023-05-15',
      tags: ['大学', '成长', '新开始']
    },
    {
      id: 'memory4',
      buildingId: 'building3',
      title: '第一天上班',
      content: '毕业后的第一份工作，紧张得不得了。同事们都很友善，帮我快速适应了新环境。',
      type: 'text',
      mediaUrl: '',
      customDate: '2019-07-01',
      createdDate: '2023-05-18',
      tags: ['职场', '成长', '新开始']
    },
    {
      id: 'memory5',
      buildingId: 'building4',
      title: '家庭旅行',
      content: '和家人一起去海边度假，每天都很开心。一起堆沙堡，捡贝壳，看日落。',
      type: 'text',
      mediaUrl: '',
      customDate: '2020-08-10',
      createdDate: '2023-05-20',
      tags: ['家庭', '旅行', '海边']
    },
    {
      id: 'memory6',
      buildingId: 'building5',
      title: '老友重聚',
      content: '和高中好友们时隔多年再次相聚，大家都变了很多，但友情依旧。聊起过去的趣事，仿佛回到了学生时代。',
      type: 'text',
      mediaUrl: '',
      customDate: '2022-12-25',
      createdDate: '2023-05-22',
      tags: ['朋友', '重聚', '回忆']
    },
    {
      id: 'memory7',
      buildingId: 'building6',
      title: '独自旅行',
      content: '第一次一个人出国旅行，去了日本京都。虽然语言不通，但遇到了很多热心的人，学会了独立解决问题。',
      type: 'text',
      mediaUrl: '',
      customDate: '2021-04-15',
      createdDate: '2023-05-25',
      tags: ['旅行', '独自', '成长']
    }
  ],
  
  // 每日话题
  dailyTopics: [
    {
      id: 'topic1',
      content: '你还记得第一次看见大海是在哪里、和谁一起、什么时候吗？',
      date: '2023-06-01'
    },
    {
      id: 'topic2',
      content: '分享一件让你感到自豪的事情',
      date: '2023-06-02'
    },
    {
      id: 'topic3',
      content: '你最珍贵的童年回忆是什么？',
      date: '2023-06-03'
    }
  ],
  
  // 漂流瓶
  bottles: [
    {
      id: 'bottle1',
      senderId: 'user2',
      mood: 'happy',
      content: '今天收到了期待已久的好消息，心情超级棒！想和陌生人分享这份快乐。',
      type: 'text',
      sendDate: '2023-06-01',
      status: 'received',
      replies: []
    },
    {
      id: 'bottle2',
      senderId: 'user3',
      mood: 'nostalgic',
      content: '整理旧照片时，发现了很多珍贵的回忆。时间过得真快，好怀念过去的日子。',
      type: 'text',
      sendDate: '2023-06-01',
      status: 'received',
      replies: []
    }
  ],
  
  // 好友列表
  friends: [
    {
      id: 'friend1',
      userId: 'user2',
      nickname: '海的另一边',
      avatar: '',
      islandName: '梦幻岛'
    },
    {
      id: 'friend2',
      userId: 'user3',
      nickname: '时光旅行者',
      avatar: '',
      islandName: '记忆湾'
    }
  ],
  
  // 共享合集
  sharedCollections: [
    {
      id: 'collection1',
      name: '2023年云南之旅',
      cover: '',
      creatorId: 'user1',
      participants: ['user1', 'user2'],
      memories: [
        {
          id: 'collection-memory1',
          content: '在大理古城漫步，感受到了浓厚的历史文化氛围。',
          type: 'text',
          mediaUrl: '',
          customDate: '2023-02-15',
          createdDate: '2023-02-16',
          creatorId: 'user1'
        },
        {
          id: 'collection-memory2',
          content: '丽江的玉龙雪山真的太美了，仿佛置身仙境。',
          type: 'text',
          mediaUrl: '',
          customDate: '2023-02-18',
          createdDate: '2023-02-19',
          creatorId: 'user2'
        }
      ]
    }
  ],
  
  // 心情列表
  moods: [
    {
      id: 'happy',
      name: '开心',
      icon: '😊'
    },
    {
      id: 'sad',
      name: '难过',
      icon: '😢'
    },
    {
      id: 'nostalgic',
      name: '怀念',
      icon: '😌'
    },
    {
      id: 'confused',
      name: '迷茫',
      icon: '😕'
    },
    {
      id: 'grateful',
      name: '感恩',
      icon: '🙏'
    },
    {
      id: 'hopeful',
      name: '期待',
      icon: '🌟'
    }
  ]
};