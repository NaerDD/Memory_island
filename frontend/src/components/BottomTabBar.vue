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
      <span v-if="isActive(item.route)" class="tabbar-wave"></span>
    </button>
  </nav>
</template>

<script>
export default {
  name: 'BottomTabBar',
  data() {
    return {
      items: [
        { key: 'home', label: '沙滩', icon: '🏖️', route: '/' },
        { key: 'island', label: '小岛', icon: '🪸', route: '/island' },
        { key: 'memories', label: '宝箱', icon: '🫧', route: '/memories' },
        { key: 'write', label: '投放', icon: '🌤️', route: '/write' }
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
  border-radius: 28px;
  background: rgba(255, 249, 236, 0.88);
  border: 1px solid rgba(216, 160, 72, 0.18);
  backdrop-filter: blur(18px);
  box-shadow: 0 20px 40px rgba(182, 126, 58, 0.2);
}

.tabbar-item {
  position: relative;
  border: none;
  border-radius: 20px;
  min-height: 56px;
  background: transparent;
  color: rgba(74, 110, 130, 0.74);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 4px;
  overflow: hidden;
  transition: transform 0.22s ease, background 0.22s ease;
}

.tabbar-item.active {
  background: linear-gradient(180deg, rgba(47, 200, 194, 0.18), rgba(255, 183, 79, 0.24));
  color: var(--text);
  transform: translateY(-2px);
}

.tabbar-icon {
  font-size: 18px;
  line-height: 1;
}

.tabbar-label {
  font-size: 11px;
  font-weight: 600;
}

.tabbar-wave {
  position: absolute;
  left: 18%;
  right: 18%;
  bottom: 6px;
  height: 4px;
  border-radius: 999px;
  background: linear-gradient(90deg, #2fc8c2, #3b8cff);
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
