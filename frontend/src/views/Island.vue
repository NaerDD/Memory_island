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
        <div class="overview-copy">
          <p class="eyebrow">ISLAND</p>
          <h1>{{ overview.islandName || '小岛记忆' }}</h1>
          <p>{{ overview.bio }}</p>
        </div>

        <div class="overview-stats">
          <div class="stat-pill">
            <strong>{{ overview.memoryCount || 0 }}</strong>
            <span>回忆</span>
          </div>
          <div class="stat-pill">
            <strong>{{ buildings.length }}</strong>
            <span>建筑</span>
          </div>
          <div v-if="overview.currentMood" class="stat-pill">
            <strong>{{ overview.currentMood.icon }}</strong>
            <span>{{ overview.currentMood.label }}</span>
          </div>
        </div>

        <div class="topic-card">
          <div>
            <small>今日海流</small>
            <h2>{{ topic.question || '正在准备今日话题' }}</h2>
            <p>{{ topic.guide || '写一个细节，让回忆有落点。' }}</p>
          </div>
          <button class="ghost-btn" @click="refreshTopic">换一个</button>
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
          <h3>建筑仓</h3>
          <button class="mini-btn" @click="goWrite">写到建筑里</button>
        </div>

        <div class="panel-card compose-card">
          <div class="form-row">
            <input v-model.trim="buildingForm.name" type="text" placeholder="建筑名称" />
            <input v-model.trim="buildingForm.icon" type="text" placeholder="图标，例如 🏕️" />
          </div>
          <div class="form-row">
            <input v-model.trim="buildingForm.type" type="text" placeholder="建筑类型，例如 关系圈子" />
            <button class="mini-btn primary" @click="submitBuilding">
              {{ editingBuildingId ? '保存建筑' : '创建建筑' }}
            </button>
          </div>
          <textarea
            v-model.trim="buildingForm.summary"
            rows="3"
            placeholder="这座建筑准备收纳哪一类回忆。"
          ></textarea>
          <div class="compose-actions">
            <p v-if="buildingMessage" class="feedback">{{ buildingMessage }}</p>
            <button v-if="editingBuildingId" class="mini-btn" @click="resetBuildingForm">取消编辑</button>
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
          <span>{{ bottles.length }} 个海面回音</span>
        </div>

        <div class="panel-card compose-card">
          <div class="form-row">
            <select v-model="bottleForm.mood">
              <option value="calm">平静</option>
              <option value="happy">轻快</option>
              <option value="nostalgia">怀念</option>
              <option value="lonely">孤单</option>
            </select>
            <button class="mini-btn primary" @click="submitBottle">投递</button>
          </div>
          <textarea
            v-model.trim="bottleForm.content"
            rows="4"
            placeholder="把一句想说的话交给海面。"
          ></textarea>
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
          <span>{{ collections.length }} 份共同回忆</span>
        </div>

        <div class="panel-card compose-card">
          <input v-model.trim="collectionForm.name" type="text" placeholder="合集名称" />
          <input v-model.trim="collectionForm.members" type="text" placeholder="参与成员，例如：你, 阿宁" />
          <textarea
            v-model.trim="collectionForm.summary"
            rows="3"
            placeholder="这份共同回忆想保存什么。"
          ></textarea>
          <div class="compose-actions">
            <p v-if="collectionMessage" class="feedback">{{ collectionMessage }}</p>
            <button class="mini-btn primary" @click="submitCollection">创建合集</button>
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
        { key: 'memories', label: '回忆', target: 'memories', route: '/memories' },
        { key: 'about', label: '关于', target: 'topbar', route: '/' }
      ],
      segments: [
        { key: 'buildings', label: '建筑' },
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
      this.buildingMessage = '正在编辑这座建筑。'
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
        this.buildingMessage = '名称、类型和简介都需要填写。'
        return
      }
      if (this.editingBuildingId) {
        await updateBuilding(this.editingBuildingId, {
          ...this.buildingForm,
          icon: this.buildingForm.icon || '🏝️'
        })
        this.resetBuildingForm()
        this.buildingMessage = '建筑信息已更新。'
      } else {
        await createBuilding({
          ...this.buildingForm,
          icon: this.buildingForm.icon || '🏝️'
        })
        this.resetBuildingForm()
        this.buildingMessage = '新建筑已经放上岛。'
      }
      await this.loadOverview()
    },
    async submitBottle() {
      this.bottleMessage = ''
      if (!this.bottleForm.content) {
        this.bottleMessage = '先写一点想交给海面的内容。'
        return
      }
      await createBottle(this.bottleForm)
      this.bottleForm.content = ''
      this.bottleMessage = '已经投出漂流瓶。'
      await this.loadOverview()
    },
    async submitCollection() {
      this.collectionMessage = ''
      if (!this.collectionForm.name || !this.collectionForm.members || !this.collectionForm.summary) {
        this.collectionMessage = '名称、成员和简介都要填。'
        return
      }
      await createCollection(this.collectionForm)
      this.collectionForm = {
        name: '',
        members: '',
        summary: ''
      }
      this.collectionMessage = '共享合集已经创建。'
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
  border: 1px solid rgba(145, 214, 255, 0.1);
  border-radius: 28px;
  background: rgba(9, 24, 39, 0.72);
  box-shadow: 0 24px 70px rgba(0, 0, 0, 0.24);
}

.overview-card {
  padding: 20px;
}

.eyebrow {
  margin: 0 0 8px;
  color: rgba(159, 212, 255, 0.7);
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
  line-height: 0.98;
  letter-spacing: -0.06em;
}

.overview-copy p:last-child,
.topic-card p,
.building-card p,
.stack-card p {
  color: var(--muted);
  line-height: 1.7;
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
  background: rgba(255, 255, 255, 0.05);
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
  background: linear-gradient(180deg, rgba(123, 231, 255, 0.1), rgba(72, 158, 255, 0.08));
  display: flex;
  justify-content: space-between;
  gap: 12px;
}

.topic-card small {
  color: rgba(201, 233, 255, 0.7);
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
  background: rgba(255, 255, 255, 0.06);
  color: #eff8ff;
  white-space: nowrap;
}

.mini-btn.primary {
  background: linear-gradient(135deg, #7be7ff, #489eff);
  color: #05111c;
  font-weight: 700;
}

.segment-bar {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
  margin-top: 14px;
}

.segment-btn {
  min-height: 44px;
  background: rgba(255, 255, 255, 0.04);
  color: rgba(219, 236, 255, 0.7);
}

.segment-btn.active {
  background: linear-gradient(135deg, rgba(123, 231, 255, 0.2), rgba(72, 158, 255, 0.16));
  color: #f8fcff;
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
  background: rgba(255, 255, 255, 0.06);
  color: rgba(231, 244, 255, 0.84);
  font-size: 12px;
}

.building-icon {
  font-size: 28px;
}

.building-count,
.stack-meta {
  color: rgba(201, 233, 255, 0.7);
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
  border: 1px solid rgba(145, 214, 255, 0.12);
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.04);
  color: #f3f9ff;
  padding: 12px 14px;
  outline: none;
}

.compose-card textarea::placeholder,
.compose-card input::placeholder {
  color: rgba(190, 214, 236, 0.42);
}

.feedback {
  margin-top: 10px;
  color: rgba(179, 239, 255, 0.78);
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

  .horizontal-list {
    grid-auto-columns: calc(33.333% - 8px);
  }
}
</style>
