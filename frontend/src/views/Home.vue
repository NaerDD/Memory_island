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
      <div class="hero-ocean" :style="{ transform: `translateY(${heroDrift}px)` }">
        <div class="sea-glow sea-glow-a"></div>
        <div class="sea-glow sea-glow-b"></div>
        <div class="tide-ring tide-ring-a"></div>
        <div class="tide-ring tide-ring-b"></div>
        <button
          v-for="(building, index) in floatingBuildings"
          :key="building.id"
          class="memory-orb"
          :class="`orb-${index % 4}`"
          @click="goBuilding(building.id)"
        >
          <span>{{ building.icon }}</span>
          <small>{{ building.name }}</small>
        </button>
      </div>

      <div class="hero-copy">
        <p class="eyebrow">MOBILE MEMORY APP</p>
        <h1>把回忆养成一座会发光的小岛</h1>
        <p class="lead">
          首页不是公告板，而是你每天愿意点开的海面。话题、建筑、碎片和心情，在这里一起浮起来。
        </p>

        <div class="hero-actions">
          <button class="primary-cta" @click="goWrite">开始记录</button>
          <button class="secondary-cta" @click="$router.push('/island')">进入小岛</button>
        </div>

        <div class="hero-pulse">
          <div class="pulse-label">今日海流</div>
          <div class="pulse-card">
            <h2>{{ topic.question || '正在生成海风里的提示' }}</h2>
            <p>{{ topic.guide || '先写一个能被想起来的细节。' }}</p>
            <button class="mini-wave" @click="rotateTopic">换个问题</button>
          </div>
        </div>
      </div>
    </section>

    <section class="quick-deck">
      <button class="quick-card" @click="$router.push('/island')">
        <strong>{{ islandName }}</strong>
        <span>查看建筑与海面动态</span>
      </button>
      <button class="quick-card active" @click="goWrite">
        <strong>{{ overview.memoryCount || 0 }} 条回忆</strong>
        <span>继续往岛上投放片段</span>
      </button>
      <button class="quick-card" @click="$router.push('/memories')">
        <strong>{{ recentPosts.length }} 条最新内容</strong>
        <span>浏览最近留下的文字</span>
      </button>
    </section>

    <section class="story-rail">
      <div class="section-head">
        <div>
          <p class="eyebrow">FLOW</p>
          <h2>此刻适合从哪里开始</h2>
        </div>
        <button class="text-link" @click="$router.push('/island')">查看全部</button>
      </div>

      <div class="feature-carousel">
        <button
          v-for="(feature, index) in featureCards"
          :key="feature.key"
          class="feature-card"
          :class="{ active: activeFeature === index }"
          @click="activeFeature = index"
        >
          <div class="feature-top">
            <span>{{ feature.kicker }}</span>
            <strong>{{ feature.metric }}</strong>
          </div>
          <h3>{{ feature.title }}</h3>
          <p>{{ feature.body }}</p>
        </button>
      </div>
    </section>

    <section class="recent-section" id="memories">
      <div class="section-head">
        <div>
          <p class="eyebrow">RECENT</p>
          <h2>刚刚浮上来的回忆</h2>
        </div>
        <button class="text-link" @click="$router.push('/memories')">回忆列表</button>
      </div>

      <div class="recent-list">
        <article
          v-for="(post, index) in recentPosts"
          :key="post.id"
          class="recent-card"
          :class="`recent-${index % 3}`"
          @click="goMemoryDetail(post.id)"
        >
          <div class="recent-meta">
            <span>{{ post.date }}</span>
            <span>{{ post.category }}</span>
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
        { key: 'memories', label: '回忆', target: 'memories', route: '/memories' },
        { key: 'about', label: '关于', target: 'topbar', route: '/' }
      ],
      currentUser: {
        name: '',
        email: ''
      },
      overview: {
        memoryCount: 0
      },
      islandName: '雾灯岛',
      topic: null,
      buildings: [],
      recentPosts: [],
      activeFeature: 0,
      heroDrift: 0,
      autoRotateId: null
    }
  },
  computed: {
    isLoggedIn() {
      return !!this.currentUser.email
    },
    floatingBuildings() {
      return this.buildings.slice(0, 4)
    },
    featureCards() {
      const buildingCards = this.buildings.slice(0, 3).map(item => ({
        key: `building-${item.id}`,
        kicker: item.type,
        metric: `${item.memories.length} 条`,
        title: item.name,
        body: item.summary
      }))
      const supportCards = [
        {
          key: 'topic',
          kicker: '今日话题',
          metric: '海流',
          title: this.topic ? this.topic.question : '正在准备提示',
          body: this.topic ? this.topic.guide : '把一个细节重新说清楚，回忆就会出现层次。'
        },
        {
          key: 'archive',
          kicker: '回忆密度',
          metric: `${this.overview.memoryCount || 0} 条`,
          title: '最近的碎片已经开始堆出新的地形',
          body: '移动端首页会优先把最近的内容、最活跃的建筑和可继续操作的入口推到手边。'
        }
      ]
      return [...buildingCards, ...supportCards]
    }
  },
  created() {
    this.loadUser()
    this.loadOverview()
    this.loadRecentPosts()
    this.loadTopic()
  },
  mounted() {
    window.addEventListener('scroll', this.handleScroll, { passive: true })
    this.startFeatureAutoRotate()
  },
  beforeDestroy() {
    window.removeEventListener('scroll', this.handleScroll)
    if (this.autoRotateId) {
      window.clearInterval(this.autoRotateId)
    }
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
      this.islandName = data.islandName || '雾灯岛'
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
    startFeatureAutoRotate() {
      this.autoRotateId = window.setInterval(() => {
        if (!this.featureCards.length) {
          return
        }
        this.activeFeature = (this.activeFeature + 1) % this.featureCards.length
      }, 3200)
    },
    handleScroll() {
      const scrollTop = window.pageYOffset || document.documentElement.scrollTop || 0
      this.heroDrift = Math.min(scrollTop * 0.08, 24)
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
  position: relative;
  margin-top: 14px;
  padding: 28px 18px 18px;
  border: 1px solid rgba(145, 214, 255, 0.12);
  border-radius: 34px;
  overflow: hidden;
  background:
    radial-gradient(circle at top, rgba(122, 231, 255, 0.08), transparent 34%),
    linear-gradient(180deg, rgba(9, 24, 39, 0.84), rgba(5, 15, 25, 0.96));
  box-shadow: 0 24px 90px rgba(0, 0, 0, 0.28);
}

.hero-ocean {
  position: relative;
  min-height: 320px;
  border-radius: 28px;
  overflow: hidden;
  background:
    radial-gradient(circle at 50% 20%, rgba(155, 240, 255, 0.18), transparent 30%),
    linear-gradient(180deg, rgba(33, 84, 117, 0.18), rgba(7, 18, 29, 0.1));
}

.sea-glow,
.tide-ring {
  position: absolute;
  border-radius: 50%;
}

.sea-glow-a {
  inset: auto auto 14% 12%;
  width: 180px;
  height: 180px;
  background: radial-gradient(circle, rgba(123, 231, 255, 0.3), transparent 68%);
  animation: floatGlow 9s ease-in-out infinite;
}

.sea-glow-b {
  top: 10%;
  right: 8%;
  width: 220px;
  height: 220px;
  background: radial-gradient(circle, rgba(72, 158, 255, 0.22), transparent 72%);
  animation: floatGlow 12s ease-in-out infinite reverse;
}

.tide-ring {
  border: 1px solid rgba(145, 214, 255, 0.14);
}

.tide-ring-a {
  left: 10%;
  bottom: -28%;
  width: 300px;
  height: 300px;
  animation: pulseRing 6s linear infinite;
}

.tide-ring-b {
  right: -10%;
  top: 6%;
  width: 240px;
  height: 240px;
  animation: pulseRing 8s linear infinite;
}

.memory-orb {
  position: absolute;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  width: 92px;
  height: 92px;
  border: 1px solid rgba(161, 223, 255, 0.18);
  border-radius: 50%;
  background: linear-gradient(180deg, rgba(14, 44, 70, 0.82), rgba(8, 23, 36, 0.86));
  color: #f4fbff;
  box-shadow: 0 14px 30px rgba(0, 0, 0, 0.24);
  padding: 16px 8px;
  animation: orbitBob 4.8s ease-in-out infinite;
}

.memory-orb span {
  font-size: 28px;
}

.memory-orb small {
  max-width: 60px;
  font-size: 10px;
  line-height: 1.2;
  color: rgba(236, 247, 255, 0.78);
}

.orb-0 { left: 8%; top: 16%; }
.orb-1 { right: 10%; top: 12%; animation-delay: 1s; }
.orb-2 { left: 20%; bottom: 14%; animation-delay: 1.8s; }
.orb-3 { right: 18%; bottom: 8%; animation-delay: 2.4s; }

.hero-copy {
  position: relative;
  z-index: 1;
  margin-top: 20px;
}

.eyebrow {
  margin: 0 0 10px;
  color: rgba(159, 212, 255, 0.72);
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
  max-width: 7em;
  font-size: clamp(2.4rem, 10vw, 4.8rem);
  line-height: 0.96;
  letter-spacing: -0.06em;
}

.lead {
  margin-top: 14px;
  max-width: 30em;
  color: var(--muted);
  line-height: 1.8;
  font-size: 15px;
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
  background: linear-gradient(135deg, #7be7ff, #489eff);
  color: #05111c;
  font-weight: 700;
}

.secondary-cta,
.mini-wave {
  color: #eff8ff;
  background: rgba(255, 255, 255, 0.06);
  border: 1px solid rgba(145, 214, 255, 0.12);
}

.hero-pulse {
  margin-top: 20px;
}

.pulse-label {
  margin-bottom: 8px;
  color: rgba(159, 212, 255, 0.72);
  font-size: 12px;
}

.pulse-card {
  padding: 18px;
  border-radius: 24px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.07), rgba(255, 255, 255, 0.03));
  border: 1px solid rgba(145, 214, 255, 0.12);
}

.pulse-card h2 {
  font-size: 24px;
  line-height: 1.24;
  letter-spacing: -0.04em;
}

.pulse-card p {
  margin-top: 10px;
  color: var(--muted);
  line-height: 1.7;
  font-size: 14px;
}

.mini-wave {
  margin-top: 14px;
}

.quick-deck,
.story-rail,
.recent-section {
  margin-top: 18px;
}

.quick-deck {
  display: grid;
  gap: 12px;
}

.quick-card {
  text-align: left;
  border: 1px solid rgba(145, 214, 255, 0.1);
  border-radius: 24px;
  padding: 18px;
  background: rgba(9, 24, 39, 0.68);
  color: #eff8ff;
  box-shadow: var(--shadow-lg);
}

.quick-card strong {
  display: block;
  font-size: 18px;
}

.quick-card span {
  display: block;
  margin-top: 6px;
  color: var(--muted);
  font-size: 13px;
}

.quick-card.active {
  background: linear-gradient(135deg, rgba(72, 158, 255, 0.26), rgba(123, 231, 255, 0.12));
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
  color: rgba(194, 227, 255, 0.76);
  font-size: 13px;
}

.feature-carousel,
.recent-list {
  display: grid;
  gap: 12px;
}

.feature-card,
.recent-card {
  text-align: left;
  border: 1px solid rgba(145, 214, 255, 0.1);
  border-radius: 24px;
  background: rgba(9, 24, 39, 0.68);
  padding: 18px;
  color: #eff8ff;
}

.feature-card {
  transform: scale(0.985);
  opacity: 0.74;
  transition: transform 0.28s ease, opacity 0.28s ease, border-color 0.28s ease;
}

.feature-card.active {
  transform: scale(1);
  opacity: 1;
  border-color: rgba(123, 231, 255, 0.24);
  background: linear-gradient(180deg, rgba(14, 34, 56, 0.9), rgba(8, 20, 32, 0.94));
}

.feature-top,
.recent-meta {
  display: flex;
  justify-content: space-between;
  gap: 10px;
  color: rgba(194, 227, 255, 0.72);
  font-size: 12px;
}

.feature-card h3,
.recent-card h3 {
  margin-top: 12px;
  font-size: 22px;
  line-height: 1.15;
  letter-spacing: -0.04em;
}

.feature-card p,
.recent-card p {
  margin-top: 10px;
  color: var(--muted);
  line-height: 1.75;
  font-size: 14px;
}

.recent-0 {
  background: linear-gradient(180deg, rgba(12, 32, 51, 0.92), rgba(8, 19, 30, 0.94));
}

.recent-1 {
  background: linear-gradient(180deg, rgba(20, 38, 53, 0.92), rgba(10, 18, 28, 0.94));
}

.recent-2 {
  background: linear-gradient(180deg, rgba(15, 35, 47, 0.92), rgba(7, 17, 28, 0.94));
}

@keyframes orbitBob {
  0%, 100% { transform: translateY(0px) scale(1); }
  50% { transform: translateY(-8px) scale(1.02); }
}

@keyframes pulseRing {
  0% { transform: scale(0.92); opacity: 0.28; }
  50% { transform: scale(1); opacity: 0.46; }
  100% { transform: scale(1.08); opacity: 0.18; }
}

@keyframes floatGlow {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-14px); }
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
    min-height: 640px;
  }

  .hero-copy {
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
    margin-top: 0;
  }

  .quick-deck,
  .feature-carousel,
  .recent-list {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }

  .recent-list {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}
</style>
