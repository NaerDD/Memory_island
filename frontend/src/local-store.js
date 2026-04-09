import { mockOverview, mockTopic } from './mock-data';

const BUILDINGS_KEY = 'memory-island-local-buildings';
const MEMORIES_KEY = 'memory-island-local-memories';
const COMMENTS_KEY = 'memory-island-local-comments';
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

function seedBuildings() {
  return mockOverview.buildings.map(building => ({
    id: building.id,
    name: building.name,
    type: building.type,
    icon: building.icon,
    summary: building.summary
  }));
}

function seedComments() {
  return [];
}

function seedMemories() {
  return mockOverview.buildings.flatMap(building => {
    return building.memories.map(memory => ({
      id: memory.id,
      buildingId: building.id,
      title: memory.title,
      happenedAt: memory.happenedAt,
      weather: memory.weather,
      mediaTypes: memory.mediaTypes,
      emotions: memory.emotions,
      content: memory.content
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

function getBuildingsStore() {
  return readList(BUILDINGS_KEY, seedBuildings());
}

function getCommentsStore() {
  return readList(COMMENTS_KEY, seedComments());
}

function normalizeStringList(source, fallback) {
  if (Array.isArray(source)) {
    return source.filter(Boolean);
  }
  if (typeof source === 'string' && source.trim()) {
    return source
      .split(',')
      .map(item => item.trim())
      .filter(Boolean);
  }
  return fallback;
}

function normalizeMemoryPayload(payload) {
  return {
    buildingId: Number(payload.buildingId),
    title: payload.title,
    happenedAt: payload.happenedAt,
    weather: payload.weather || '此刻写下',
    mediaTypes: normalizeStringList(payload.mediaType || payload.mediaTypes, []),
    emotions: normalizeStringList(payload.emotions, ['怀念', '新记录']),
    content: payload.content
  };
}

function hydrateMemory(memory, building, comments) {
  return {
    id: memory.id,
    buildingId: building ? building.id : memory.buildingId,
    buildingName: building ? building.name : '未命名建筑',
    buildingType: building ? building.type : '自定义空间',
    buildingIcon: building ? building.icon : '🏝️',
    title: memory.title,
    happenedAt: memory.happenedAt,
    weather: memory.weather,
    mediaTypes: memory.mediaTypes,
    emotions: memory.emotions,
    content: memory.content,
    excerpt: excerpt(memory.content),
    comments: comments
      .filter(item => Number(item.memoryId) === Number(memory.id))
      .sort((a, b) => String(b.createdAt).localeCompare(String(a.createdAt)))
      .map(item => ({
        id: item.id,
        authorName: item.authorName,
        content: item.content,
        createdAt: item.createdAt
      }))
  };
}

export function getLocalMemories() {
  const buildings = getBuildingsStore();
  const buildingMap = new Map(buildings.map(item => [Number(item.id), item]));
  const comments = getCommentsStore();
  const memories = readList(MEMORIES_KEY, seedMemories()).map(memory => {
    return hydrateMemory(memory, buildingMap.get(Number(memory.buildingId)), comments);
  });
  return sortByNewest(memories);
}

export function getLocalMemory(id) {
  const targetId = Number(id);
  return getLocalMemories().find(item => Number(item.id) === targetId) || null;
}

export function createLocalBuilding(payload) {
  const buildings = getBuildingsStore();
  const nextId = buildings.reduce((max, item) => Math.max(max, Number(item.id) || 0), 0) + 1;
  const created = {
    id: nextId,
    name: payload.name,
    type: payload.type,
    icon: payload.icon || '🏛️',
    summary: payload.summary
  };
  buildings.push(created);
  writeList(BUILDINGS_KEY, buildings);
  return {
    ...created,
    memories: []
  };
}

export function updateLocalBuilding(id, payload) {
  const buildings = getBuildingsStore();
  const targetId = Number(id);
  const nextBuildings = buildings.map(item => {
    if (Number(item.id) !== targetId) {
      return item;
    }
    return {
      ...item,
      name: payload.name,
      type: payload.type,
      icon: payload.icon || item.icon,
      summary: payload.summary
    };
  });
  writeList(BUILDINGS_KEY, nextBuildings);
  const updated = nextBuildings.find(item => Number(item.id) === targetId);
  return {
    ...updated,
    memories: getLocalMemories().filter(item => Number(item.buildingId) === targetId)
  };
}

export function createLocalMemory(payload) {
  const memories = readList(MEMORIES_KEY, seedMemories());
  const normalized = normalizeMemoryPayload(payload);
  const building = getBuildingsStore().find(item => Number(item.id) === normalized.buildingId);
  const nextId = memories.reduce((max, item) => Math.max(max, Number(item.id) || 0), 0) + 1;

  const created = {
    id: nextId,
    ...normalized
  };

  memories.push(created);
  writeList(MEMORIES_KEY, memories);
  return hydrateMemory(created, building, getCommentsStore());
}

export function updateLocalMemory(id, payload) {
  const memories = readList(MEMORIES_KEY, seedMemories());
  const targetId = Number(id);
  const normalized = normalizeMemoryPayload(payload);
  const nextMemories = memories.map(item => {
    if (Number(item.id) !== targetId) {
      return item;
    }
    return {
      ...item,
      ...normalized
    };
  });
  writeList(MEMORIES_KEY, nextMemories);
  const updated = nextMemories.find(item => Number(item.id) === targetId);
  const building = getBuildingsStore().find(item => Number(item.id) === Number(updated.buildingId));
  return hydrateMemory(updated, building, getCommentsStore());
}

export function deleteLocalMemory(id) {
  const targetId = Number(id);
  const memories = readList(MEMORIES_KEY, seedMemories()).filter(item => Number(item.id) !== targetId);
  const comments = getCommentsStore().filter(item => Number(item.memoryId) !== targetId);
  writeList(MEMORIES_KEY, memories);
  writeList(COMMENTS_KEY, comments);
  return true;
}

export function createLocalComment(memoryId, payload) {
  const comments = getCommentsStore();
  const nextId = comments.reduce((max, item) => Math.max(max, Number(item.id) || 0), 0) + 1;
  const created = {
    id: nextId,
    memoryId: Number(memoryId),
    authorName: payload.authorName,
    content: payload.content,
    createdAt: new Date().toISOString()
  };
  comments.push(created);
  writeList(COMMENTS_KEY, comments);
  return {
    id: created.id,
    authorName: created.authorName,
    content: created.content,
    createdAt: created.createdAt
  };
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
  const buildings = getBuildingsStore();
  const memories = getLocalMemories();
  const bottles = readList(BOTTLES_KEY, seedBottles());
  const collections = readList(COLLECTIONS_KEY, seedCollections());

  overview.buildings = buildings.map(building => ({
    ...building,
    memories: memories.filter(item => Number(item.buildingId) === Number(building.id))
  }));
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
