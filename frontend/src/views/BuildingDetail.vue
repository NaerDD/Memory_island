<template>
  <div class="building-page" id="topbar">
    <TopNav
      :nav-items="navItems"
      :is-logged-in="isLoggedIn"
      :user-name="currentUser.name"
      @navigate="handleNavNavigate"
      @go-auth="goAuth"
      @write="goWrite"
      @logout="logout"
    />

    <section class="building-shell">
      <div v-if="building" class="hero-card">
        <div class="hero-head">
          <div class="icon-block">{{ building.icon }}</div>
          <div>
            <p class="eyebrow">{{ building.type }}</p>
            <h1>{{ building.name }}</h1>
          </div>
        </div>
        <p class="summary">{{ building.summary }}</p>

        <div class="meta-strip">
          <span>{{ filteredMemories.length }} 条回忆</span>
          <button class="mini-btn" @click="goWrite">写进这里</button>
        </div>
      </div>

      <div v-if="building" class="search-card">
        <input
          v-model.trim="keyword"
          type="text"
          placeholder="在这个地点里找回忆"
        />
      </div>

      <div v-if="building && filteredMemories.length" class="memory-stack">
        <article
          v-for="memory in filteredMemories"
          :key="memory.id"
          class="memory-card"
          @click="$router.push('/post/' + memory.id)"
        >
          <div class="memory-meta">
            <span>{{ memory.happenedAt }}</span>
            <span>{{ memory.weather }}</span>
          </div>
          <h3>{{ memory.title }}</h3>
          <p>{{ memory.excerpt || memory.content }}</p>
        </article>
      </div>

      <div v-else class="empty-card">
        <h2>这里还没有回忆</h2>
        <p>先投下一条，让它长出第一层时间。</p>
        <button class="mini-btn primary" @click="goWrite">去记录</button>
      </div>
    </section>
  </div>
</template>

<script>
import TopNav from '../components/TopNav.vue'
import { getOverview } from '../api'

export default {
  name: 'BuildingDetail',
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
      building: null,
      keyword: ''
    }
  },
  computed: {
    isLoggedIn() {
      return !!this.currentUser.email
    },
    filteredMemories() {
      if (!this.building || !this.building.memories) {
        return []
      }
      const keyword = this.keyword.toLowerCase()
      if (!keyword) {
        return this.building.memories
      }
      return this.building.memories.filter(item => {
        const haystack = [item.title, item.content, item.excerpt].filter(Boolean).join(' ').toLowerCase()
        return haystack.includes(keyword)
      })
    }
  },
  created() {
    this.loadUser()
    this.loadBuilding()
  },
  watch: {
    '$route.params.id'() {
      this.loadBuilding()
    }
  },
  methods: {
    loadUser() {
      const raw = localStorage.getItem('memory-island-user')
      if (raw) {
        this.currentUser = JSON.parse(raw)
      }
    },
    async loadBuilding() {
      const { data } = await getOverview()
      const targetId = Number(this.$route.params.id)
      this.building = (data.buildings || []).find(item => Number(item.id) === targetId) || null
      this.keyword = ''
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
.building-page {
  min-height: 100vh;
  padding: 8px 14px 120px;
}

.building-shell {
  margin-top: 14px;
  display: grid;
  gap: 12px;
}

.hero-card,
.search-card,
.memory-card,
.empty-card {
  border: none;
  border-radius: 26px;
  background: rgba(255, 250, 239, 0.84);
  box-shadow: var(--shadow-lg);
}

.hero-card,
.search-card,
.memory-card,
.empty-card {
  padding: 18px;
}

.hero-head,
.meta-strip,
.memory-meta {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
}

.hero-head {
  align-items: flex-start;
}

.icon-block {
  width: 58px;
  height: 58px;
  border-radius: 18px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.62);
  font-size: 28px;
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
  font-size: clamp(2rem, 8vw, 3.4rem);
  line-height: 0.98;
  letter-spacing: -0.06em;
}

.summary,
.memory-card p,
.empty-card p {
  margin-top: 12px;
  color: var(--muted);
  line-height: 1.75;
}

.meta-strip {
  justify-content: space-between;
  margin-top: 16px;
  color: rgba(80, 127, 148, 0.84);
  font-size: 12px;
}

.search-card input {
  width: 100%;
  box-sizing: border-box;
  border: none;
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.62);
  color: var(--text);
  padding: 12px 14px;
  outline: none;
}

.search-card input::placeholder {
  color: rgba(110, 135, 152, 0.72);
}

.memory-stack {
  display: grid;
  gap: 10px;
}

.memory-meta {
  color: rgba(80, 127, 148, 0.84);
  font-size: 12px;
}

.memory-card h3 {
  margin-top: 10px;
  font-size: 22px;
  letter-spacing: -0.04em;
}

.mini-btn {
  border: none;
  border-radius: 999px;
  padding: 10px 14px;
  background: rgba(255, 255, 255, 0.58);
  color: var(--text);
}

.mini-btn.primary {
  background: linear-gradient(135deg, #2fc8c2, #3b8cff);
  color: #fff;
  font-weight: 700;
}

@media (min-width: 900px) {
  .building-page {
    max-width: 920px;
    margin: 0 auto;
    padding-left: 24px;
    padding-right: 24px;
  }
}
</style>
