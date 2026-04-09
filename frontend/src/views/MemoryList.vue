<template>
  <div class="memory-list-page" id="topbar">
    <TopNav
      :nav-items="navItems"
      :is-logged-in="isLoggedIn"
      :user-name="currentUser.name"
      @navigate="handleNavNavigate"
      @go-auth="goAuth"
      @write="goWrite"
      @logout="logout"
    />

    <section class="memory-shell">
      <div class="header-card">
        <p class="eyebrow">MEMORIES</p>
        <h1>回忆仓库</h1>
        <p>快速筛选、快速翻看，也可以直接继续编辑或清理掉不想保留的片段。</p>

        <div class="header-stats">
          <span>{{ filteredMemories.length }} 条结果</span>
          <span>{{ usingMock ? '本地模式' : '服务端模式' }}</span>
        </div>
      </div>

      <div class="filter-card">
        <input
          v-model.trim="filters.keyword"
          type="text"
          placeholder="搜标题、内容或建筑名"
          @keyup.enter="handleSearch"
        />
        <div class="filter-row">
          <input v-model="filters.date" type="date" />
          <button class="mini-btn primary" @click="handleSearch">筛选</button>
          <button class="mini-btn" @click="handleReset">重置</button>
        </div>
        <div class="emotion-row">
          <button
            v-for="emotion in emotionOptions"
            :key="emotion"
            class="emotion-chip"
            :class="{ active: filters.emotion === emotion }"
            @click="toggleEmotion(emotion)"
          >
            {{ emotion }}
          </button>
        </div>
      </div>

      <div v-if="pagedMemories.length === 0" class="empty-card">
        <h2>没有找到符合条件的回忆</h2>
        <p>换个关键词、情绪标签，或者先去写下一条新的片段。</p>
        <button class="mini-btn primary" @click="goWrite">写回忆</button>
      </div>

      <div v-else class="memory-stack">
        <article
          v-for="item in pagedMemories"
          :key="item.id"
          class="memory-card"
          @click="goMemoryDetail(item.id)"
        >
          <div class="memory-meta">
            <span>{{ item.category }}</span>
            <span>{{ item.date }}</span>
          </div>
          <h3>{{ item.title }}</h3>
          <p>{{ item.summary }}</p>
          <div class="tag-row">
            <span v-for="emotion in item.emotions" :key="emotion" class="tag">{{ emotion }}</span>
          </div>
          <div class="card-actions">
            <button class="mini-btn" @click.stop="editMemory(item.id)">编辑</button>
            <button class="mini-btn danger" @click.stop="removeMemory(item.id)">删除</button>
          </div>
        </article>
      </div>

      <div v-if="totalPages > 1" class="pager">
        <button class="page-chip" :disabled="currentPage === 1" @click="changePage(currentPage - 1)">上一页</button>
        <button
          v-for="page in visiblePages"
          :key="page"
          class="page-chip"
          :class="{ active: currentPage === page }"
          @click="changePage(page)"
        >
          {{ page }}
        </button>
        <button class="page-chip" :disabled="currentPage === totalPages" @click="changePage(currentPage + 1)">下一页</button>
      </div>
    </section>
  </div>
</template>

<script>
import TopNav from '../components/TopNav.vue'
import { deleteMemory, getMemories } from '../api'

export default {
  name: 'MemoryList',
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
      filters: {
        keyword: '',
        date: '',
        emotion: ''
      },
      appliedFilters: {
        keyword: '',
        date: '',
        emotion: ''
      },
      currentPage: 1,
      pageSize: 6,
      memories: [],
      usingMock: false
    }
  },
  computed: {
    isLoggedIn() {
      return !!this.currentUser.email
    },
    emotionOptions() {
      const bucket = new Set()
      this.memories.forEach(item => {
        ;(item.emotions || []).forEach(emotion => bucket.add(emotion))
      })
      return Array.from(bucket)
    },
    sortedMemories() {
      return [...this.memories].sort((a, b) => new Date(b.date) - new Date(a.date))
    },
    filteredMemories() {
      return this.sortedMemories.filter(item => {
        const keyword = this.appliedFilters.keyword.toLowerCase()
        const source = `${item.title} ${item.summary} ${item.category}`.toLowerCase()
        const matchKeyword = keyword ? source.includes(keyword) : true
        const matchDate = this.appliedFilters.date ? item.date === this.appliedFilters.date : true
        const matchEmotion = this.appliedFilters.emotion
          ? (item.emotions || []).includes(this.appliedFilters.emotion)
          : true
        return matchKeyword && matchDate && matchEmotion
      })
    },
    totalPages() {
      return Math.max(1, Math.ceil(this.filteredMemories.length / this.pageSize))
    },
    pagedMemories() {
      const start = (this.currentPage - 1) * this.pageSize
      return this.filteredMemories.slice(start, start + this.pageSize)
    },
    visiblePages() {
      return Array.from({ length: this.totalPages }, (_, index) => index + 1)
    }
  },
  created() {
    this.loadUser()
    this.loadMemories()
  },
  methods: {
    loadUser() {
      const raw = localStorage.getItem('memory-island-user')
      if (raw) {
        this.currentUser = JSON.parse(raw)
      }
    },
    handleNavNavigate(payload) {
      if (this.$route.path !== payload.route) {
        this.$router.push(payload.route)
      }
    },
    goAuth(mode) {
      this.$router.push({
        path: '/auth',
        query: { mode: mode }
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
    async loadMemories() {
      const { data, usingMock } = await getMemories()
      this.usingMock = usingMock
      this.memories = (data || []).map(item => ({
        id: item.id,
        title: item.title,
        summary: item.excerpt || item.content,
        date: item.happenedAt,
        category: item.buildingName || item.buildingType || '回忆',
        emotions: item.emotions || []
      }))
      this.handleSearch()
    },
    logout() {
      localStorage.removeItem('memory-island-user')
      this.currentUser = {
        name: '',
        email: ''
      }
    },
    toggleEmotion(emotion) {
      this.filters.emotion = this.filters.emotion === emotion ? '' : emotion
      this.handleSearch()
    },
    handleSearch() {
      this.appliedFilters = {
        keyword: this.filters.keyword,
        date: this.filters.date,
        emotion: this.filters.emotion
      }
      this.currentPage = 1
    },
    handleReset() {
      this.filters = {
        keyword: '',
        date: '',
        emotion: ''
      }
      this.appliedFilters = {
        keyword: '',
        date: '',
        emotion: ''
      }
      this.currentPage = 1
    },
    changePage(page) {
      if (page < 1 || page > this.totalPages) {
        return
      }
      this.currentPage = page
      window.scrollTo({ top: 0, behavior: 'smooth' })
    },
    goMemoryDetail(id) {
      this.$router.push('/post/' + id)
    },
    editMemory(id) {
      this.$router.push({
        path: '/write',
        query: { memoryId: String(id) }
      })
    },
    async removeMemory(id) {
      const confirmed = window.confirm('确认删除这条回忆吗？删除后评论也会一起移除。')
      if (!confirmed) {
        return
      }
      await deleteMemory(id)
      await this.loadMemories()
    }
  }
}
</script>

<style scoped>
.memory-list-page {
  min-height: 100vh;
  padding: 8px 14px 120px;
}

.memory-shell {
  margin-top: 14px;
}

.header-card,
.filter-card,
.memory-card,
.empty-card {
  border: 1px solid rgba(145, 214, 255, 0.1);
  border-radius: 26px;
  background: rgba(9, 24, 39, 0.72);
  box-shadow: 0 24px 70px rgba(0, 0, 0, 0.24);
}

.header-card,
.filter-card,
.memory-card,
.empty-card {
  padding: 18px;
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
p {
  margin: 0;
}

h1 {
  font-size: clamp(2rem, 8vw, 3.4rem);
  line-height: 0.98;
  letter-spacing: -0.06em;
}

.header-card p:last-child,
.memory-card p,
.empty-card p {
  margin-top: 10px;
  color: var(--muted);
  line-height: 1.7;
}

.header-stats,
.memory-meta,
.filter-row,
.pager,
.tag-row,
.card-actions,
.emotion-row {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}

.header-stats {
  margin-top: 14px;
}

.header-stats span,
.memory-meta {
  color: rgba(194, 227, 255, 0.72);
  font-size: 12px;
}

.filter-card {
  margin-top: 12px;
}

.filter-card input {
  width: 100%;
  box-sizing: border-box;
  border: 1px solid rgba(145, 214, 255, 0.12);
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.04);
  color: #f3f9ff;
  padding: 12px 14px;
  outline: none;
}

.filter-card input::placeholder {
  color: rgba(190, 214, 236, 0.42);
}

.filter-row,
.emotion-row,
.tag-row,
.card-actions {
  margin-top: 10px;
}

.filter-row input {
  flex: 1;
}

.mini-btn,
.page-chip,
.emotion-chip,
.tag {
  border: none;
  border-radius: 999px;
  padding: 10px 14px;
  background: rgba(255, 255, 255, 0.06);
  color: #eff8ff;
}

.mini-btn.primary,
.page-chip.active,
.emotion-chip.active {
  background: linear-gradient(135deg, #7be7ff, #489eff);
  color: #05111c;
  font-weight: 700;
}

.mini-btn.danger {
  background: rgba(255, 120, 120, 0.12);
  color: #ffb8b8;
}

.emotion-chip,
.tag {
  padding: 8px 12px;
  font-size: 12px;
}

.memory-stack {
  display: grid;
  gap: 10px;
  margin-top: 12px;
}

.memory-card {
  cursor: pointer;
}

.memory-card h3 {
  margin-top: 10px;
  font-size: 22px;
  letter-spacing: -0.04em;
}

.empty-card {
  margin-top: 12px;
}

.empty-card .mini-btn {
  margin-top: 14px;
}

.pager {
  margin-top: 12px;
  justify-content: center;
}

.page-chip:disabled {
  opacity: 0.4;
}

@media (min-width: 900px) {
  .memory-list-page {
    max-width: 920px;
    margin: 0 auto;
    padding-left: 24px;
    padding-right: 24px;
  }
}
</style>
