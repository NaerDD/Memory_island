import {
  createLocalBuilding,
  createLocalBottle,
  createLocalComment,
  createLocalCollection,
  createLocalMemory,
  getLocalMemories,
  getLocalMemory,
  getLocalNextTopic,
  getLocalOverview,
  getLocalTodayTopic,
  updateLocalBuilding
} from './local-store';

function clone(data) {
  return JSON.parse(JSON.stringify(data));
}

async function request(url, options) {
  const response = await fetch(url, options);
  if (!response.ok) {
    throw new Error('Request failed');
  }

  if (response.status === 204) {
    return null;
  }

  const text = await response.text();
  return text ? JSON.parse(text) : null;
}

export async function getOverview() {
  try {
    const data = await request('/api/overview');
    return { data, usingMock: false };
  } catch (error) {
    return { data: getLocalOverview(), usingMock: true };
  }
}

export async function getTodayTopic() {
  try {
    const data = await request('/api/topics/today');
    return { data, usingMock: false };
  } catch (error) {
    return { data: getLocalTodayTopic(), usingMock: true };
  }
}

export async function getNextTopic() {
  try {
    const data = await request('/api/topics/next');
    return { data, usingMock: false };
  } catch (error) {
    return { data: getLocalNextTopic(), usingMock: true };
  }
}

export async function getMemories() {
  try {
    const data = await request('/api/memories');
    return { data, usingMock: false };
  } catch (error) {
    return { data: clone(getLocalMemories()), usingMock: true };
  }
}

export async function getMemoryDetail(id) {
  try {
    const data = await request(`/api/memories/${id}`);
    return { data, usingMock: false };
  } catch (error) {
    return { data: clone(getLocalMemory(id)), usingMock: true };
  }
}

export async function createMemory(payload) {
  try {
    const data = await request('/api/memories', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    return { data, usingMock: false };
  } catch (error) {
    return { data: createLocalMemory(payload), usingMock: true };
  }
}

export async function createBuilding(payload) {
  try {
    const data = await request('/api/buildings', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    return { data, usingMock: false };
  } catch (error) {
    return { data: createLocalBuilding(payload), usingMock: true };
  }
}

export async function updateBuilding(id, payload) {
  try {
    const data = await request(`/api/buildings/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    return { data, usingMock: false };
  } catch (error) {
    return { data: updateLocalBuilding(id, payload), usingMock: true };
  }
}

export async function createComment(memoryId, payload) {
  try {
    const data = await request(`/api/memories/${memoryId}/comments`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    return { data, usingMock: false };
  } catch (error) {
    return { data: createLocalComment(memoryId, payload), usingMock: true };
  }
}

export async function createBottle(payload) {
  try {
    const data = await request('/api/bottles', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    return { data, usingMock: false };
  } catch (error) {
    return { data: createLocalBottle(payload), usingMock: true };
  }
}

export async function createCollection(payload) {
  try {
    const data = await request('/api/collections', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    return { data, usingMock: false };
  } catch (error) {
    return { data: createLocalCollection(payload), usingMock: true };
  }
}
