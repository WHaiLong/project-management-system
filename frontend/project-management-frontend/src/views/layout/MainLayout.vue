<template>
  <div class="main-layout">
    <el-container>
      <el-aside width="200px">
        <div class="logo">项目管理系统</div>
        <el-menu
          :default-active="activeMenu"
          router
          background-color="#304156"
          text-color="#bfcbd9"
          active-text-color="#409EFF"
        >
          <el-menu-item index="/dashboard">
            <i class="el-icon-s-home"></i>
            <span>仪表盘</span>
          </el-menu-item>
          <el-menu-item index="/projects">
            <i class="el-icon-s-management"></i>
            <span>项目管理</span>
          </el-menu-item>
          <el-menu-item index="/tasks">
            <i class="el-icon-s-order"></i>
            <span>任务管理</span>
          </el-menu-item>
          <el-menu-item index="/workhours">
            <i class="el-icon-time"></i>
            <span>工时填报</span>
          </el-menu-item>
        </el-menu>
      </el-aside>
      <el-container>
        <el-header>
          <div class="header-right">
            <el-dropdown @command="handleCommand">
              <span class="user-info">
                {{ userInfo.realName || userInfo.username }}
                <i class="el-icon-arrow-down"></i>
              </span>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item command="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </div>
        </el-header>
        <el-main>
          <router-view />
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'MainLayout',
  computed: {
    ...mapGetters(['currentUser']),
    userInfo() {
      return this.currentUser
    },
    activeMenu() {
      return this.$route.path
    }
  },
  methods: {
    handleCommand(command) {
      if (command === 'logout') {
        this.$store.dispatch('logout')
        this.$router.push('/login')
      }
    }
  }
}
</script>

<style scoped>
.main-layout {
  height: 100vh;
}

.el-header {
  background: #fff;
  border-bottom: 1px solid #e6e6e6;
  display: flex;
  align-items: center;
  justify-content: flex-end;
}

.el-aside {
  background: #304156;
}

.logo {
  height: 60px;
  line-height: 60px;
  text-align: center;
  color: #fff;
  font-size: 18px;
  font-weight: bold;
  background: #2b2f3a;
}

.user-info {
  cursor: pointer;
  color: #409EFF;
}
</style>
