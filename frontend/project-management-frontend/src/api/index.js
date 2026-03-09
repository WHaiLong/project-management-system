import axios from 'axios'
import router from '@/router'
import store from '@/store'

const service = axios.create({
  baseURL: process.env.NODE_ENV === 'development' ? '/api' : '/',
  timeout: 10000
})

// 请求拦截器
service.interceptors.request.use(
  config => {
    const token = store.state.token
    if (token) {
      config.headers['Authorization'] = 'Bearer ' + token
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 响应拦截器
service.interceptors.response.use(
  response => {
    const res = response.data
    if (res.code !== 200) {
      if (res.code === 401) {
        store.dispatch('logout')
        router.push('/login')
      }
      return Promise.reject(new Error(res.message || 'Error'))
    } else {
      return res
    }
  },
  error => {
    if (error.response && error.response.status === 401) {
      store.dispatch('logout')
      router.push('/login')
    }
    return Promise.reject(error)
  }
)

export default service
