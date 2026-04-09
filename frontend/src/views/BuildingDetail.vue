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

    <section class="page-wrap">
      <div class="container">
        <div v-if="building" class="building-hero">
          <div class="building-head">
            <span class="icon">{{ building.icon }}</span>
            <div>
              <p class="eyebrow">{{ building.type }}</p>
              <h1>{{ building.name }}</h1>
            </div>
          </div>
          <p class="summary">{{ building.summary }}</p>
        </div>

        <div v-if="building" class="filter-bar">
          <input
            v-model.trim="keyword"
            type="text"
            placeholder="按标题或内容搜索这座建筑里的回忆"
          />
          <span>{{ filteredMemories.length }} 条结果</span>
        </div>

        <div v-if="building && filteredMemories.length" class="memory-grid">
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
          <h2>这座建筑里还没有回忆</h2>
          <p>可以先写下第一条，让它开始长出自己的时间层。</p>
          <button class="ghost-btn" @click="goWrite">去写回忆</button>
        </div>
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
        { key: 'memories', label: '回忆', target: 'memories', route: '/memories' },
        { key: 'about', label: '关于', target: 'about', route: '/' }
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
  background: #f7f9fc;
}

.container {
  width: 100%;
  max-width: 1080px;
  margin: 0 auto;
  padding: 0 24px;
  box-sizing: border-box;
}

.page-wrap {
  padding: 136px 0 72px;
}

.building-hero,
.memory-card,
.empty-card {
  background: #fff;
  border: 1px solid rgba(17, 17, 17, 0.08);
  border-radius: 28px;
}

.building-hero {
  padding: 28px;
  margin-bottom: 24px;
}

.building-head {
  display: flex;
  gap: 16px;
  align-items: center;
}

.icon {
  font-size: 44px;
}

.eyebrow {
  margin: 0 0 8px;
  color: #708093;
  font-size: 13px;
  letter-spacing: 0.08em;
}

h1,
.empty-card h2 {
  margin: 0;
  font-size: clamp(2.1rem, 4vw, 3.6rem);
  letter-spacing: -0.04em;
}

.summary,
.memory-card p,
.empty-card p {
  margin: 14px 0 0;
  color: #5d6777;
  line-height: 1.9;
}

.memory-grid {
  display: grid;
  gap: 16px;
}

.filter-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 16px;
}

.filter-bar input {
  flex: 1;
  border: 1px solid rgba(17, 17, 17, 0.12);
  background: #fff;
  border-radius: 16px;
  padding: 14px 16px;
  font-size: 14px;
  outline: none;
}

.filter-bar span {
  color: #718092;
  font-size: 14px;
}

.memory-card {
  padding: 22px;
  cursor: pointer;
}

.memory-meta {
  display: flex;
  gap: 12px;
  color: #7a8290;
  font-size: 13px;
  margin-bottom: 10px;
}

.memory-card h3 {
  margin: 0 0 10px;
  font-size: 24px;
}

.empty-card {
  padding: 28px;
}

.ghost-btn {
  margin-top: 18px;
  border: 1px solid #111;
  background: #fff;
  color: #111;
  padding: 12px 18px;
  border-radius: 999px;
  cursor: pointer;
}

@media (max-width: 640px) {
  .page-wrap {
    padding-top: 118px;
  }

  .building-head {
    align-items: flex-start;
  }

  .filter-bar {
    flex-direction: column;
    align-items: stretch;
  }
}
</style>
