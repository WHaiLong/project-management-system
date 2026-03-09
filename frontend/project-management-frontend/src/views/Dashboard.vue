<template>
  <div class="dashboard">
    <el-row :gutter="20">
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon" style="background: #409EFF;">
              <i class="el-icon-s-management"></i>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ projectCount }}</div>
              <div class="stat-label">进行中项目</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon" style="background: #67C23A;">
              <i class="el-icon-s-order"></i>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ taskCount }}</div>
              <div class="stat-label">待处理任务</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon" style="background: #E6A23C;">
              <i class="el-icon-time"></i>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ workHourCount }}</div>
              <div class="stat-label">今日工时</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon" style="background: #F56C6C;">
              <i class="el-icon-s-flag"></i>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ overdueCount }}</div>
              <div class="stat-label">逾期任务</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="12">
        <el-card header="最近项目">
          <el-table :data="recentProjects" style="width: 100%">
            <el-table-column prop="name" label="项目名称"></el-table-column>
            <el-table-column prop="manager" label="项目经理"></el-table-column>
            <el-table-column prop="progress" label="进度">
              <template slot-scope="scope">
                <el-progress :percentage="scope.row.progress"></el-progress>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="80">
              <template slot-scope="scope">
                <el-button type="text" @click="viewProject(scope.row)">查看</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card header="我的任务">
          <el-table :data="myTasks" style="width: 100%">
            <el-table-column prop="title" label="任务标题"></el-table-column>
            <el-table-column prop="project" label="所属项目"></el-table-column>
            <el-table-column prop="dueDate" label="截止日期"></el-table-column>
            <el-table-column prop="status" label="状态">
              <template slot-scope="scope">
                <el-tag :type="getStatusType(scope.row.status)">
                  {{ scope.row.status }}
                </el-tag>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>

    <el-row style="margin-top: 20px;">
      <el-col :span="24">
        <el-card header="近期活动">
          <el-timeline>
            <el-timeline-item
              v-for="(activity, index) in activities"
              :key="index"
              :timestamp="activity.time"
              placement="top"
            >
              <el-card>
                <p>{{ activity.content }}</p>
              </el-card>
            </el-timeline-item>
          </el-timeline>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'Dashboard',
  data() {
    return {
      projectCount: 5,
      taskCount: 12,
      workHourCount: '8.5h',
      overdueCount: 3,
      recentProjects: [
        { id: 1, name: '项目管理系统开发', manager: '张工', progress: 80 },
        { id: 2, name: '客户门户网站', manager: '李工', progress: 60 },
        { id: 3, name: '移动端App开发', manager: '王工', progress: 30 },
        { id: 4, name: '数据中台建设', manager: '赵工', progress: 45 }
      ],
      myTasks: [
        { id: 1, title: '登录页面开发', project: '项目管理系统', dueDate: '2026-03-10', status: '进行中' },
        { id: 2, title: 'API接口设计', project: '客户门户', dueDate: '2026-03-09', status: '待处理' },
        { id: 3, title: '数据库优化', project: '数据中台', dueDate: '2026-03-11', status: '进行中' },
        { id: 4, title: '测试用例编写', project: '移动端App', dueDate: '2026-03-08', status: '逾期' }
      ],
      activities: [
        { time: '2026-03-09 11:30', content: '张工完成了"用户管理模块"开发' },
        { time: '2026-03-09 10:45', content: '李工创建了新项目"客户门户网站"' },
        { time: '2026-03-09 09:20', content: '王工提交了任务"API接口设计"' },
        { time: '2026-03-08 16:30', content: '赵工记录了8小时工时' }
      ]
    }
  },
  methods: {
    viewProject(project) {
      this.$router.push(`/projects/${project.id}`)
    },
    getStatusType(status) {
      const map = {
        '待处理': 'info',
        '进行中': 'primary',
        '已完成': 'success',
        '逾期': 'danger'
      }
      return map[status] || 'info'
    }
  }
}
</script>

<style scoped>
.dashboard {
  padding: 20px;
}

.stat-card {
  margin-bottom: 0;
}

.stat-content {
  display: flex;
  align-items: center;
}

.stat-icon {
  width: 50px;
  height: 50px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 15px;
}

.stat-icon i {
  font-size: 24px;
  color: white;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 5px;
}

.stat-label {
  color: #909399;
  font-size: 14px;
}
</style>
