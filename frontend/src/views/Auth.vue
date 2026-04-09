<template>
  <div class="auth-page">
    <div class="auth-bg">
      <div class="auth-glow auth-glow-a"></div>
      <div class="auth-glow auth-glow-b"></div>
    </div>

    <div class="auth-shell">
      <div class="brand-card">
        <p class="eyebrow">MEMORY ISLAND</p>
        <h1>把入口也做成 app 的一部分</h1>
        <p>这里不强调账号系统本身，只负责把你平滑地带回那座岛。</p>
      </div>

      <div class="panel-card">
        <div class="mode-switch">
          <button class="mode-btn" :class="{ active: mode === 'login' }" @click="switchMode('login')">登录</button>
          <button class="mode-btn" :class="{ active: mode === 'register' }" @click="switchMode('register')">注册</button>
        </div>

        <div v-if="mode === 'login'" class="form-stack">
          <div class="field-stack">
            <label>邮箱</label>
            <input v-model.trim="loginForm.email" type="email" placeholder="请输入邮箱" />
          </div>

          <div class="field-stack">
            <label>密码</label>
            <input v-model.trim="loginForm.password" type="password" placeholder="请输入密码" />
          </div>

          <p v-if="errorMsg" class="error-text">{{ errorMsg }}</p>

          <button class="submit-btn" @click="handleLogin">进入小岛</button>
        </div>

        <div v-else class="form-stack">
          <div class="field-stack">
            <label>昵称</label>
            <input v-model.trim="registerForm.name" type="text" placeholder="请输入昵称" />
          </div>

          <div class="field-stack">
            <label>邮箱</label>
            <input v-model.trim="registerForm.email" type="email" placeholder="请输入邮箱" />
          </div>

          <div class="field-stack">
            <label>密码</label>
            <input v-model.trim="registerForm.password" type="password" placeholder="请输入密码" />
          </div>

          <p v-if="errorMsg" class="error-text">{{ errorMsg }}</p>

          <button class="submit-btn" @click="handleRegister">创建并进入</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Auth',
  data() {
    return {
      mode: this.$route.query.mode === 'register' ? 'register' : 'login',
      errorMsg: '',
      loginForm: {
        email: '',
        password: ''
      },
      registerForm: {
        name: '',
        email: '',
        password: ''
      }
    }
  },
  watch: {
    '$route.query.mode'(val) {
      this.mode = val === 'register' ? 'register' : 'login'
      this.errorMsg = ''
    }
  },
  methods: {
    switchMode(mode) {
      this.$router.replace({
        path: '/auth',
        query: { mode: mode }
      })
    },
    isValidEmail(email) {
      return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)
    },
    handleLogin() {
      this.errorMsg = ''

      if (!this.loginForm.email) {
        this.errorMsg = '请输入邮箱'
        return
      }
      if (!this.isValidEmail(this.loginForm.email)) {
        this.errorMsg = '请输入正确的邮箱格式'
        return
      }
      if (!this.loginForm.password) {
        this.errorMsg = '请输入密码'
        return
      }

      const userInfo = {
        name: '回忆探索者',
        email: this.loginForm.email,
        loggedIn: true
      }

      localStorage.setItem('memory-island-user', JSON.stringify(userInfo))
      this.$router.push('/')
    },
    handleRegister() {
      this.errorMsg = ''

      if (!this.registerForm.name) {
        this.errorMsg = '请输入昵称'
        return
      }
      if (!this.registerForm.email) {
        this.errorMsg = '请输入邮箱'
        return
      }
      if (!this.isValidEmail(this.registerForm.email)) {
        this.errorMsg = '请输入正确的邮箱格式'
        return
      }
      if (!this.registerForm.password) {
        this.errorMsg = '请输入密码'
        return
      }

      const userInfo = {
        name: this.registerForm.name,
        email: this.registerForm.email,
        loggedIn: true
      }

      localStorage.setItem('memory-island-user', JSON.stringify(userInfo))
      this.$router.push('/')
    }
  }
}
</script>

<style scoped>
.auth-page {
  min-height: 100vh;
  position: relative;
  padding: 22px 14px 40px;
  overflow: hidden;
}

.auth-bg {
  position: absolute;
  inset: 0;
  pointer-events: none;
}

.auth-glow {
  position: absolute;
  border-radius: 50%;
  filter: blur(12px);
}

.auth-glow-a {
  width: 260px;
  height: 260px;
  top: -60px;
  right: -40px;
  background: radial-gradient(circle, rgba(123, 231, 255, 0.24), transparent 70%);
}

.auth-glow-b {
  width: 220px;
  height: 220px;
  left: -50px;
  bottom: 10%;
  background: radial-gradient(circle, rgba(72, 158, 255, 0.16), transparent 72%);
}

.auth-shell {
  position: relative;
  z-index: 1;
  max-width: 520px;
  margin: 0 auto;
  display: grid;
  gap: 12px;
}

.brand-card,
.panel-card {
  border: 1px solid rgba(145, 214, 255, 0.1);
  border-radius: 28px;
  background: rgba(9, 24, 39, 0.78);
  box-shadow: 0 24px 70px rgba(0, 0, 0, 0.24);
  padding: 20px;
}

.eyebrow {
  margin: 0 0 8px;
  color: rgba(159, 212, 255, 0.7);
  font-size: 12px;
  letter-spacing: 0.14em;
}

h1,
p {
  margin: 0;
}

h1 {
  font-size: clamp(2rem, 8vw, 3.3rem);
  line-height: 0.98;
  letter-spacing: -0.06em;
}

.brand-card p:last-child {
  margin-top: 10px;
  color: var(--muted);
  line-height: 1.7;
}

.mode-switch {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 8px;
  margin-bottom: 12px;
}

.mode-btn,
.submit-btn {
  border: none;
  border-radius: 999px;
}

.mode-btn {
  min-height: 42px;
  background: rgba(255, 255, 255, 0.05);
  color: rgba(219, 236, 255, 0.74);
}

.mode-btn.active {
  background: linear-gradient(135deg, rgba(123, 231, 255, 0.2), rgba(72, 158, 255, 0.16));
  color: #f7fbff;
}

.form-stack {
  display: grid;
  gap: 12px;
}

.field-stack label {
  display: block;
  margin-bottom: 8px;
  color: rgba(194, 227, 255, 0.72);
  font-size: 12px;
}

.field-stack input {
  width: 100%;
  box-sizing: border-box;
  border: 1px solid rgba(145, 214, 255, 0.12);
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.04);
  color: #f3f9ff;
  padding: 12px 14px;
  outline: none;
}

.field-stack input::placeholder {
  color: rgba(190, 214, 236, 0.42);
}

.submit-btn {
  min-height: 48px;
  background: linear-gradient(135deg, #7be7ff, #489eff);
  color: #05111c;
  font-weight: 700;
}

.error-text {
  color: #ff9f9f;
  font-size: 13px;
  margin: 0;
}

@media (min-width: 900px) {
  .auth-page {
    padding-top: 48px;
  }
}
</style>
