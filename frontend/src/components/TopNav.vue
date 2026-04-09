<template>
  <header class="app-topbar">
    <div class="topbar-main">
      <button class="brand-lockup" @click="handleClick('topbar', '/')">
        <span class="brand-mark">◌</span>
        <span class="brand-copy">
          <strong>{{ brand }}</strong>
          <small>Memory Island App</small>
        </span>
      </button>

      <div class="topbar-actions">
        <template v-if="isLoggedIn">
          <span class="user-pill">{{ userName || '已登录用户' }}</span>
          <button class="action-btn primary" @click="$emit('write')">写回忆</button>
          <button class="action-btn ghost" @click="$emit('logout')">退出</button>
        </template>

        <template v-else>
          <button class="action-btn ghost" @click="$emit('go-auth', 'login')">登录</button>
          <button class="action-btn primary" @click="$emit('go-auth', 'register')">注册</button>
        </template>
      </div>
    </div>

    <nav class="topbar-tabs">
      <button
        v-for="item in navItems"
        :key="item.key"
        class="tab-chip"
        :class="{ active: isRouteActive(item.route) }"
        @click="handleClick(item.target, item.route)"
      >
        {{ item.label }}
      </button>
    </nav>
  </header>
</template>

<script>
export default {
  name: 'TopNav',
  props: {
    brand: {
      type: String,
      default: '小岛记忆'
    },
    navItems: {
      type: Array,
      default: function () {
        return [
          { key: 'home', label: '首页', target: 'topbar', route: '/' },
          { key: 'island', label: '小岛', target: 'topbar', route: '/island' },
          { key: 'memories', label: '回忆', target: 'memories', route: '/memories' },
          { key: 'about', label: '关于', target: 'about', route: '/' }
        ]
      }
    },
    isLoggedIn: {
      type: Boolean,
      default: false
    },
    userName: {
      type: String,
      default: ''
    }
  },
  methods: {
    handleClick(targetId, route) {
      this.$emit('navigate', {
        targetId: targetId,
        route: route
      })
    },
    isRouteActive(route) {
      if (!this.$route) {
        return false
      }
      if (route === '/') {
        return this.$route.path === '/'
      }
      return this.$route.path.indexOf(route) === 0
    }
  }
}
</script>

<style scoped>
.app-topbar {
  position: sticky;
  top: 0;
  z-index: 60;
  padding: calc(12px + env(safe-area-inset-top, 0px)) 14px 10px;
  background:
    linear-gradient(180deg, rgba(6, 16, 29, 0.92), rgba(6, 16, 29, 0.78)),
    rgba(6, 16, 29, 0.72);
  backdrop-filter: blur(18px);
  border-bottom: 1px solid rgba(157, 209, 255, 0.08);
}

.topbar-main {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.brand-lockup {
  border: none;
  background: transparent;
  color: #f5fbff;
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 0;
}

.brand-mark {
  width: 34px;
  height: 34px;
  border-radius: 50%;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: radial-gradient(circle at 30% 30%, #b3f0ff, #3c98c8 68%, #0e3952);
  color: rgba(6, 16, 29, 0.92);
  font-size: 18px;
  box-shadow: 0 0 24px rgba(117, 228, 255, 0.28);
}

.brand-copy {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.brand-copy strong {
  font-size: 15px;
  line-height: 1.1;
  font-weight: 600;
}

.brand-copy small {
  margin-top: 2px;
  color: rgba(213, 233, 255, 0.64);
  font-size: 11px;
  letter-spacing: 0.08em;
}

.topbar-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}

.user-pill {
  max-width: 90px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  padding: 8px 10px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.08);
  color: #d6ebff;
  font-size: 11px;
}

.action-btn {
  border: none;
  border-radius: 999px;
  padding: 10px 12px;
  font-size: 12px;
  transition: transform 0.24s ease, opacity 0.24s ease, background 0.24s ease;
}

.action-btn.primary {
  background: linear-gradient(135deg, #7be7ff, #489eff);
  color: #05111c;
  font-weight: 600;
}

.action-btn.ghost {
  background: rgba(255, 255, 255, 0.07);
  color: #e9f6ff;
}

.topbar-tabs {
  display: flex;
  gap: 8px;
  overflow-x: auto;
  margin-top: 12px;
  padding-bottom: 2px;
  scrollbar-width: none;
}

.topbar-tabs::-webkit-scrollbar {
  display: none;
}

.tab-chip {
  flex: 0 0 auto;
  border: 1px solid rgba(157, 209, 255, 0.12);
  border-radius: 999px;
  padding: 10px 14px;
  background: rgba(255, 255, 255, 0.03);
  color: rgba(226, 241, 255, 0.7);
  font-size: 12px;
}

.tab-chip.active {
  border-color: rgba(133, 230, 255, 0.35);
  background: linear-gradient(135deg, rgba(123, 231, 255, 0.2), rgba(72, 158, 255, 0.16));
  color: #f8fcff;
  box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.04);
}

@media (min-width: 900px) {
  .app-topbar {
    padding-left: 24px;
    padding-right: 24px;
  }

  .topbar-main {
    max-width: 1280px;
    margin: 0 auto;
  }

  .topbar-tabs {
    max-width: 1280px;
    margin: 12px auto 0;
  }
}

@media (max-width: 720px) {
  .topbar-tabs {
    display: none;
  }

  .brand-copy small,
  .user-pill {
    display: none;
  }
}
</style>
