<template>
  <div class="write-page" id="topbar">
    <TopNav
      :nav-items="navItems"
      :is-logged-in="isLoggedIn"
      :user-name="currentUser.name"
      @navigate="handleNavNavigate"
      @go-auth="goAuth"
      @write="goWrite"
      @logout="logout"
    />

    <section class="write-shell">
      <div class="intro-card">
        <p class="eyebrow">WRITE MEMORY</p>
        <h1>把一个片段沉到岛里</h1>
        <p>这页只做一件事：尽快把你此刻记得住的部分写下来，然后再慢慢补细节。</p>
      </div>

      <div class="topic-card">
        <small>今日提示</small>
        <h2>{{ topic.question || '正在准备问题' }}</h2>
        <p>{{ topic.guide || '先写一个细节，之后再补完整。' }}</p>
      </div>

      <div class="sheet-card">
        <div class="field-stack">
          <label>放进哪座建筑</label>
          <select v-model="form.buildingId">
            <option value="">请选择建筑</option>
            <option v-for="building in buildings" :key="building.id" :value="String(building.id)">
              {{ building.icon }} {{ building.name }}
            </option>
          </select>
        </div>

        <div class="field-row">
          <div class="field-stack">
            <label>发生时间</label>
            <input v-model="form.happenedAt" type="date" />
          </div>

          <div class="field-stack">
            <label>媒介形式</label>
            <input v-model.trim="form.mediaType" type="text" placeholder="文字,图片" />
          </div>
        </div>

        <div class="field-stack">
          <label>标题</label>
          <input v-model.trim="form.title" type="text" placeholder="例如：第一次认真看海的那天" />
        </div>

        <div class="field-stack">
          <label>内容</label>
          <textarea
            v-model.trim="form.content"
            rows="9"
            placeholder="先写下你记得住的味道、天气、谁在场、当时身体是什么感觉。"
          ></textarea>
        </div>

        <p v-if="errorMsg" class="message error">{{ errorMsg }}</p>
        <p v-if="successMsg" class="message success">{{ successMsg }}</p>

        <div class="submit-row">
          <button class="primary-btn" :disabled="submitting" @click="submit">
            {{ submitting ? '保存中...' : '保存回忆' }}
          </button>
          <button class="ghost-btn" @click="goMemoryList">回忆列表</button>
        </div>
      </div>

      <div class="building-strip">
        <div class="strip-head">
          <h3>建筑提示</h3>
          <span>{{ buildings.length }} 座</span>
        </div>
        <div class="strip-scroll">
          <article v-for="building in buildings" :key="building.id" class="building-chip">
            <strong>{{ building.icon }} {{ building.name }}</strong>
            <p>{{ building.summary }}</p>
          </article>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import TopNav from '../components/TopNav.vue'
import { createMemory, getOverview, getTodayTopic } from '../api'

export default {
  name: 'WriteMemory',
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
      buildings: [],
      topic: {},
      form: {
        buildingId: '',
        happenedAt: '',
        title: '',
        mediaType: '文字',
        content: ''
      },
      submitting: false,
      errorMsg: '',
      successMsg: ''
    }
  },
  computed: {
    isLoggedIn() {
      return !!this.currentUser.email
    }
  },
  created() {
    this.loadUser()
    if (!this.isLoggedIn) {
      this.$router.replace({
        path: '/auth',
        query: { mode: 'login' }
      })
      return
    }
    this.loadOverview()
    this.loadTopic()
    this.form.happenedAt = this.today()
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
      this.buildings = data.buildings || []
      if (this.buildings.length && !this.form.buildingId) {
        this.form.buildingId = String(this.buildings[0].id)
      }
    },
    async loadTopic() {
      const { data } = await getTodayTopic()
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
      this.$router.push('/write')
    },
    goMemoryList() {
      this.$router.push('/memories')
    },
    logout() {
      localStorage.removeItem('memory-island-user')
      this.currentUser = {
        name: '',
        email: ''
      }
      this.$router.push('/')
    },
    today() {
      const now = new Date()
      const year = now.getFullYear()
      const month = String(now.getMonth() + 1).padStart(2, '0')
      const day = String(now.getDate()).padStart(2, '0')
      return `${year}-${month}-${day}`
    },
    validate() {
      if (!this.form.buildingId) return '请选择建筑'
      if (!this.form.happenedAt) return '请选择发生时间'
      if (!this.form.title) return '请输入标题'
      if (!this.form.content) return '请输入内容'
      return ''
    },
    async submit() {
      this.errorMsg = ''
      this.successMsg = ''
      const error = this.validate()
      if (error) {
        this.errorMsg = error
        return
      }

      this.submitting = true
      try {
        const { data } = await createMemory({
          buildingId: Number(this.form.buildingId),
          happenedAt: this.form.happenedAt,
          title: this.form.title,
          mediaType: this.form.mediaType,
          content: this.form.content
        })
        this.successMsg = '这条回忆已经放进小岛。'
        if (data && data.id) {
          this.$router.push(`/post/${data.id}`)
          return
        }
        this.$router.push('/memories')
      } catch (error) {
        this.errorMsg = '保存失败，请稍后重试'
      } finally {
        this.submitting = false
      }
    }
  }
}
</script>

<style scoped>
.write-page {
  min-height: 100vh;
  padding: 8px 14px 120px;
}

.write-shell {
  margin-top: 14px;
  display: grid;
  gap: 12px;
}

.intro-card,
.topic-card,
.sheet-card,
.building-chip {
  border: 1px solid rgba(145, 214, 255, 0.1);
  border-radius: 26px;
  background: rgba(9, 24, 39, 0.72);
  box-shadow: 0 24px 70px rgba(0, 0, 0, 0.24);
}

.intro-card,
.topic-card,
.sheet-card {
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

.intro-card p:last-child,
.topic-card p,
.building-chip p {
  margin-top: 10px;
  color: var(--muted);
  line-height: 1.7;
}

.topic-card small,
.strip-head span {
  color: rgba(194, 227, 255, 0.72);
  font-size: 12px;
}

.topic-card h2 {
  margin-top: 6px;
  font-size: 22px;
  line-height: 1.2;
  letter-spacing: -0.04em;
}

.field-stack + .field-stack,
.field-row,
.submit-row {
  margin-top: 12px;
}

.field-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
}

.field-stack label {
  display: block;
  margin-bottom: 8px;
  color: rgba(194, 227, 255, 0.72);
  font-size: 12px;
}

.field-stack input,
.field-stack select,
.field-stack textarea {
  width: 100%;
  box-sizing: border-box;
  border: 1px solid rgba(145, 214, 255, 0.12);
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.04);
  color: #f3f9ff;
  padding: 12px 14px;
  outline: none;
}

.field-stack textarea::placeholder,
.field-stack input::placeholder {
  color: rgba(190, 214, 236, 0.42);
}

.message {
  margin-top: 12px;
  font-size: 13px;
}

.message.error {
  color: #ff9f9f;
}

.message.success {
  color: #9bf3c8;
}

.submit-row {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.primary-btn,
.ghost-btn {
  border: none;
  border-radius: 999px;
  padding: 12px 16px;
}

.primary-btn {
  background: linear-gradient(135deg, #7be7ff, #489eff);
  color: #05111c;
  font-weight: 700;
}

.ghost-btn {
  background: rgba(255, 255, 255, 0.06);
  color: #eff8ff;
}

.primary-btn:disabled {
  opacity: 0.5;
}

.strip-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 10px;
}

.strip-head h3 {
  font-size: 28px;
  letter-spacing: -0.05em;
}

.strip-scroll {
  display: grid;
  grid-auto-flow: column;
  grid-auto-columns: 74%;
  gap: 10px;
  overflow-x: auto;
  padding-bottom: 2px;
  scrollbar-width: none;
}

.strip-scroll::-webkit-scrollbar {
  display: none;
}

.building-chip {
  padding: 16px;
}

.building-chip strong {
  display: block;
  font-size: 16px;
}

@media (max-width: 640px) {
  .field-row {
    grid-template-columns: 1fr;
  }
}

@media (min-width: 900px) {
  .write-page {
    max-width: 920px;
    margin: 0 auto;
    padding-left: 24px;
    padding-right: 24px;
  }

  .strip-scroll {
    grid-auto-columns: calc(33.333% - 8px);
  }
}
</style>
