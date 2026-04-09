<template>
  <div class="island-page" id="topbar">
    <TopNav
      :nav-items="navItems"
      :is-logged-in="isLoggedIn"
      :user-name="currentUser.name"
      @navigate="handleNavNavigate"
      @go-auth="goAuth"
      @write="goWrite"
      @logout="logout"
    />

    <section class="island-shell">
      <div class="overview-card">
        <div class="overview-visual">
          <div class="island-sun"></div>
          <div class="island-water"></div>
          <div class="island-sand"></div>
          <div class="mini-node mini-node-a"></div>
          <div class="mini-node mini-node-b"></div>
          <div class="mini-node mini-node-c"></div>
        </div>

        <div class="overview-copy">
          <p class="eyebrow">ISLAND MAP</p>
          <h1>{{ overview.islandName || '回忆岛' }}</h1>
          <p>{{ overview.bio || '把碎片慢慢养成地图。' }}</p>

          <div class="overview-stats">
            <div class="stat-pill">
              <strong>{{ overview.memoryCount || 0 }}</strong>
              <span>碎片</span>
            </div>
            <div class="stat-pill">
              <strong>{{ buildings.length }}</strong>
              <span>地点</span>
            </div>
            <div v-if="overview.currentMood" class="stat-pill mood">
              <strong>{{ overview.currentMood.icon }}</strong>
              <span>{{ overview.currentMood.label }}</span>
            </div>
          </div>

          <div class="topic-card">
            <div>
              <small>今日海风</small>
              <h2>{{ topic.question || '今天写点什么？' }}</h2>
            </div>
            <button class="ghost-btn" @click="refreshTopic">换题</button>
          </div>
        </div>
      </div>

      <div class="segment-bar">
        <button
          v-for="item in segments"
          :key="item.key"
          class="segment-btn"
          :class="{ active: activeSegment === item.key }"
          @click="activeSegment = item.key"
        >
          {{ item.label }}
        </button>
      </div>

      <section v-if="activeSegment === 'buildings'" class="panel-block">
        <div class="panel-head">
          <h3>地点编辑台</h3>
          <button class="mini-btn" @click="goWrite">投放回忆</button>
        </div>

        <div class="panel-card compose-card">
          <div class="form-row">
            <input v-model.trim="buildingForm.name" type="text" placeholder="地点名" />
            <input v-model.trim="buildingForm.icon" type="text" placeholder="图标" />
          </div>
          <div class="form-row">
            <input v-model.trim="buildingForm.type" type="text" placeholder="例如：童年 / 朋友 / 旅行" />
            <button class="mini-btn primary" @click="submitBuilding">
              {{ editingBuildingId ? '保存' : '新建' }}
            </button>
          </div>
          <textarea
            v-model.trim="buildingForm.summary"
            rows="3"
            placeholder="这个地点收纳哪类回忆？"
          />
          <div class="compose-actions">
            <p v-if="buildingMessage" class="feedback">{{ buildingMessage }}</p>
            <button v-if="editingBuildingId" class="mini-btn" @click="resetBuildingForm">取消</button>
          </div>
        </div>

        <div class="horizontal-list">
          <article
            v-for="building in buildings"
            :key="building.id"
            class="panel-card building-card"
          >
            <div class="card-actions">
              <button class="icon-btn" @click="openBuilding(building.id)">进入</button>
              <button class="icon-btn" @click="startEditBuilding(building)">编辑</button>
            </div>
            <div class="building-top">
              <span class="building-icon">{{ building.icon }}</span>
              <span class="building-count">{{ building.memories.length }} 条</span>
            </div>
            <h4>{{ building.name }}</h4>
            <p>{{ building.summary }}</p>
          </article>
        </div>
      </section>

      <section v-if="activeSegment === 'bottles'" class="panel-block">
        <div class="panel-head">
          <h3>漂流瓶</h3>
          <span>{{ bottles.length }} 个</span>
        </div>

        <div class="panel-card compose-card">
          <div class="form-row">
            <select v-model="bottleForm.mood">
              <option value="calm">平静</option>
              <option value="happy">轻快</option>
              <option value="nostalgia">怀念</option>
              <option value="lonely">孤单</option>
            </select>
            <button class="mini-btn primary" @click="submitBottle">投出去</button>
          </div>
          <textarea
            v-model.trim="bottleForm.content"
            rows="4"
            placeholder="留一句给海风。"
          />
          <p v-if="bottleMessage" class="feedback">{{ bottleMessage }}</p>
        </div>

        <div class="stack-list">
          <article v-for="bottle in bottles" :key="bottle.id" class="panel-card stack-card">
            <div class="stack-meta">
              <span>{{ bottle.senderIsland }}</span>
              <span>{{ bottle.moodLabel }}</span>
            </div>
            <p>{{ bottle.content }}</p>
          </article>
        </div>
      </section>

      <section v-if="activeSegment === 'collections'" class="panel-block">
        <div class="panel-head">
          <h3>共享合集</h3>
          <span>{{ collections.length }} 份</span>
        </div>

        <div class="panel-card compose-card">
          <input v-model.trim="collectionForm.name" type="text" placeholder="合集名" />
          <input v-model.trim="collectionForm.members" type="text" placeholder="成员，用逗号分隔" />
          <textarea
            v-model.trim="collectionForm.summary"
            rows="3"
            placeholder="这一组回忆准备收什么？"
          />
          <div class="compose-actions">
            <p v-if="collectionMessage" class="feedback">{{ collectionMessage }}</p>
            <button class="mini-btn primary" @click="submitCollection">创建</button>
          </div>
        </div>

        <div class="stack-list">
          <article v-for="collection in collections" :key="collection.id" class="panel-card stack-card">
            <div class="stack-meta">
              <span>{{ collection.name }}</span>
              <span>{{ collection.members.join(' / ') }}</span>
            </div>
            <p>{{ collection.summary }}</p>
          </article>
        </div>
      </section>
    </section>
  </div>
</template>

<script>
import TopNav from '../components/TopNav.vue'
import {
  createBottle,
  createBuilding,
  createCollection,
  getNextTopic,
  getOverview,
  getTodayTopic,
  updateBuilding
} from '../api'

export default {
  name: 'Island',
  components: {
    TopNav
  },
  data() {
    return {
      navItems: [
        { key: 'home', label: '首页', target: 'topbar', route: '/' },
        { key: 'island', label: '小岛', target: 'topbar', route: '/island' },
        { key: 'memories', label: '回忆', target: 'memories', route: '/memories' }
      ],
      segments: [
        { key: 'buildings', label: '地点' },
        { key: 'bottles', label: '漂流瓶' },
        { key: 'collections', label: '合集' }
      ],
      activeSegment: 'buildings',
      currentUser: {
        name: '',
        email: ''
      },
      overview: {
        bio: ''
      },
      topic: {},
      buildings: [],
      bottles: [],
      collections: [],
      bottleForm: {
        mood: 'nostalgia',
        content: ''
      },
      collectionForm: {
        name: '',
        members: '',
        summary: ''
      },
      buildingForm: {
        name: '',
        type: '',
        icon: '',
        summary: ''
      },
      editingBuildingId: null,
      bottleMessage: '',
      collectionMessage: '',
      buildingMessage: ''
    }
  },
  computed: {
    isLoggedIn() {
      return !!this.currentUser.email
    }
  },
  created() {
    this.loadUser()
    this.loadOverview()
    this.loadTopic()
  },
  methods: {
    loadUser() {
      const raw = localStorage.getItem('memory-island-user')
      if (raw) {
        this.currentUser = JSON.parse(raw)
      }
    },
    async loadOverview() {
      const { data } = await getOverview()
      this.overview = data || {}
      this.buildings = this.overview.buildings || []
      this.bottles = this.overview.bottles || []
      this.collections = this.overview.collections || []
    },
    async loadTopic() {
      const { data } = await getTodayTopic()
      this.topic = data || {}
    },
    async refreshTopic() {
      const { data } = await getNextTopic()
      this.topic = data || {}
    },
    handleNavNavigate(payload) {
      if (this.$route.path !== payload.route) {
        this.$router.push(payload.route)
      }
    },
    goAuth(mode) {
      this.$router.push({
        path: '/auth',
        query: { mode }
      })
    },
    goWrite() {
      if (!this.isLoggedIn) {
        this.$router.push({
          path: '/auth',
          query: { mode: 'login' }
        })
        return
      }
      this.$router.push('/write')
    },
    logout() {
      localStorage.removeItem('memory-island-user')
      this.currentUser = {
        name: '',
        email: ''
      }
      this.$router.push('/')
    },
    openBuilding(id) {
      this.$router.push(`/island/building/${id}`)
    },
    startEditBuilding(building) {
      this.editingBuildingId = building.id
      this.buildingForm = {
        name: building.name,
        type: building.type,
        icon: building.icon,
        summary: building.summary
      }
      this.buildingMessage = '正在修改这个地点。'
    },
    resetBuildingForm() {
      this.editingBuildingId = null
      this.buildingForm = {
        name: '',
        type: '',
        icon: '',
        summary: ''
      }
    },
    async submitBuilding() {
      this.buildingMessage = ''
      if (!this.buildingForm.name || !this.buildingForm.type || !this.buildingForm.summary) {
        this.buildingMessage = '地点名、类型和简介要填满。'
        return
      }
      if (this.editingBuildingId) {
        await updateBuilding(this.editingBuildingId, {
          ...this.buildingForm,
          icon: this.buildingForm.icon || '🏝️'
        })
        this.resetBuildingForm()
        this.buildingMessage = '地点已更新。'
      } else {
        await createBuilding({
          ...this.buildingForm,
          icon: this.buildingForm.icon || '🏝️'
        })
        this.resetBuildingForm()
        this.buildingMessage = '新地点已落岛。'
      }
      await this.loadOverview()
    },
    async submitBottle() {
      this.bottleMessage = ''
      if (!this.bottleForm.content) {
        this.bottleMessage = '先留下一句话。'
        return
      }
      await createBottle(this.bottleForm)
      this.bottleForm.content = ''
      this.bottleMessage = '已经顺着海风送出。'
      await this.loadOverview()
    },
    async submitCollection() {
      this.collectionMessage = ''
      if (!this.collectionForm.name || !this.collectionForm.members || !this.collectionForm.summary) {
        this.collectionMessage = '合集名、成员和简介都要有。'
        return
      }
      await createCollection(this.collectionForm)
      this.collectionForm = {
        name: '',
        members: '',
        summary: ''
      }
      this.collectionMessage = '合集已创建。'
      await this.loadOverview()
    }
  }
}
</script>

<style scoped>
.island-page {
  min-height: 100vh;
  padding: 8px 14px 120px;
}

.island-shell {
  margin-top: 14px;
}

.overview-card,
.panel-card {
  border: none;
  border-radius: 30px;
  background: rgba(255, 250, 239, 0.84);
  box-shadow: var(--shadow-lg);
}

.overview-card {
  padding: 18px;
}

.overview-visual {
  position: relative;
  min-height: 180px;
  border-radius: 28px;
  overflow: hidden;
  background: linear-gradient(180deg, rgba(255, 236, 177, 0.86) 0%, rgba(147, 228, 239, 0.86) 62%, rgba(71, 191, 207, 0.96) 100%);
}

.island-sun,
.island-water,
.island-sand,
.mini-node {
  position: absolute;
}

.island-sun {
  top: 20px;
  right: 26px;
  width: 78px;
  height: 78px;
  border-radius: 50%;
  background: radial-gradient(circle, #fff0a4 0%, #ffd363 60%, transparent 76%);
}

.island-water {
  left: -10%;
  right: -10%;
  bottom: 46px;
  height: 74px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.2);
}

.island-sand {
  left: -10%;
  right: -10%;
  bottom: -16px;
  height: 98px;
  border-radius: 50%;
  background: rgba(255, 228, 171, 0.78);
}

.mini-node {
  width: 22px;
  height: 22px;
  border-radius: 50%;
  background: #ffffff;
  box-shadow: 0 10px 20px rgba(113, 166, 190, 0.18);
}

.mini-node-a { left: 24%; bottom: 72px; }
.mini-node-b { left: 42%; bottom: 58px; }
.mini-node-c { right: 28%; bottom: 70px; }

.overview-copy {
  margin-top: 16px;
}

.eyebrow {
  margin: 0 0 8px;
  color: rgba(80, 127, 148, 0.84);
  font-size: 12px;
  letter-spacing: 0.14em;
}

h1,
h2,
h3,
h4,
p {
  margin: 0;
}

h1 {
  font-size: clamp(2.1rem, 8vw, 3.6rem);
  line-height: 0.96;
  letter-spacing: -0.06em;
}

.overview-copy p:last-child,
.topic-card p,
.building-card p,
.stack-card p {
  color: var(--muted);
  line-height: 1.65;
}

.overview-stats {
  display: flex;
  gap: 10px;
  margin-top: 16px;
  flex-wrap: wrap;
}

.stat-pill {
  min-width: 88px;
  padding: 12px 14px;
  border-radius: 20px;
  background: rgba(255, 255, 255, 0.58);
}

.stat-pill strong {
  display: block;
  font-size: 20px;
}

.stat-pill span {
  color: var(--muted);
  font-size: 12px;
}

.topic-card {
  margin-top: 16px;
  padding: 16px;
  border-radius: 22px;
  background: linear-gradient(180deg, rgba(47, 200, 194, 0.14), rgba(255, 183, 79, 0.22));
  display: flex;
  justify-content: space-between;
  gap: 12px;
}

.topic-card small {
  color: rgba(80, 127, 148, 0.84);
}

.topic-card h2 {
  margin-top: 6px;
  font-size: 22px;
  line-height: 1.2;
  letter-spacing: -0.04em;
}

.ghost-btn,
.mini-btn,
.segment-btn {
  border: none;
  border-radius: 999px;
}

.ghost-btn,
.mini-btn {
  padding: 10px 14px;
  background: rgba(255, 255, 255, 0.58);
  color: var(--text);
  white-space: nowrap;
}

.mini-btn.primary {
  background: linear-gradient(135deg, #2fc8c2, #3b8cff);
  color: #fff;
  font-weight: 700;
}

.segment-bar {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
  margin-top: 14px;
}

.segment-btn {
  min-height: 46px;
  background: rgba(255, 255, 255, 0.55);
  color: var(--muted);
}

.segment-btn.active {
  background: linear-gradient(135deg, rgba(47, 200, 194, 0.18), rgba(255, 183, 79, 0.24));
  color: var(--text);
}

.panel-block {
  margin-top: 14px;
}

.panel-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 10px;
}

.panel-head h3 {
  font-size: 28px;
  letter-spacing: -0.05em;
}

.panel-head span {
  color: var(--muted);
  font-size: 13px;
}

.horizontal-list {
  display: grid;
  grid-auto-flow: column;
  grid-auto-columns: 78%;
  gap: 12px;
  overflow-x: auto;
  padding-bottom: 2px;
  scrollbar-width: none;
}

.horizontal-list::-webkit-scrollbar {
  display: none;
}

.building-card,
.stack-card,
.compose-card {
  padding: 18px;
}

.card-actions {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  margin-bottom: 8px;
}

.building-top,
.stack-meta,
.form-row,
.compose-actions {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.icon-btn {
  border: none;
  border-radius: 999px;
  padding: 8px 12px;
  background: rgba(255, 255, 255, 0.58);
  color: var(--text);
  font-size: 12px;
}

.building-icon {
  font-size: 28px;
}

.building-count,
.stack-meta {
  color: rgba(80, 127, 148, 0.84);
  font-size: 12px;
}

.building-card h4 {
  margin-top: 12px;
  font-size: 22px;
  letter-spacing: -0.04em;
}

.compose-card textarea,
.compose-card input,
.compose-card select {
  width: 100%;
  box-sizing: border-box;
  margin-top: 10px;
  border: none;
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.58);
  color: var(--text);
  padding: 12px 14px;
  outline: none;
}

.compose-card textarea::placeholder,
.compose-card input::placeholder {
  color: rgba(110, 135, 152, 0.72);
}

.feedback {
  margin-top: 10px;
  color: rgba(66, 133, 164, 0.92);
  font-size: 13px;
}

.stack-list {
  display: grid;
  gap: 10px;
  margin-top: 10px;
}

@media (min-width: 900px) {
  .island-page {
    max-width: 1280px;
    margin: 0 auto;
    padding-left: 24px;
    padding-right: 24px;
  }

  .overview-card {
    display: grid;
    grid-template-columns: minmax(0, 0.95fr) minmax(0, 1.05fr);
    gap: 18px;
    align-items: center;
  }

  .overview-copy {
    margin-top: 0;
  }

  .horizontal-list {
    grid-auto-columns: calc(33.333% - 8px);
  }
}
</style>
