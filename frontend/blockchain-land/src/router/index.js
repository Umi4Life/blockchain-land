import Vue from 'vue'
import VueRouter from 'vue-router'
import Login from '../views/Login.vue'
import Request from '../views/Request.vue'
import About from '../views/About.vue'
import Land from '../views/Land.vue'


Vue.use(VueRouter)

const routes = [
  {
    path: '*',
    redirect: '/login'
  },
  {
    path: '/',
    redirect: '/about'
  },
  {
    path: '/login',
    name: 'login',
    component: Login
  },
  {
    path: '/request',
    name: 'request',
    component: Request
  },
  {
    path: '/about',
    name: 'about',
    // meta: {
    //   requiresAuth: true
    // },
    component: About
  },
  {
    path: '/land',
    name: 'Land department page',
    // meta: {
    //   requiresAuth: true
    // },
    component: Land
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
