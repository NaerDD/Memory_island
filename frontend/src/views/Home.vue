<template>
  <div class="home-page" id="topbar">
    <TopNav
      :nav-items="navItems"
      :is-logged-in="isLoggedIn"
      :user-name="currentUser.name"
      @navigate="handleNavNavigate"
      @go-auth="goAuth"
      @write="goWrite"
      @logout="logout"
    />

    <section class="hero-shell">
      <div class="hero-stage">
        <div class="sun-disc"></div>
        <div class="cloud cloud-a"></div>
        <div class="cloud cloud-b"></div>
        <div class="sea-band sea-band-a"></div>
        <div class="sea-band sea-band-b"></div>

        <button
          v-for="(building, index) in floatingBuildings"
          :key="building.id"
          class="stage-node"
          :class="`node-${index % 4}`"
          @click="goBuilding(building.id)"
        >
          <span>{{ building.icon }}</span>
          <small>{{ building.name }}</small>
        </button>
      </div>

      <div class="hero-copy">
        <p class="eyebrow">SUNNY MODE</p>
        <h1>今天，捡一枚回忆上岛。</h1>
        <p class="lead">轻一点，短一点，像在海边收集碎片。</p>

        <div class="hero-actions">
          <button class="primary-cta" @click="goWrite">马上记录</button>
          <button class="secondary-cta" @click="$router.push('/island')">逛逛小岛</button>
        </div>

        <div class="quest-card">
          <div class="quest-top">
            <span>今日任务</span>
            <button class="mini-wave" @click="rotateTopic">换一个</button>
          </div>
          <h2>{{ topic.question || '正在生成今日任务' }}</h2>
          <p>{{ topic.guide || '先从一个最小的细节开始。' }}</p>
        </div>
      </div>
    </section>

    <section class="progress-strip">
      <button class="progress-card active" @click="goWrite">
        <strong>{{ overview.memoryCount || 0 }}</strong>
        <span>已上岛</span>
      </button>
      <button class="progress-card" @click="$router.push('/island')">
        <strong>{{ buildings.length }}</strong>
        <span>地图点位</span>
      </button>
      <button class="progress-card" @click="$router.push('/memories')">
        <strong>{{ recentPosts.length }}</strong>
        <span>最近掉落</span>
      </button>
    </section>

    <section class="action-zone">
      <div class="section-head">
        <div>
          <p class="eyebrow">PLAY</p>
          <h2>下一步做什么</h2>
        </div>
      </div>

      <div class="action-grid">
        <button
          v-for="card in actionCards"
          :key="card.key"
          class="action-card"
          @click="card.onClick"
        >
          <span class="action-badge">{{ card.kicker }}</span>
          <h3>{{ card.title }}</h3>
          <p>{{ card.body }}</p>
        </button>
      </div>
    </section>

    <section class="recent-section" id="memories">
      <div class="section-head">
        <div>
          <p class="eyebrow">LOOT</p>
          <h2>刚捞起来的碎片</h2>
        </div>
        <button class="text-link" @click="$router.push('/memories')">查看全部</button>
      </div>

      <div class="recent-list">
        <article
          v-for="(post, index) in recentPosts"
          :key="post.id"
          class="recent-card"
          :class="`recent-${index % 4}`"
          @click="goMemoryDetail(post.id)"
        >
          <div class="recent-meta">
            <span>{{ post.category }}</span>
            <span>{{ post.date }}</span>
          </div>
          <h3>{{ post.title }}</h3>
          <p>{{ post.summary }}</p>
        </article>
      </div>
    </section>
  </div>
</template>

<script>
import TopNav from '../components/TopNav.vue'
import { getMemories, getNextTopic, getOverview, getTodayTopic } from '../api'

export default {
  name: 'Home',
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
      currentUser: {
        name: '',
        email: ''
      },
      overview: {
        memoryCount: 0
      },
      topic: null,
      buildings: [],
      recentPosts: []
    }
  },
  computed: {
    isLoggedIn() {
      return !!this.currentUser.email
    },
    floatingBuildings() {
      return this.buildings.slice(0, 4)
    },
    actionCards() {
      return [
        {
          key: 'write',
          kicker: '最快',
          title: '投下一条新回忆',
          body: '一句也行。',
          onClick: () => this.goWrite()
        },
        {
          key: 'island',
          kicker: '地图',
          title: '给小岛添一个地点',
          body: '让回忆有落点。',
          onClick: () => this.$router.push('/island')
        },
        {
          key: 'recent',
          kicker: '整理',
          title: '翻翻最近的碎片',
          body: '挑一条继续补写。',
          onClick: () => this.$router.push('/memories')
        }
      ]
    }
  },
  created() {
    this.loadUser()
    this.loadOverview()
    this.loadRecentPosts()
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
      this.overview = data || { memoryCount: 0 }
      this.buildings = data.buildings || []
    },
    async loadRecentPosts() {
      const { data } = await getMemories()
      this.recentPosts = (data || []).slice(0, 4).map(item => ({
        id: item.id,
        title: item.title,
        summary: item.excerpt || item.content,
        date: (item.happenedAt || '').replace(/-/g, '.'),
        category: item.buildingName || item.buildingType || '回忆'
      }))
    },
    async loadTopic() {
      const { data } = await getTodayTopic()
      this.topic = data
    },
    async rotateTopic() {
      const { data } = await getNextTopic()
      this.topic = data
    },
    handleNavNavigate(payload) {
      const targetId = payload.targetId
      const route = payload.route
      if (this.$route.path !== route) {
        this.$router.push(route).then(() => {
          this.$nextTick(() => {
            this.goSection(targetId)
          })
        }).catch(() => {})
        return
      }
      this.goSection(targetId)
    },
    goSection(id) {
      const el = document.getElementById(id)
      if (el) {
        el.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        })
      }
    },
    goAuth(mode) {
      this.$router.push({
        path: '/auth',
        query: { mode: mode }
      })
    },
    goMemoryDetail(id) {
      this.$router.push('/post/' + id)
    },
    goBuilding(id) {
      this.$router.push('/island/building/' + id)
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
    }
  }
}
</script>

<style scoped>
.home-page {
  min-height: 100vh;
  padding: 8px 14px 48px;
}

.hero-shell {
  margin-top: 14px;
  padding: 18px;
  border-radius: 34px;
  background: linear-gradient(180deg, rgba(255, 247, 226, 0.94), rgba(255, 239, 204, 0.9));
  box-shadow: var(--shadow-lg);
}

.hero-stage {
  position: relative;
  min-height: 260px;
  overflow: hidden;
  border-radius: 28px;
  background: linear-gradient(180deg, rgba(255, 236, 177, 0.86) 0%, rgba(147, 228, 239, 0.86) 62%, rgba(71, 191, 207, 0.96) 100%);
}

.sun-disc,
.cloud,
.sea-band {
  position: absolute;
}

.sun-disc {
  top: 18px;
  right: 24px;
  width: 92px;
  height: 92px;
  border-radius: 50%;
  background: radial-gradient(circle, #fff0a4 0%, #ffd363 58%, rgba(255, 211, 99, 0.24) 78%, transparent 78%);
}

.cloud {
  height: 22px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.54);
}

.cloud::before,
.cloud::after {
  content: '';
  position: absolute;
  background: rgba(255, 255, 255, 0.54);
  border-radius: 50%;
}

.cloud-a {
  top: 42px;
  left: 22px;
  width: 74px;
}

.cloud-a::before {
  width: 28px;
  height: 28px;
  left: 8px;
  top: -12px;
}

.cloud-a::after {
  width: 32px;
  height: 32px;
  right: 10px;
  top: -16px;
}

.cloud-b {
  top: 88px;
  left: 120px;
  width: 62px;
}

.cloud-b::before {
  width: 22px;
  height: 22px;
  left: 8px;
  top: -10px;
}

.cloud-b::after {
  width: 26px;
  height: 26px;
  right: 6px;
  top: -12px;
}

.sea-band {
  left: -12%;
  right: -12%;
  border-radius: 50%;
}

.sea-band-a {
  bottom: 46px;
  height: 76px;
  background: rgba(255, 255, 255, 0.22);
  animation: waveMove 8s ease-in-out infinite;
}

.sea-band-b {
  bottom: -10px;
  height: 110px;
  background: rgba(255, 228, 171, 0.72);
}

.stage-node {
  position: absolute;
  width: 88px;
  height: 88px;
  border: none;
  border-radius: 24px;
  background: rgba(255, 255, 255, 0.78);
  box-shadow: 0 18px 28px rgba(113, 166, 190, 0.18);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 6px;
  color: var(--text);
  animation: floatNode 5s ease-in-out infinite;
}

.stage-node span {
  font-size: 28px;
}

.stage-node small {
  max-width: 58px;
  font-size: 10px;
  line-height: 1.2;
  color: var(--muted);
}

.node-0 { left: 10%; top: 26%; }
.node-1 { right: 12%; top: 34%; animation-delay: 0.8s; }
.node-2 { left: 24%; bottom: 16%; animation-delay: 1.6s; }
.node-3 { right: 24%; bottom: 14%; animation-delay: 2.4s; }

.hero-copy {
  margin-top: 18px;
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
p {
  margin: 0;
}

h1 {
  max-width: 6.6em;
  font-size: clamp(2.6rem, 10vw, 4.8rem);
  line-height: 0.94;
  letter-spacing: -0.07em;
}

.lead {
  margin-top: 12px;
  color: var(--muted);
  line-height: 1.7;
}

.hero-actions {
  display: flex;
  gap: 10px;
  margin-top: 18px;
  flex-wrap: wrap;
}

.primary-cta,
.secondary-cta,
.mini-wave,
.text-link {
  border: none;
  background: transparent;
}

.primary-cta,
.secondary-cta,
.mini-wave {
  border-radius: 999px;
  padding: 12px 16px;
  font-size: 13px;
}

.primary-cta {
  background: linear-gradient(135deg, #2fc8c2, #3b8cff);
  color: #fff;
  font-weight: 700;
}

.secondary-cta,
.mini-wave {
  color: var(--text);
  background: rgba(255, 255, 255, 0.58);
}

.quest-card {
  margin-top: 18px;
  padding: 18px;
  border-radius: 24px;
  background: rgba(255, 255, 255, 0.56);
}

.quest-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.quest-top span {
  color: rgba(80, 127, 148, 0.84);
  font-size: 12px;
}

.quest-card h2 {
  margin-top: 10px;
  font-size: 24px;
  line-height: 1.2;
  letter-spacing: -0.04em;
}

.quest-card p {
  margin-top: 8px;
  color: var(--muted);
}

.progress-strip,
.action-zone,
.recent-section {
  margin-top: 18px;
}

.progress-strip {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;
}

.progress-card {
  border: none;
  border-radius: 24px;
  padding: 16px;
  background: rgba(255, 250, 239, 0.82);
  color: var(--text);
  box-shadow: var(--shadow-lg);
}

.progress-card strong {
  display: block;
  font-size: 28px;
  line-height: 1;
}

.progress-card span {
  display: block;
  margin-top: 8px;
  color: var(--muted);
  font-size: 12px;
}

.progress-card.active {
  background: linear-gradient(180deg, rgba(47, 200, 194, 0.18), rgba(255, 183, 79, 0.28));
}

.section-head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
}

.section-head h2 {
  font-size: 30px;
  line-height: 0.98;
  letter-spacing: -0.05em;
}

.text-link {
  color: rgba(80, 127, 148, 0.9);
  font-size: 13px;
}

.action-grid,
.recent-list {
  display: grid;
  gap: 12px;
}

.action-card,
.recent-card {
  text-align: left;
  border: none;
  border-radius: 24px;
  background: rgba(255, 250, 239, 0.82);
  padding: 18px;
  color: var(--text);
  box-shadow: var(--shadow-lg);
}

.action-badge,
.recent-meta {
  display: flex;
  justify-content: space-between;
  gap: 10px;
  color: rgba(80, 127, 148, 0.84);
  font-size: 12px;
}

.action-card h3,
.recent-card h3 {
  margin-top: 10px;
  font-size: 22px;
  line-height: 1.15;
  letter-spacing: -0.04em;
}

.action-card p,
.recent-card p {
  margin-top: 8px;
  color: var(--muted);
  line-height: 1.65;
}

.recent-0 { background: rgba(255, 247, 235, 0.92); }
.recent-1 { background: rgba(238, 252, 247, 0.92); }
.recent-2 { background: rgba(241, 247, 255, 0.92); }
.recent-3 { background: rgba(255, 240, 230, 0.92); }

@keyframes floatNode {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

@keyframes waveMove {
  0%, 100% { transform: translateX(-2%); }
  50% { transform: translateX(2%); }
}

@media (min-width: 760px) {
  .home-page {
    padding-left: 24px;
    padding-right: 24px;
    max-width: 1280px;
    margin: 0 auto;
  }

  .hero-shell {
    display: grid;
    grid-template-columns: minmax(0, 1.1fr) minmax(360px, 0.9fr);
    gap: 20px;
    align-items: stretch;
    min-height: 560px;
  }

  .hero-copy {
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
    margin-top: 0;
  }

  .action-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }

  .recent-list {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}
</style>
