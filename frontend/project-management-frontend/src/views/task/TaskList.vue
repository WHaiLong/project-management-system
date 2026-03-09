<template>
  <div class="task-list">
    <div class="header">
      <h2>任务管理</h2>
      <div class="header-actions">
        <el-button type="primary" icon="el-icon-plus" @click="handleCreate">
          新建任务
        </el-button>
        <el-button-group>
          <el-button :type="viewMode === 'list' ? 'primary' : ''" @click="viewMode = 'list'">
            <i class="el-icon-s-order"></i> 列表
          </el-button>
          <el-button :type="viewMode === 'kanban' ? 'primary' : ''" @click="viewMode = 'kanban'">
            <i class="el-icon-s-grid"></i> 看板
          </el-button>
        </el-button-group>
      </div>
    </div>

    <!-- 筛选栏 -->
    <div class="filter-bar">
      <el-input
        v-model="searchQuery"
        placeholder="搜索任务标题"
        prefix-icon="el-icon-search"
        style="width: 250px;"
        @keyup.enter.native="handleSearch"
      />
      <el-select v-model="filterProject" placeholder="项目筛选" clearable>
        <el-option
          v-for="project in projectOptions"
          :key    },
    
    handleSizeChange(size) {
      this.pageSize = size
      this.fetchTasks()
    },
    
    handleCurrentChange(page) {
      this.currentPage = page
      this.fetchTasks()
    },
    
    handleCreate() {
      this.formTitle = '新建任务'
      this.formData = {
        id: null,
        taskCode: 'TASK-' + Date.now().toString().slice(-4),
        title: '',
        projectId: null,
        description: '',
        assigneeId: null,
        priority: 'P2',
        estimateHours: 8,
        dueDate: '',
        status: 'pending'
      }
      this.dialogVisible = true
    },
    
    handleEdit(row) {
      this.formTitle = '编辑任务'
      this.formData = { ...row }
      this.dialogVisible = true
    },
    
    handleView(row) {
      this.$router.push(`/tasks/${row.id}`)
    },
    
    handleDelete(row) {
      this.$confirm(`确定删除任务"${row.title}"吗？`, '提示', {
        type: 'warning'
      }).then(() => {
        // 模拟删除
        this.$message.success('删除成功')
        this.fetchTasks()
      }).catch(() => {})
    },
    
    handleSubmit() {
      this.$refs.taskForm.validate(valid => {
        if (valid) {
          this.submitting = true
          
          // 模拟API调用
          setTimeout(() => {
            this.$message.success(this.formData.id ? '更新成功' : '创建成功')
            this.dialogVisible = false
            this.submitting = false
            this.fetchTasks()
          }, 500)
        }
      })
    },
    
    onTaskMove() {
      // 任务在看板中移动
      this.$message.success('任务状态已更新')
    },
    
    getPriorityType(priority) {
      const map = {
        'P0': 'danger',
        'P1': 'warning',
        'P2': 'primary',
        'P3': 'info'
      }
      return map[priority] || 'info'
    },
    
    getStatusType(status) {
      const map = {
        'pending': 'info',
        'in_progress': 'primary',
        'completed': 'success',
        'overdue': 'danger'
      }
      return map[status] || 'info'
    }
  }
}
</script>

<style scoped>
.task-list {
  padding: 20px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.filter-bar {
  margin-bottom: 20px;
  display: flex;
  gap: 10px;
  align-items: center;
  flex-wrap: wrap;
}

.task-kanban {
  margin-top: 20px;
}

.kanban-column {
  background: #f5f7fa;
  border-radius: 8px;
  padding: 15px;
  min-height: 500px;
}

.column-header {
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 2px solid #e4e7ed;
}

.column-header h3 {
  margin: 0;
  font-size: 16px;
  color: #303133;
}

.task-list-draggable {
  min-height: 400px;
}

.task-card {
  background: white;
  border-radius: 6px;
  padding: 12px;
  margin-bottom: 10px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  cursor: pointer;
  transition: all 0.3s;
}

.task-card:hover {
  box-shadow: 0 4px 8px rgba(0,0,0,0.15);
  transform: translateY(-2px);
}

.task-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.task-code {
  font-size: 12px;
  color: #909399;
  font-weight: bold;
}

.task-title {
  font-size: 14px;
  color: #303133;
  margin-bottom: 8px;
  line-height: 1.4;
}

.task-info {
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  color: #909399;
}

.task-info i {
  margin-right: 4px;
}

.pagination {
  margin-top: 20px;
  text-align: right;
}
</style>
