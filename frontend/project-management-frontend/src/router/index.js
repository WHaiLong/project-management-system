import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue')
  },
  {
    path: '/',
    redirect: '/dashboard',
    component: () => import('@/views/layout/MainLayout.vue'),
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('@/views/Dashboard.vue')
      },
      {
        path: 'projects',
        name: 'Projects',
        component: () => import('@/views/project/ProjectList.vue')
      },
      {
        path: 'tasks',
        name: 'Tasks',
        component: () => import('@/views/task/TaskList.vue')
      },
      {
        path: 'workhours',
        name: 'WorkHours',
        component: () => import('@/views/workhour/WorkHourRecord.vue')
      }
    ]
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const isAuthenticated = localStorage.getItem('token')
  if (to.name !== 'Login' && !isAuthenticated) {
    next({ name: 'Login' })
  } else {
    next()
  }
})

export default router
