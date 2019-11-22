import Vue from 'vue'
import VueRouter from 'vue-router'
import firebase from 'firebase'

import Login from '../views/Login.vue'
import Request from '../views/Request.vue'
import Home from '../views/Home.vue'
import CheckRequest from '../views/CheckRequest.vue'
Vue.use(VueRouter);
import Land from '../views/Land.vue'


Vue.use(VueRouter)

const routes = [
  {
    path: '*',
    redirect: '/home',
  },
  {
    path: '/',
    redirect: '/home'
  },
  {
    path: '/login',
    name: 'login',
    component: Login,
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
        path: '/land',
        name: 'Land department page',
        // meta: {
        //   requiresAuth: true
        // },
        component: Land
    },
    {
    path: '/home',
    name: 'home',
    meta: {
      requiresAuth: true
    },
    component: Home,
  },
  {
      path: '/checkRequest',
      name: 'checkRequest',
      meta: {
          requiresAuth: true
      },
      component: CheckRequest,
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
