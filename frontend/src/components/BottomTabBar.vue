<template>
  <nav class="bottom-tabbar">
    <button
      v-for="item in items"
      :key="item.key"
      class="tabbar-item"
      :class="{ active: isActive(item.route) }"
      @click="go(item.route)"
    >
      <span class="tabbar-icon">{{ item.icon }}</span>
      <span class="tabbar-label">{{ item.label }}</span>
    </button>
  </nav>
</template>

<script>
export default {
  name: 'BottomTabBar',
  data() {
    return {
      items: [
        { key: 'home', label: '首页', icon: '◌', route: '/' },
        { key: 'island', label: '小岛', icon: '◎', route: '/island' },
        { key: 'memories', label: '回忆', icon: '▣', route: '/memories' },
        { key: 'write', label: '写回忆', icon: '＋', route: '/write' }
      ]
    }
  },
  methods: {
    isActive(route) {
      if (route === '/') {
        return this.$route.path === '/'
      }
      return this.$route.path.indexOf(route) === 0
    },
    go(route) {
      if (this.$route.path !== route) {
        this.$router.push(route)
      }
    }
  }
}
</script>

<style scoped>
.bottom-tabbar {
  position: fixed;
  left: 12px;
  right: 12px;
  bottom: calc(12px + env(safe-area-inset-bottom, 0px));
  z-index: 80;
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 8px;
  padding: 10px;
  border-radius: 26px;
  background: rgba(5, 16, 28, 0.92);
  border: 1px solid rgba(145, 214, 255, 0.12);
  backdrop-filter: blur(18px);
  box-shadow: 0 20px 48px rgba(0, 0, 0, 0.3);
}

.tabbar-item {
  border: none;
  border-radius: 18px;
  min-height: 54px;
  background: transparent;
  color: rgba(221, 238, 255, 0.62);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 4px;
}

.tabbar-item.active {
  background: linear-gradient(180deg, rgba(123, 231, 255, 0.18), rgba(72, 158, 255, 0.14));
  color: #f7fbff;
}

.tabbar-icon {
  font-size: 18px;
  line-height: 1;
}

.tabbar-label {
  font-size: 11px;
}

@media (min-width: 900px) {
  .bottom-tabbar {
    left: 50%;
    right: auto;
    width: 420px;
    transform: translateX(-50%);
  }
}
</style>
