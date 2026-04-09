<template>
  <header class="app-topbar">
    <div class="topbar-main">
      <button class="brand-lockup" @click="handleClick('topbar', '/')">
        <span class="brand-mark">☀️</span>
        <span class="brand-copy">
          <strong>{{ brand }}</strong>
          <small>Sunny Memory App</small>
        </span>
      </button>

      <div class="topbar-actions">
        <template v-if="isLoggedIn">
          <span class="user-pill">{{ userName || '岛民' }}</span>
          <button class="action-btn primary" @click="$emit('write')">去记录</button>
        </template>

        <template v-else>
          <button class="action-btn ghost" @click="$emit('go-auth', 'login')">登录</button>
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
      default: '回忆岛'
    },
    navItems: {
      type: Array,
      default: function () {
        return [
          { key: 'home', label: '首页', target: 'topbar', route: '/' },
          { key: 'island', label: '小岛', target: 'topbar', route: '/island' },
          { key: 'memories', label: '回忆', target: 'memories', route: '/memories' }
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
  background: linear-gradient(180deg, rgba(255, 244, 216, 0.94), rgba(255, 244, 216, 0.78));
  backdrop-filter: blur(18px);
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
  color: var(--text);
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 0;
}

.brand-mark {
  width: 38px;
  height: 38px;
  border-radius: 50%;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(180deg, #ffd86b, #ffae4c);
  box-shadow: 0 10px 24px rgba(255, 181, 79, 0.34);
  font-size: 18px;
}

.brand-copy {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.brand-copy strong {
  font-size: 15px;
  line-height: 1.1;
  font-weight: 700;
}

.brand-copy small {
  margin-top: 2px;
  color: var(--muted);
  font-size: 11px;
  letter-spacing: 0.08em;
}

.topbar-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}

.user-pill {
  max-width: 96px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  padding: 8px 10px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.55);
  color: var(--muted);
  font-size: 11px;
}

.action-btn {
  border: none;
  border-radius: 999px;
  padding: 10px 14px;
  font-size: 12px;
}

.action-btn.primary {
  background: linear-gradient(135deg, #2fc8c2, #3b8cff);
  color: #ffffff;
  font-weight: 700;
  box-shadow: 0 12px 24px rgba(59, 140, 255, 0.18);
}

.action-btn.ghost {
  background: rgba(255, 255, 255, 0.58);
  color: var(--text);
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
  border: none;
  border-radius: 999px;
  padding: 10px 14px;
  background: rgba(255, 255, 255, 0.56);
  color: var(--muted);
  font-size: 12px;
}

.tab-chip.active {
  background: linear-gradient(135deg, rgba(47, 200, 194, 0.18), rgba(255, 183, 79, 0.24));
  color: var(--text);
  box-shadow: inset 0 0 0 1px rgba(216, 160, 72, 0.18);
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
