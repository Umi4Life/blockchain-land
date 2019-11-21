import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)
export default new Vuex.Store({
  state: {
      isLoading: false,
      uid: ""

  },
  mutations: {
      setLoading (state, payload) {
          state.isLoading = payload
      },
      setUid (state, payload) {
          state.uid = payload
      }
  },
  actions: {
  },
  modules: {
  },
  getters: {
      getLoading (state) {
          return state.isLoading
      },
      getUid (state) {
          return state.uid
      }
  }
})
