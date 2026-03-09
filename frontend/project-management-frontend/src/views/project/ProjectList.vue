<template>
  <div class="project-list">
    <div class="header">
      <h2>项目管理</h2>
      <div class="header-actions">
        <el-button type="primary" icon="el-icon-plus" @click="handleCreate">
          新建项目
        </el-button>
        <el-button icon="el-icon-download">导出</el-button>
      </div>
    </div>

    <div class="filter-bar">
      <el-input
        v-model="searchQuery"
        placeholder="搜索项目名称或编码"
        prefix-icon="el-icon-search"
        style="width: 300px;"
        @keyup.enter.native="handleSearch"
      />
      <el-select v-model="filterStatus" placeholder="状态筛选" clearable>
        <el-option label="进行中" value="进行中"></el-option>
        <el-option label="规划中" value="规划中"></el-option>
        <el-option label="已暂停" value="已暂停"></el-option>
        <el-option label="已完成" value="已完成"></el-option>
      </el-select>
      <el-button type="primary" @click="handleSearch">搜索</el-button>
      <el-button @click="resetFilter">重置</el-button>
    </div>

    <el-table :data="projectList" style="width: 100%" v-loading="loading">
      <el-table-column prop="projectCode" label="项目编码" width="120"></el-table-column>
      <el-table-column prop="projectName" label="项目名称"></el-table-column>
      <el-table-column prop="managerName" label="项目经理" width="120"></el-table-column>
      <el-table-column prop="startDate" label="开始日期" width="120"></el-table-column>
      <el-table-column prop="endDate" label="结束日期" width="120"></el-table-column>
      <el-table-column prop="status" label="状态" width="100">
        <template slot-scope="scope">
          <el-tag :type="getStatusType(scope.row.status)">
            {{ scope.row.status }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="progress" label="进度" width="150">
        <template slot-scope="scope">
          <el-progress :percentage="scope.row.progress" :status="getProgressStatus(scope.row.progress)"></el-progress>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200" fixed="right">
        <template slot-scope="scope">
          <el-button type="text" @click="handleView(scope.row)">查看</el-button>
          <el-button type="text" @click="handleEdit(scope.row)">编辑</el-button>
          <el-button type="text" @click="handleDelete(scope.row)" style="color: #F56C6C;">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <div class="pagination">
      <el-pagination
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="currentPage"
        :page-sizes="[10, 20, 50, 100]"
        :page-size="pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="total"
      ></el-pagination>
    </div>

    <!-- 项目表单对话框 -->
    <el-dialog :title="formTitle" :visible.sync="dialogVisible" width="600px">
      <el-form ref="projectForm" :model="formData" :rules="formRules" label-width="100px">
        <el-form-item label="项目名称" prop="projectName">
          <el-input v-model="formData.projectName" placeholder="请输入项目名称"></el-input>
        </el-form-item>
        <el-form-item label="项目编码" prop="projectCode">
          <el-input v-model="formData.projectCode" placeholder="请输入项目编码"></el-input>
        </el-form-item>
        <el-form-item label="项目描述" prop="description">
          <el-input
            v-model="formData.description"
            type="textarea"
            :rows="3"
            placeholder="请输入项目描述"
          ></el-input>
        </el-form-item>
        <el-form-item label="项目经理" prop="managerId">
          <el-select v-model="formData.managerId" placeholder="请选择项目经理">
            <el-option
              v-for="user in userList"
              :key="user.userId"
              :label="user.realName"
              :value="user.userId"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-row>
          <el-col :span="12">
            <el-form-item label="开始日期" prop="startDate">
              <el-date-picker
                v-model="formData.startDate"
                type="date"
                placeholder="选择开始日期"
                value-format="yyyy-MM-dd"
              ></el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="结束日期" prop="endDate">
              <el-date-picker
                v-model="formData.endDate"
                type="date"
                placeholder="选择结束日期"
                value-format="yyyy-MM-dd"
              ></el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="项目预算" prop="budget">
          <el-input-number
            v-model="formData.budget"
            :min="0"
            :step="1000"
            placeholder="请输入项目预算"
          ></el-input-number>
        </el-form-item>
        <el-form-item label="项目状态" prop="status">
          <el-select v-model="formData.status" placeholder="请选择项目状态">
            <el-option label="规划中" value="规划中"></el-option>
            <el-option label="进行中" value="进行中"></el-option>
            <el-option label="已暂停" value="已暂停"></el-option>
            <el-option label="已完成" value="已完成"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="初始进度" prop="progress">
          <el-input-number
            v-model="formData.progress"
            :min="0"
            :max="100"
            :step="5"
            placeholder="请输入进度"
          ></el-input-number>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitting">确定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { get, post, put, del } from '@/utils/request'

export default {
  name: 'ProjectList',
  data() {
    return {
      searchQuery: '',
      filterStatus: '',
      loading: false,
      projectList: [],
      currentPage: 1,
      pageSize: 10,
      total: 0,
      
      dialogVisible: false,
      formTitle: '新建项目',
      submitting: false,
      formData: {
        projectId: null,
        projectName: '',
        projectCode: '',
        description: '',
        managerId: null,
        startDate: '',
        endDate: '',
        budget: 0,
        status: '进行中',
        progress: 0
      },
      formRules: {
        projectName: [
          { required: true, message: '请输入项目名称', trigger: 'blur' }
        ],
        projectCode: [
          { required: true, message: '请输入项目编码', trigger: 'blur' }
        ],
        managerId: [
          { required: true, message: '请选择项目经理', trigger: 'change' }
        ]
      },
      userList: [
        { userId: 1, realName: '张工' },
        { userId: 2, realName: '李工' },
        { userId: 3, realName: '王工' },
        { userId: 4, realName: '赵工' }
      ]
    }
  },
  created() {
    this.fetchProjects()
  },
  methods: {
    fetchProjects() {
      this.loading = true
      const params = {
        page: this.currentPage,
        size: this.pageSize,
        search: this.searchQuery,
        status: this.filterStatus
      }
      
      // 模拟API调用
      setTimeout(() => {
        this.projectList = [
          {
            projectId: 1,
            projectCode: 'PM001',
            projectName: '项目管理系统开发',
            managerName: '张工',
            startDate: '2026-03-01',
            endDate: '2026-04-10',
            status: '进行中',
            progress: 80,
            budget: 50000
          },
          {
            projectId: 2,
            projectCode: 'CP002',
            projectName: '客户门户网站',
            managerName: '李工',
            startDate: '2026-03-05',
            endDate: '2026-03-31',
            status: '进行中',
            progress: 60,
            budget: 30000
          },
          {
            projectId: 3,
            projectCode: 'MA003',
            projectName: '移动端App开发',
            managerName: '王工',
            startDate: '2026-03-10',
            endDate: '2026-04-30',
            status: '规划中',
            progress: 10,
            budget: 80000
          },
          {
            projectId: 4,
            projectCode: 'DM004',
            projectName: '数据中台建设',
            managerName: '赵工',
            startDate: '2026-02-15',
            endDate: '2026-05-15',
            status: '进行中',
            progress: 45,
            budget: 120000
          }
        ]
        this.total = 4
        this.loading = false
      }, 500)
    },
    
    handleSearch() {
      this.currentPage = 1
      this.fetchProjects()
    },
    
    resetFilter() {
      this.searchQuery = ''
      this.filterStatus = ''
      this.currentPage = 1
      this.fetchProjects()
    },
    
    handleSizeChange(size) {
      this.pageSize = size
      this.fetchProjects()
    },
    
    handleCurrentChange(page) {
      this.currentPage = page
      this.fetchProjects()
    },
    
    handleCreate() {
      this.formTitle = '新建项目'
      this.formData = {
        projectId: null,
        projectName: '',
        projectCode: '',
        description: '',
        managerId: null,
        startDate: '',
        endDate: '',
        budget: 0,
        status: '进行中',
        progress: 0
      }
      this.dialogVisible = true
    },
    
    handleEdit(row) {
      this.formTitle = '编辑项目'
      this.formData = { ...row }
      this.dialogVisible = true
    },
    
    handleView(row) {
      this.$router.push(`/projects/${row.projectId}`)
    },
    
    handleDelete(row) {
      this.$confirm(`确定删除项目"${row.projectName}"吗？`, '提示', {
        type: 'warning'
      }).then(() => {
        // 模拟删除
        this.$message.success('删除成功')
        this.fetchProjects()
      }).catch(() => {})
    },
    
    handleSubmit() {
      this.$refs.projectForm.validate(valid => {
        if (valid) {
          this.submitting = true
          
          // 模拟API调用
          setTimeout(() => {
            this.$message.success(this.formData.projectId ? '更新成功' : '创建成功')
            this.dialogVisible = false
            this.submitting = false
            this.fetchProjects()
          }, 500)
        }
      })
    },
    
    getStatusType(status) {
      const map = {
        '规划中': 'info',
        '进行中': 'primary',
        '已暂停': 'warning',
        '已完成': 'success'
      }
      return map[status] || 'info'
    },
    
    getProgressStatus(progress) {
      if (progress >= 100) return 'success'
      if (progress >= 80) return null
      if (progress >= 50) return null
      return 'exception'
    }
  }
}
</script>

<style scoped>
.project-list {
  padding: 20px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.header h2 {
  margin: 0;
}

.filter-bar {
  margin-bottom: 20px;
  display: flex;
  gap: 10px;
  align-items: center;
}

.pagination {
  margin-top: 20px;
  text-align: right;
}
</style>
