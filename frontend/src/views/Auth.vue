<template>
    <div class="auth-page">
      <div class="bg-grid"></div>
  
      <div class="auth-card">
        <div class="auth-header">
          <h1>小岛记忆</h1>
          <div class="header-line"></div>
          <p>记录生活，珍藏回忆</p>
        </div>
  
        <div v-if="mode === 'login'">
          <h2 class="auth-title">欢迎回来</h2>
  
          <div class="form-item">
            <label>邮箱</label>
            <input v-model.trim="loginForm.email" type="email" placeholder="请输入邮箱" />
          </div>
  
          <div class="form-item">
            <label>密码</label>
            <input v-model.trim="loginForm.password" type="password" placeholder="请输入密码" />
          </div>
  
          <p v-if="errorMsg" class="error-text">{{ errorMsg }}</p>
  
          <button class="submit-btn" @click="handleLogin">登录</button>
  
          <div class="switch-text">
            还没有账号？
            <button @click="switchMode('register')">立即注册</button>
          </div>
        </div>
  
        <div v-else>
          <h2 class="auth-title">创建新账号</h2>
  
          <div class="form-item">
            <label>昵称</label>
            <input v-model.trim="registerForm.name" type="text" placeholder="请输入昵称" />
          </div>
  
          <div class="form-item">
            <label>邮箱</label>
            <input v-model.trim="registerForm.email" type="email" placeholder="请输入邮箱" />
          </div>
  
          <div class="form-item">
            <label>密码</label>
            <input v-model.trim="registerForm.password" type="password" placeholder="请输入密码" />
          </div>
  
          <p v-if="errorMsg" class="error-text">{{ errorMsg }}</p>
  
          <button class="submit-btn" @click="handleRegister">注册</button>
  
          <div class="switch-text">
            已有账号？
            <button @click="switchMode('login')">立即登录</button>
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
    background: #fff;
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 24px;
    overflow: hidden;
  }
  
  .bg-grid {
    position: absolute;
    inset: 0;
    background-image:
      linear-gradient(rgba(0,0,0,0.04) 1px, transparent 1px),
      linear-gradient(90deg, rgba(0,0,0,0.04) 1px, transparent 1px);
    background-size: 80px 80px;
    pointer-events: none;
  }
  
  .auth-card {
    position: relative;
    z-index: 2;
    width: 100%;
    max-width: 460px;
    background: #fff;
    border: 1px solid #e5e7eb;
    padding: 48px 40px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.04);
  }
  
  .auth-header {
    text-align: center;
    margin-bottom: 38px;
  }
  
  .auth-header h1 {
    margin: 0 0 18px;
    font-size: 38px;
    font-weight: 300;
  }
  
  .header-line {
    width: 96px;
    height: 1px;
    background: #111;
    margin: 0 auto 18px;
  }
  
  .auth-header p {
    margin: 0;
    color: #777;
    font-size: 14px;
  }
  
  .auth-title {
    margin: 0 0 28px;
    text-align: center;
    font-size: 22px;
    font-weight: 300;
  }
  
  .form-item {
    margin-bottom: 22px;
  }
  
  .form-item label {
    display: block;
    margin-bottom: 10px;
    font-size: 14px;
    color: #555;
  }
  
  .form-item input {
    width: 100%;
    box-sizing: border-box;
    border: none;
    border-bottom: 1px solid #d1d5db;
    padding: 12px 6px;
    font-size: 14px;
    background: transparent;
    outline: none;
  }
  
  .form-item input:focus {
    border-bottom-color: #111;
  }
  
  .submit-btn {
    width: 100%;
    border: none;
    background: #111;
    color: #fff;
    padding: 12px 16px;
    font-size: 14px;
    cursor: pointer;
    margin-top: 8px;
  }
  
  .submit-btn:hover {
    background: #222;
  }
  
  .switch-text {
    margin-top: 18px;
    text-align: center;
    font-size: 14px;
    color: #777;
  }
  
  .switch-text button {
    border: none;
    background: transparent;
    color: #111;
    cursor: pointer;
    font-size: 14px;
  }
  
  .error-text {
    color: #d33;
    font-size: 14px;
    margin: 0 0 12px;
  }
  </style>