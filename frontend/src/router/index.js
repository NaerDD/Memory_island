import Vue from 'vue'
import Router from 'vue-router'
import Home from '../views/Home.vue'
import Auth from '../views/Auth.vue'
import PostDetail from '../views/PostDetail.vue'
import MemoryList from '../views/MemoryList.vue'
import WriteMemory from '../views/WriteMemory.vue'
import Island from '../views/Island.vue'
import BuildingDetail from '../views/BuildingDetail.vue'

Vue.use(Router)

export default new Router({
  mode: 'hash',
  routes: [
    {
      path: '/',
      name: 'Home',
      component: Home
    },
    {
      path: '/auth',
      name: 'Auth',
      component: Auth
    },
    {
      path: '/island',
      name: 'Island',
      component: Island
    },
    {
      path: '/island/building/:id',
      name: 'BuildingDetail',
      component: BuildingDetail
    },
    {
      path: '/memories',
      name: 'MemoryList',
      component: MemoryList
    },
    {
      path: '/write',
      name: 'WriteMemory',
      component: WriteMemory
    },
    {
      path: '/post/:id',
      name: 'PostDetail',
      component: PostDetail
    }
  ]
})
