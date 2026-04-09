<template>
  <div id="app" class="app-shell">
    <div class="app-sun"></div>
    <div class="app-wave app-wave-a"></div>
    <div class="app-wave app-wave-b"></div>
    <router-view />
    <BottomTabBar v-if="showBottomTabs" />
  </div>
</template>

<script>
import BottomTabBar from './components/BottomTabBar.vue'

export default {
  name: 'App',
  components: {
    BottomTabBar
  },
  computed: {
    showBottomTabs() {
      return ['Home', 'Island', 'MemoryList', 'WriteMemory'].includes(this.$route.name)
    }
  }
}
</script>

<style>
.app-shell {
  position: relative;
  min-height: 100vh;
  overflow-x: hidden;
}

.app-sun,
.app-wave {
  position: fixed;
  pointer-events: none;
}

.app-sun {
  top: -72px;
  right: -28px;
  width: 220px;
  height: 220px;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(255, 219, 101, 0.9) 0%, rgba(255, 219, 101, 0.3) 52%, transparent 72%);
  filter: blur(4px);
}

.app-wave {
  left: -12%;
  right: -12%;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.18);
}

.app-wave-a {
  bottom: 18%;
  height: 120px;
  animation: waveDrift 12s linear infinite;
}

.app-wave-b {
  bottom: 10%;
  height: 150px;
  background: rgba(255, 255, 255, 0.14);
  animation: waveDrift 18s linear infinite reverse;
}

@keyframes waveDrift {
  0% { transform: translateX(-3%) translateY(0); }
  50% { transform: translateX(3%) translateY(8px); }
  100% { transform: translateX(-3%) translateY(0); }
}
</style>
