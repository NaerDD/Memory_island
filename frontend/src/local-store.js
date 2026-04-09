import { mockOverview, mockTopic } from './mock-data';

const MEMORIES_KEY = 'memory-island-local-memories';
const BOTTLES_KEY = 'memory-island-local-bottles';
const COLLECTIONS_KEY = 'memory-island-local-collections';
const TOPIC_INDEX_KEY = 'memory-island-topic-index';

function clone(data) {
  return JSON.parse(JSON.stringify(data));
}

function excerpt(content) {
  const normalized = (content || '').trim().replace(/\s+/g, ' ');
  if (!normalized) {
    return '';
  }
  return normalized.length > 84 ? `${normalized.slice(0, 84)}...` : normalized;
}

function sortByNewest(list) {
  return [...list].sort((a, b) => {
    const left = a.happenedAt || '';
    const right = b.happenedAt || '';
    if (left === right) {
      return Number(b.id) - Number(a.id);
    }
    return right.localeCompare(left);
  });
}

function seedMemories() {
  return mockOverview.buildings.flatMap(building => {
    return building.memories.map(memory => ({
      id: memory.id,
      buildingId: building.id,
      buildingName: building.name,
      buildingType: building.type,
      buildingIcon: building.icon,
      title: memory.title,
      happenedAt: memory.happenedAt,
      weather: memory.weather,
      mediaTypes: memory.mediaTypes,
      emotions: memory.emotions,
      content: memory.content,
      excerpt: excerpt(memory.content)
    }));
  });
}

function seedBottles() {
  return clone(mockOverview.bottles);
}

function seedCollections() {
  return clone(mockOverview.collections);
}

function ensureStore(key, fallback) {
  const existing = window.localStorage.getItem(key);
  if (!existing) {
    window.localStorage.setItem(key, JSON.stringify(fallback));
  }
}

function readList(key, fallback) {
  ensureStore(key, fallback);
  try {
    const parsed = JSON.parse(window.localStorage.getItem(key) || '[]');
    return Array.isArray(parsed) ? parsed : fallback;
  } catch (error) {
    return fallback;
  }
}

function writeList(key, list) {
  window.localStorage.setItem(key, JSON.stringify(list));
}

export function getLocalMemories() {
  return sortByNewest(readList(MEMORIES_KEY, seedMemories()));
}

export function getLocalMemory(id) {
  const targetId = Number(id);
  return getLocalMemories().find(item => Number(item.id) === targetId) || null;
}

export function createLocalMemory(payload) {
  const memories = readList(MEMORIES_KEY, seedMemories());
  const building = mockOverview.buildings.find(item => item.id === Number(payload.buildingId));
  const nextId = memories.reduce((max, item) => Math.max(max, Number(item.id) || 0), 0) + 1;
  const mediaTypes = payload.mediaType
    ? payload.mediaType.split(',').map(item => item.trim()).filter(Boolean)
    : [];

  const created = {
    id: nextId,
    buildingId: Number(payload.buildingId),
    buildingName: building ? building.name : '未命名建筑',
    buildingType: building ? building.type : '自定义空间',
    buildingIcon: building ? building.icon : '🏝️',
    title: payload.title,
    happenedAt: payload.happenedAt,
    weather: '此刻写下',
    mediaTypes,
    emotions: ['怀念', '新记录'],
    content: payload.content,
    excerpt: excerpt(payload.content)
  };

  memories.push(created);
  writeList(MEMORIES_KEY, memories);
  return created;
}

export function createLocalBottle(payload) {
  const bottles = readList(BOTTLES_KEY, seedBottles());
  const nextId = bottles.reduce((max, item) => Math.max(max, Number(item.id) || 0), 0) + 1;
  const moodMap = {
    calm: '平静',
    happy: '轻快',
    nostalgia: '怀念',
    lonely: '孤单'
  };
  const created = {
    id: nextId,
    senderIsland: '雾灯岛',
    mood: payload.mood,
    moodLabel: moodMap[payload.mood] || '未知',
    content: payload.content
  };
  bottles.unshift(created);
  writeList(BOTTLES_KEY, bottles);
  return created;
}

export function createLocalCollection(payload) {
  const collections = readList(COLLECTIONS_KEY, seedCollections());
  const nextId = collections.reduce((max, item) => Math.max(max, Number(item.id) || 0), 0) + 1;
  const created = {
    id: nextId,
    name: payload.name,
    members: payload.members.split(',').map(item => item.trim()).filter(Boolean),
    summary: payload.summary,
    items: ['写下这段共同经历的起点']
  };
  collections.unshift(created);
  writeList(COLLECTIONS_KEY, collections);
  return created;
}

export function getLocalOverview() {
  const overview = clone(mockOverview);
  const memories = getLocalMemories();
  const bottles = readList(BOTTLES_KEY, seedBottles());
  const collections = readList(COLLECTIONS_KEY, seedCollections());
  const buildingMap = new Map();

  overview.buildings.forEach(building => {
    buildingMap.set(building.id, {
      ...building,
      memories: []
    });
  });

  memories.forEach(memory => {
    const building = buildingMap.get(Number(memory.buildingId));
    if (!building) {
      return;
    }
    building.memories.push({
      id: memory.id,
      title: memory.title,
      happenedAt: memory.happenedAt,
      weather: memory.weather,
      mediaTypes: memory.mediaTypes,
      emotions: memory.emotions,
      content: memory.content,
      excerpt: memory.excerpt
    });
  });

  overview.buildings = overview.buildings.map(item => {
    const building = buildingMap.get(item.id);
    building.memories = sortByNewest(building.memories);
    return building;
  });
  overview.memoryCount = memories.length;
  overview.bottles = bottles;
  overview.collections = collections;
  return overview;
}

const topicPool = [
  mockTopic,
  {
    question: '你小时候最熟悉的一段路，脚下是什么材质，路边都有什么？',
    guide: '试着写得具体一点，连拐弯前会先看到什么都记下来。'
  },
  {
    question: '有没有一个人说过一句很短的话，后来却一直留在你心里？',
    guide: '写下那句话、当时的场景，以及你后来为什么总会想起它。'
  }
];

export function getLocalTodayTopic() {
  const index = Number(window.localStorage.getItem(TOPIC_INDEX_KEY) || '0');
  return clone(topicPool[((index % topicPool.length) + topicPool.length) % topicPool.length]);
}

export function getLocalNextTopic() {
  const current = Number(window.localStorage.getItem(TOPIC_INDEX_KEY) || '0');
  const next = (current + 1) % topicPool.length;
  window.localStorage.setItem(TOPIC_INDEX_KEY, String(next));
  return clone(topicPool[next]);
}
