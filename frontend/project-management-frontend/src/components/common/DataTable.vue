<template>
  <div class="data-table">
    <!-- 搜索栏 -->
    <div v-if="showSearch" class="table-search">
      <el-input
        v-model="searchQuery"
        :placeholder="searchPlaceholder"
        prefix-icon="el-icon-search"
        style="width: 300px;"
        @keyup.enter.native="handleSearch"
      />
      <el-button type="primary" @click="handleSearch">搜索</el-button>
      <el-button @click="resetSearch">重置</el-button>
      <slot name="search-extra"></slot>
    </div>

    <!-- 操作栏 -->
    <div v-if="showToolbar" class="table-toolbar">
      <div class="toolbar-left">
        <slot name="toolbar-left"></slot>
      </div>
      <div class="toolbar-right">
        <slot name="toolbar-right">
          <el-button v-if="showCreate" type="primary" icon="el-icon-plus" @click="handleCreate">
            {{ createText }}
          </el-button>
          <el-button v-if="showExport" icon="el-icon-download" @click="handleExport">
            导出
          </el-button>
        </slot>
      </div>
    </div>

    <!-- 数据表格 -->
    <el-table
      :data="tableData"
      :loading="loading"
      :border="border"
      :stripe="stripe"
      :size="size"
      :height="height"
      :max-height="maxHeight"
      @selection-change="handleSelectionChange"
      @sort-change="handleSortChange"
    >
      <!-- 选择列 -->
      <el-table-column
        v-if="showSelection"
        type="selection"
        width="55"
        align="center"
      ></el-table-column>

      <!-- 序号列 -->
      <el-table-column
        v-if="showIndex"
        type="index"
        label="序号"
        width="80"
        align="center"
      ></el-table-column>

      <!-- 数据列 -->
      <template v-for="column in columns">
        <el-table-column
          :key="column.prop"
          :prop="column.prop"
          :label="column.label"
          :width="column.width"
          :min-width="column.minWidth"
          :align="column.align || 'center'"
          :sortable="column.sortable"
          :formatter="column.formatter"
        >
          <template slot-scope="scope">
            <template v-if="column.type === 'status'">
              <el-tag :type="getStatusType(scope.row[column.prop])" size="small">
                {{ getStatusText(scope.row[column.prop]) }}
              </el-tag>
            </template>
            <template v-else-if="column.type === 'progress'">
              <el-progress
                :percentage="scope.row[column.prop]"
                :status="getProgressStatus(scope.row[column.prop])"
                :show-text="false"
              ></el-progress>
              <span style="margin-left: 10px;">{{ scope.row[column.prop] }}%</span>
            </template>
            <template v-else-if="column.type === 'date'">
              {{ formatDate(scope.row[column.prop]) }}
            </template>
            <template v-else-if="column.type === 'money'">
              ¥{{ formatMoney(scope.row[column.prop]) }}
            </template>
            <template v-else-if="column.type === 'custom'">
              <slot :name="`column-${column.prop}`" :row="scope.row"></slot>
            </template>
            <template v-else>
              {{ scope.row[column.prop] }}
            </template>
          </template>
        </el-table-column>
      </template>

      <!-- 操作列 -->
      <el-table-column
        v-if="showActions"
        label="操作"
        :width="actionsWidth"
        fixed="right"
        align="center"
      >
        <template slot-scope="scope">
          <slot name="actions" :row="scope.row">
            <el-button type="text" @click="handleView(scope.row)">查看</el-button>
            <el-button type="text" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button type="text" style="color: #F56C6C;" @click="handleDelete(scope.row)">删除</el-button>
          </slot>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <div v-if="showPagination" class="table-pagination">
      <el-pagination
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="currentPage"
        :page-sizes="pageSizes"
        :page-size="pageSize"
        :layout="paginationLayout"
        :total="total"
      ></el-pagination>
    </div>
  </div>
</template>

<script>
export default {
  name: 'DataTable',
  props: {
    // 数据相关
    data: {
      type: Array,
      default: () => []
    },
    columns: {
      type: Array,
      required: true
    },
    loading: {
      type: Boolean,
      default: false
    },
    
    // 功能开关
    showSearch: {
      type: Boolean,
      default: true
    },
    showToolbar: {
      type: Boolean,
      default: true
    },
    showCreate: {
      type: Boolean,
      default: true
    },
    showExport: {
      type: Boolean,
      default: false
    },
    showSelection: {
      type: Boolean,
      default: false
    },
    showIndex: {
      type: Boolean,
      default: true
    },
    showActions: {
      type: Boolean,
      default: true
    },
    showPagination: {
      type: Boolean,
      default: true
    },
    
    // 文本配置
    searchPlaceholder: {
      type: String,
      default: '请输入搜索内容'
    },
    createText: {
      type: String,
      default: '新建'
    },
    
    // 表格样式
    border: {
      type: Boolean,
      default: true
    },
    stripe: {
      type: Boolean,
      default: true
    },
    size: {
      type: String,
      default: 'medium'
    },
    height: {
      type: [String, Number],
      default: null
    },
    maxHeight: {
      type: [String, Number],
      default: null
    },
    
    // 分页配置
    pageSizes: {
      type: Array,
      default: () => [10, 20, 50, 100]
    },
    paginationLayout: {
      type: String,
      default: 'total, sizes, prev, pager, next, jumper'
    },
    
    // 操作列宽度
    actionsWidth: {
      type: [String, Number],
      default: '200'
    }
  },
  data() {
    return {
      searchQuery: '',
      currentPage: 1,
      pageSize: 10,
      total: 0,
      selectedRows: [],
      tableData: []
    }
  },
  watch: {
    data: {
      immediate: true,
      handler(newVal) {
        this.tableData = newVal
        this.total = newVal.length
      }
    }
  },
  methods: {
    // 搜索相关
    handleSearch() {
      this.$emit('search', this.searchQuery)
    },
    
    resetSearch() {
      this.searchQuery = ''
      this.$emit('search', '')
    },
    
    // 分页相关
    handleSizeChange(size) {
      this.pageSize = size
      this.$emit('size-change', size)
    },
    
    handleCurrentChange(page) {
      this.currentPage = page
      this.$emit('current-change', page)
    },
    
    // 选择相关
    handleSelectionChange(selection) {
      this.selectedRows = selection
      this.$emit('selection-change', selection)
    },
    
    // 排序相关
    handleSortChange(sort) {
      this.$emit('sort-change', sort)
    },
    
    // 操作相关
    handleCreate() {
      this.$emit('create')
    },
    
    handleExport() {
      this.$emit('export')
    },
    
    handleView(row) {
      this.$emit('view', row)
    },
    
    handleEdit(row) {
      this.$emit('edit', row)
    },
    
    handleDelete(row) {
      this.$emit('delete', row)
    },
    
    // 格式化方法
    formatDate(date) {
      if (!date) return ''
      return new Date(date).toLocaleDateString('zh-CN')
    },
    
    formatMoney(amount) {
      if (!amount) return '0.00'
      return parseFloat(amount).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',')
    },
    
    getStatusType(status) {
      const statusMap = {
        'pending': 'info',
        'in_progress': 'primary',
        'completed': 'success',
        'overdue': 'danger',
        'approved': 'success',
        'rejected': 'danger'
      }
      return statusMap[status] || 'info'
    },
    
    getStatusText(status) {
      const textMap = {
        'pending': '待处理',
        'in_progress': '进行中',
        'completed': '已完成',
        'overdue': '已逾期',
        'approved': '已审核',
        'rejected': '已驳回'
      }
      return textMap[status] || status
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
.data-table {
  padding: 20px;
  background: white;
  border-radius: 8px;
}

.table-search {
  margin-bottom: 20px;
  display: flex;
  gap: 10px;
  align-items: center;
  flex-wrap: wrap;
}

.table-toolbar {
  margin-bottom: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.toolbar-left,
.toolbar-right {
  display: flex;
  gap: 10px;
  align-items: center;
}

.table-pagination {
  margin-top: 20px;
  text-align: right;
}
</style>
