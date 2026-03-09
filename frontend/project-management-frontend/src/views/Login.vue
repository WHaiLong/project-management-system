<template>
  <div class="login-container">
    <el-card class="login-card">
      <h2 class="login-title">项目管理系统</h2>
      <el-form ref="loginForm" :model="loginForm" :rules="loginRules">
        <el-form-item prop="username">
          <el-input
            v-model="loginForm.username"
            placeholder="用户名"
            prefix-icon="el-icon-user"
          />
        </el-form-item>
        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            type="password"
            placeholder="密码"
            prefix-icon="el-icon-lock"
            @keyup.enter.native="handleLogin"
          />
        </el-form-item>
        <el-form-item>
          <el-button
            type="primary"
            :loading="loading"
            @click="handleLogin"
            style="width: 100%"
          >
            登录
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { post } from '@/utils/request'

export default {
  name: 'Login',
  data() {
    return {
      loginForm: {
        username: '',
        password: ''
      },
      loginRules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' }
        ]
      },
      loading: false
    }
  },
  methods: {
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true
          // 模拟登录
          setTimeout(() => {
            const mockUser = {
              userId: 1,
              username: this.loginForm.username,
              realName: '测试用户',
              roles: ['admin']
            }
            this.$store.dispatch('login', {
              token: 'mock-token-' + Date.now(),
              userInfo: mockUser
            })
            this.$router.push('/dashboard')
            this.loading = false
          }, 500)
        }
      })
    }
  }
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.login-card {
  width: 400px;
  padding: 40px;
}

.login-title {
  text-align: center;
  margin-bottom: 30px;
  color: #333;
}
</style>
