import Vue from 'vue'
import VueRouter from 'vue-router'
import Login from '../views/Login.vue'
import Request from '../views/Request.vue'
import About from '../views/About.vue'


Vue.use(VueRouter)

const routes = [
  {
    path: '*',
    redirect: '/login'
  },
  {
    path: '/',
    redirect: '/login'
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
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
