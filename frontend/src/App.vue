<template>
  <div id="app" class="app-shell">
    <div class="app-noise"></div>
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
}

.app-noise {
  position: fixed;
  inset: 0;
  pointer-events: none;
  opacity: 0.18;
  background-image:
    radial-gradient(circle at 20% 20%, rgba(255, 255, 255, 0.18) 0, transparent 22%),
    radial-gradient(circle at 80% 10%, rgba(123, 231, 255, 0.12) 0, transparent 24%),
    radial-gradient(circle at 50% 90%, rgba(255, 173, 94, 0.08) 0, transparent 28%);
}
</style>
