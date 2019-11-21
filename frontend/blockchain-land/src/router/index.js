import Vue from 'vue'
import VueRouter from 'vue-router'
import firebase from 'firebase'

import Login from '../views/Login.vue'
import Request from '../views/Request.vue'
import Home from '../views/Home.vue'
Vue.use(VueRouter);

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
    component: Request,
    meta: {
        requiresAuth: true
    },
  },
  {
    path: '/home',
    name: 'home',
    meta: {
      requiresAuth: true
    },
    component: Home
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

router.beforeEach((to, from, next) => {
  const currentUser = firebase.auth().currentUser;
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth);
  if(requiresAuth && !currentUser) next('login');
  else if(!requiresAuth && currentUser) next('about');
  else next()

})

export default router
