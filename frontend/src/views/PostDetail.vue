<template>
  <div class="detail-page" id="topbar">
    <TopNav
      :nav-items="navItems"
      :is-logged-in="isLoggedIn"
      :user-name="currentUser.name"
      @navigate="handleNavNavigate"
      @go-auth="goAuth"
      @write="goWrite"
      @logout="logout"
    />

    <section class="detail-shell">
      <div v-if="memory" class="hero-card">
        <div class="hero-top">
          <span class="building-badge">{{ memory.buildingIcon }} {{ memory.buildingName || '回忆' }}</span>
          <button class="mini-btn" @click="$router.push('/memories')">返回列表</button>
        </div>

        <h1>{{ memory.title }}</h1>

        <div class="meta-row">
          <span>{{ memory.happenedAt || '未填写日期' }}</span>
          <span>{{ memory.weather || '此刻写下' }}</span>
          <span v-if="memory.mediaTypes && memory.mediaTypes.length">{{ memory.mediaTypes.join(' / ') }}</span>
        </div>

        <div v-if="memory.emotions && memory.emotions.length" class="tag-row">
          <span v-for="item in memory.emotions" :key="item" class="tag">{{ item }}</span>
        </div>
      </div>

      <div v-if="memory" class="content-card">
        <p v-for="(paragraph, index) in paragraphs" :key="index">{{ paragraph }}</p>
      </div>

      <div v-if="memory" class="action-strip">
        <button class="action-card" @click="$router.push('/island/building/' + (memory.buildingId || ''))">
          <strong>回到建筑</strong>
          <span>{{ memory.buildingName || '查看来源空间' }}</span>
        </button>
        <button class="action-card" @click="goWrite">
          <strong>继续写</strong>
          <span>把这个片段补完整</span>
        </button>
      </div>

      <div v-else class="empty-card">
        <h2>这条回忆暂时不存在</h2>
        <p>它可能还没有被保存，或者当前本地数据已经重置。</p>
        <button class="mini-btn primary" @click="$router.push('/memories')">返回回忆列表</button>
      </div>
    </section>
  </div>
</template>

<script>
import TopNav from '../components/TopNav.vue'
import { getMemoryDetail } from '../api'

export default {
  name: 'PostDetail',
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
      memory: null
    }
  },
  computed: {
    isLoggedIn() {
      return !!this.currentUser.email
    },
    paragraphs() {
      if (!this.memory || !this.memory.content) {
        return []
      }
      return this.memory.content.split(/\n+/).filter(Boolean)
    }
  },
  created() {
    this.loadUser()
    this.loadMemory()
  },
  watch: {
    '$route.params.id'() {
      this.loadMemory()
    }
  },
  methods: {
    loadUser() {
      const raw = localStorage.getItem('memory-island-user')
      if (raw) {
        this.currentUser = JSON.parse(raw)
      }
    },
    async loadMemory() {
      const { data } = await getMemoryDetail(this.$route.params.id)
      this.memory = data || null
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
    }
  }
}
</script>

<style scoped>
.detail-page {
  min-height: 100vh;
  padding: 8px 14px 120px;
}

.detail-shell {
  margin-top: 14px;
  display: grid;
  gap: 12px;
}

.hero-card,
.content-card,
.action-card,
.empty-card {
  border: 1px solid rgba(145, 214, 255, 0.1);
  border-radius: 26px;
  background: rgba(9, 24, 39, 0.72);
  box-shadow: 0 24px 70px rgba(0, 0, 0, 0.24);
}

.hero-card,
.content-card,
.empty-card {
  padding: 18px;
}

.hero-top,
.meta-row,
.tag-row,
.action-strip {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.hero-top {
  justify-content: space-between;
  align-items: center;
}

.building-badge,
.tag,
.meta-row {
  color: rgba(194, 227, 255, 0.76);
  font-size: 12px;
}

.building-badge,
.tag {
  padding: 8px 12px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.06);
}

h1,
h2,
p,
strong,
span {
  margin: 0;
}

h1 {
  margin-top: 14px;
  font-size: clamp(2.1rem, 8vw, 3.8rem);
  line-height: 0.96;
  letter-spacing: -0.06em;
}

.meta-row,
.tag-row {
  margin-top: 14px;
}

.content-card p,
.empty-card p {
  color: var(--muted);
  line-height: 1.85;
  font-size: 15px;
}

.content-card p + p {
  margin-top: 14px;
}

.action-strip {
  display: grid;
  grid-template-columns: 1fr 1fr;
}

.action-card {
  text-align: left;
  padding: 16px;
  border: 1px solid rgba(145, 214, 255, 0.1);
  color: #f3f9ff;
}

.action-card strong {
  display: block;
  font-size: 16px;
}

.action-card span {
  display: block;
  margin-top: 6px;
  color: var(--muted);
  font-size: 13px;
}

.mini-btn {
  border: none;
  border-radius: 999px;
  padding: 10px 14px;
  background: rgba(255, 255, 255, 0.06);
  color: #eff8ff;
}

.mini-btn.primary {
  background: linear-gradient(135deg, #7be7ff, #489eff);
  color: #05111c;
  font-weight: 700;
}

@media (max-width: 640px) {
  .action-strip {
    grid-template-columns: 1fr;
  }
}

@media (min-width: 900px) {
  .detail-page {
    max-width: 920px;
    margin: 0 auto;
    padding-left: 24px;
    padding-right: 24px;
  }
}
</style>
