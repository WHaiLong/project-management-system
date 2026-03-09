import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    token: localStorage.getItem('token') || '',
    userInfo: JSON.parse(localStorage.getItem('userInfo') || '{}')
  },
  mutations: {
    setToken(state, token) {
      state.token = token
      localStorage.setItem('token', token)
    },
    setUserInfo(state, userInfo) {
      state.userInfo = userInfo
      localStorage.setItem('userInfo', JSON.stringify(userInfo))
    },
    clearAuth(state) {
      state.token = ''
      state.userInfo = {}
      localStorage.removeItem('token')
      localStorage.removeItem('userInfo')
    }
  },
  actions: {
    login({ commit }, { token, userInfo }) {
      commit('setToken', token)
      commit('setUserInfo', userInfo)
    },
    logout({ commit }) {
      commit('clearAuth')
    }
  },
  getters: {
    isAuthenticated: state => !!state.token,
    currentUser: state => state.userInfo
  }
})
