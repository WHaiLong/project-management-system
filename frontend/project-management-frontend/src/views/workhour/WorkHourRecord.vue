<template>
  <div class="workhour-record">
    <div class="header">
      <h2>工时填报</h2>
      <div class="header-actions">
        <el-button type="primary" icon="el-icon-plus" @click="handleCreate">
          新建工时记录
        </el-button>
        <el-button icon="el-icon-download" @click="handleExport">
          导出工时
        </el-button>
      </div>
    </div>

    <!-- 日期筛选 -->
    <div class="date-filter">
      <el-date-picker
        v-model="selectedDate"
        type="week"
        format="yyyy 第 WW 周"
        value-format="yyyy-MM-dd"
        placeholder="选择周"
        @change="handleDateChange"
      ></el-date-picker>
      <el-button type="text" @click="setToday">今天</el-button>
      <el-button type="text" @click="setLastWeek">上周</el-button>
      <el-button type="text" @click="setNextWeek">下周</el-button>
    </div>

    <!-- 工时统计 -->
    <div class="workhour-stats">
      <el-row :gutter="20">
        <el-col :span="6">
          <el-card class="stat-card">
            <div class="stat-content">
              <div class="stat-icon" style="background: #409EFF;">
                <i class="el-icon-time"></i>
              </div>
              <div class="stat-info">
                <div class="stat-value">{{ totalHours }}h</div>
                <div class="stat-label">本周总工时</div>
              </div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stat-card">
            <div class="stat-content">
              <div class="stat-icon" style="background: #67C23A;">
                <i class="el-icon-check"></i>
              </div>
              <div class="stat-info">
                <div class="stat-value">{{ approvedHours }}h</div>
                <div class="stat-label">已审核工时</div>
              </div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stat-card">
            <div class="stat-content">
              <div class="stat-icon" style="background: #E6A23C;">
                <i class="el-icon-loading"></i>
              </div>
              <div class="stat-info">
                <div class="stat-value">{{ pendingHours }}h</div>
                <div class="stat-label">待审核工时</div>
              </div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stat-card">
            <div class="stat-content">
              <div class="stat-icon" style="background: #F56C6C;">
                <i class="el-icon-close"></i>
              </div>
              <div class="stat-info">
                <div class="stat-value">{{ rejectedHours }}h</div>
                <div class="stat-label">已驳回工时</div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 工时表格 -->
    <div class="workhour-table">
      <el-table :data="workhourList" style="width: 100%" v-loading="loading">
        <el-table-column prop="date" label="日期" width="120">
          <template slot-scope="scope">
            {{ scope.row.date }}<br>
            <span style="color: #909399; font-size: 12px;">{{ getWeekDay(scope.row.date) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="projectName" label="项目" width="150"></el-table-column>
        <el-table-column prop="taskTitle" label="任务"></el-table-column>
        <el-table-column prop="hours" label="工时" width="100">
          <template slot-scope="scope">
            <span style="font-weight: bold;">{{ scope.row.hours }}h</span>
          </template>
        </el-table-column>
        <el-table-column prop="description" label="工作内容"></el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="getStatusType(scope.row.status)" size="small">
              {{ scope.row.statusText }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" @click="handleEdit(scope.row)" v-if="scope.row.status === 'pending'">编辑</el-button>
            <el-button type="text" @click="handleDelete(scope.row)" style="color: #F56C6C;" v-if="scope.row.status === 'pending'">删除</el-button>
            <span v-else style="color: #909399;">已提交</span>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 工时表单对话框 -->
    <el-dialog :title="formTitle" :visible.sync="dialogVisible" width="600px">
      <el-form ref="workhourForm" :model="formData" :rules="formRules" label-width="100px">
        <el-form-item label="日期" prop="date">
          <el-date-picker
            v-model="formData.date"
            type="date"
            placeholder="选择日期"
            value-format="yyyy-MM-dd"
          ></el-date-picker>
        </el-form-item>
        
        <el-form-item label="项目" prop="projectId">
          <el-select v-model="formData.projectId" placeholder="请选择项目" @change="handleProjectChange">
            <el-option
              v-for="project in projectOptions"
              :key="project.id"
              :label="project.name"
              :value="project.id"
            ></el-option>
          </el-select>
        </el-form-item>
        
        <el-form-item label="任务" prop="taskId">
          <el-select v-model="formData.taskId" placeholder="请选择任务">
            <el-option
              v-for="task in taskOptions"
              :key="task.id"
              :label="task.title"
              :value="task.id"
            ></el-option>
          </el-select>
        </el-form-item>
        
        <el-form-item label="工时" prop="hours">
          <el-input-number
            v-model="formData.hours"
            :min="0.5"
            :max="24"
            :step="0.5"
            placeholder="请输入工时"
          ></el-input-number>
          <span style="margin-left: 10px; color: #909399;">小时</span>
        </el-form-item>
        
        <el-form-item label="工作内容" prop="description">
          <el-input
            v-model="formData.description"
            type="textarea"
            :rows="3"
            placeholder="请输入工作内容描述"
          ></el-input>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitting">提交</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'WorkHourRecord',
  data() {
    return {
      selectedDate: new Date().toISOString().split('T')[0],
      loading: false,
      workhourList: [],
      
      dialogVisible: false,
      formTitle: '新建工时记录',
      submitting: false,
      formData: {
        id: null,
        date: new Date().toISOString().split('T')[0],
        projectId: null,
        taskId: null,
        hours: 8,
        description: ''
      },
      formRules: {
        date: [
          { required: true, message: '请选择日期', trigger: 'change' }
        ],
        projectId: [
          { required: true, message: '请选择项目', trigger: 'change' }
        ],
        hours: [
          { required: true, message: '请输入工时', trigger: 'blur' }
        ],
        description: [
          { required: true, message: '请输入工作内容', trigger: 'blur' }
        ]
      },
      
      projectOptions: [
        { id: 1, name: '项目管理系统开发' },
        { id: 2, name: '客户门户网站' },
        { id: 3, name: '移动端App开发' },
        { id: 4, name: '数据中台建设' }
      ],
      taskOptions: []
    }
  },
  computed: {
    totalHours() {
      return this.workhourList.reduce((sum, item) => sum + item.hours, 0).toFixed(1)
    },
    approvedHours() {
      return this.workhourList
        .filter(item => item.status === 'approved')
        .reduce((sum, item) => sum + item.hours, 0)
        .toFixed(1)
    },
    pendingHours() {
      return this.workhourList
        .filter(item => item.status === 'pending')
        .reduce((sum, item) => sum + item.hours, 0)
        .toFixed(1)
    },
    rejectedHours() {
      return this.workhourList
        .filter(item => item.status === 'rejected')
        .reduce((sum, item) => sum + item.hours, 0)
        .toFixed(1)
    }
  },
  created() {
    this.fetchWorkhours()
  },
  methods: {
    fetchWorkhours() {
      this.loading = true
      // 模拟API调用
      setTimeout(() => {
        this.workhourList = [
          {
            id: 1,
            date: '2026-03-09',
            projectName: '项目管理系统开发',
            taskTitle: '登录页面开发',
            hours: 8,
            description: '完成登录页面UI设计和功能开发',
            status: 'approved',
            statusText: '已审核'
          },
          {
            id: 2,
            date: '2026-03-09',
            projectName: '项目管理系统开发',
            taskTitle: 'API接口设计',
            hours: 4,
            description: '设计用户管理API接口',
            status: 'pending',
            statusText: '待审核'
          },
          {
            id: 3,
            date: '2026-03-08',
            projectName: '客户门户网站',
            taskTitle: '首页设计',
            hours: 6,
            description: '完成首页UI设计',
            status: 'approved',
            statusText: '已审核'
          },
          {
            id: 4,
            date: '2026-03-08',
            projectName: '数据中台建设',
            taskTitle: '数据库优化',
            hours: 2,
            description: '优化查询性能',
            status: 'rejected',
            statusText: '已驳回'
          }
        ]
        this.loading = false
      }, 500)
    },
    
    handleDateChange() {
      this.fetchWorkhours()
    },
    
    setToday() {
      this.selectedDate = new Date().toISOString().split('T')[0]
      this.fetchWorkhours()
    },
    
    setLastWeek() {
      const date = new Date(this.selectedDate)
      date.setDate(date.getDate() - 7)
      this.selectedDate = date.toISOString().split('T')[0]
      this.fetchWorkhours()
    },
    
    setNextWeek() {
      const date = new Date(this.selectedDate)
      date.setDate(date.getDate() + 7)
      this.selectedDate = date.toISOString().split('T')[0]
      this.fetchWorkhours()
    },
    
    handleCreate() {
      this.formTitle = '新建工时记录'
      this.formData = {
        id: null,
        date: new Date().toISOString().split('T')[0],
        projectId: null,
        taskId: null,
        hours: 8,
        description: ''
      }
      this.taskOptions = []
      this.dialogVisible = true
    },
    
    handleEdit(row) {
      this.formTitle = '编辑工时记录'
      this.formData = { ...row }
      this.handleProjectChange(row.projectId)
      this.dialogVisible = true
    },
    
    handleDelete(row) {
      this.$confirm(`确定删除这条工时记录吗？`, '提示', {
        type: 'warning'
      }).then(() => {
        this.$message.success('删除成功')
        this.fetchWorkhours()
      }).catch(() => {})
    },
    
    handleExport() {
      this.$message.success('工时数据导出中...')
    },
    
    handleProjectChange(projectId) {
      // 模拟根据项目获取任务
      this.taskOptions = [
        { id        1, title: '登录页面开发' },
        { id: 2, title: 'API接口设计' },
        { id: 3, title: '数据库设计' },
        { id: 4, title: '测试用例编写' }
      ]
    },
    
    handleSubmit() {
      this.$refs.workhourForm.validate(valid => {
        if (valid) {
          this.submitting = true
          
          // 模拟API调用
          setTimeout(() => {
            this.$message.success(this.formData.id ? '更新成功' : '提交成功')
            this.dialogVisible = false
            this.submitting = false
            this.fetchWorkhours()
          }, 500)
        }
      })
    },
    
    getWeekDay(dateStr) {
      const days = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']
      const date = new Date(dateStr)
      return days[date.getDay()]
    },
    
    getStatusType(status) {
      const map = {
        'pending': 'warning',
        'approved': 'success',
        'rejected': 'danger'
      }
      return map[status] || 'info'
    }
  }
}
</script>

<style scoped>
.workhour-record {
  padding: 20px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.date-filter {
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.workhour-stats {
  margin-bottom: 20px;
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

.workhour-table {
  margin-top: 20px;
}
</style>
