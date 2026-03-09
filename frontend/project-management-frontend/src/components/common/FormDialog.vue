<template>
  <el-dialog
    :title="title"
    :visible.sync="dialogVisible"
    :width="width"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <el-form
      ref="formRef"
      :model="formData"
      :rules="rules"
      :label-width="labelWidth"
      :size="size"
    >
      <slot name="form-content" :form="formData">
        <el-row :gutter="20">
          <template v-for="field in fields">
            <el-col
              :key="field.prop"
              :span="field.span || 24"
              v-if="!field.hidden"
            >
              <el-form-item
                :label="field.label"
                :prop="field.prop"
                :required="field.required"
              >
                <template v-if="field.type === 'input'">
                  <el-input
                    v-model="formData[field.prop]"
                    :placeholder="field.placeholder"
                    :disabled="field.disabled"
                    :clearable="field.clearable"
                    :maxlength="field.maxlength"
                  ></el-input>
                </template>
                
                <template v-else-if="field.type === 'textarea'">
                  <el-input
                    v-model="formData[field.prop]"
                    type="textarea"
                    :rows="field.rows || 3"
                    :placeholder="field.placeholder"
                    :disabled="field.disabled"
                    :maxlength="field.maxlength"
                  ></el-input>
                </template>
                
                <template v-else-if="field.type === 'select'">
                  <el-select
                    v-model="formData[field.prop]"
                    :placeholder="field.placeholder"
                    :disabled="field.disabled"
                    :clearable="field.clearable"
                    style="width: 100%;"
                  >
                    <el-option
                      v-for="option in field.options"
                      :key="option.value"
                      :label="option.label"
                      :value="option.value"
                    ></el-option>
                  </el-select>
                </template>
                
                <template v-else-if="field.type === 'date'">
                  <el-date-picker
                    v-model="formData[field.prop]"
                    type="date"
                    :placeholder="field.placeholder"
                    :disabled="field.disabled"
                    :clearable="field.clearable"
                    value-format="yyyy-MM-dd"
                    style="width: 100%;"
                  ></el-date-picker>
                </template>
                
                <template v-else-if="field.type === 'datetime'">
                  <el-date-picker
                    v-model="formData[field.prop]"
                    type="datetime"
                    :placeholder="field.placeholder"
                    :disabled="field.disabled"
                    :clearable="field.clearable"
                    value-format="yyyy-MM-dd HH:mm:ss"
                    style="width: 100%;"
                  ></el-date-picker>
                </template>
                
                <template v-else-if="field.type === 'number'">
                  <el-input-number
                    v-model="formData[field.prop]"
                    :min="field.min"
                    :max="field.max"
                    :step="field.step"
                    :placeholder="field.placeholder"
                    :disabled="field.disabled"
                    style="width: 100%;"
                  ></el-input-number>
                </template>
                
                <template v-else-if="field.type === 'switch'">
                  <el-switch
                    v-model="formData[field.prop]"
                    :active-text="field.activeText"
                    :inactive-text="field.inactiveText"
                    :disabled="field.disabled"
                  ></el-switch>
                </template>
                
                <template v-else-if="field.type === 'radio'">
                  <el-radio-group v-model="formData[field.prop]" :disabled="field.disabled">
                    <el-radio
                      v-for="option in field.options"
                      :key="option.value"
                      :label="option.value"
                    >
                      {{ option.label }}
                    </el-radio>
                  </el-radio-group>
                </template>
                
                <template v-else-if="field.type === 'checkbox'">
                  <el-checkbox-group v-model="formData[field.prop]" :disabled="field.disabled">
                    <el-checkbox
                      v-for="option in field.options"
                      :key="option.value"
                      :label="option.value"
                    >
                      {{ option.label }}
                    </el-checkbox>
                  </el-checkbox-group>
                </template>
                
                <template v-else-if="field.type === 'custom'">
                  <slot :name="`field-${field.prop}`" :field="field" :form="formData"></slot>
                </template>
                
                <template v-else>
                  <el-input
                    v-model="formData[field.prop]"
                    :placeholder="field.placeholder"
                    :disabled="field.disabled"
                  ></el-input>
                </template>
                
                <template v-if="field.tip">
                  <div class="field-tip">{{ field.tip }}</div>
                </template>
              </el-form-item>
            </el-col>
          </template>
        </el-row>
      </slot>
    </el-form>
    
    <span slot="footer" class="dialog-footer">
      <el-button @click="handleClose">取消</el-button>
      <el-button type="primary" @click="handleSubmit" :loading="submitting">
        {{ submitText }}
      </el-button>
    </span>
  </el-dialog>
</template>

<script>
export default {
  name: 'FormDialog',
  props: {
    visible: {
      type: Boolean,
      default: false
    },
    title: {
      type: String,
      default: '表单'
    },
    formData: {
      type: Object,
      default: () => ({})
    },
    fields: {
      type: Array,
      default: () => []
    },
    rules: {
      type: Object,
      default: () => ({})
    },
    width: {
      type: String,
      default: '600px'
    },
    labelWidth: {
      type: String,
      default: '100px'
    },
    size: {
      type: String,
      default: 'medium'
    },
    submitText: {
      type: String,
      default: '确定'
    }
  },
  data() {
    return {
      dialogVisible: this.visible,
      submitting: false,
      localFormData: { ...this.formData }
    }
  },
  watch: {
    visible(newVal) {
      this.dialogVisible = newVal
      if (newVal) {
        this.localFormData = { ...this.formData }
      }
    },
    dialogVisible(newVal) {
      this.$emit('update:visible', newVal)
    },
    formData: {
      deep: true,
      handler(newVal) {
        this.localFormData = { ...newVal }
      }
    }
  },
  methods: {
    handleClose() {
      this.dialogVisible = false
      this.$refs.formRef && this.$refs.formRef.clearValidate()
      this.$emit('close')
    },
    
    handleSubmit() {
      this.$refs.formRef.validate(valid => {
        if (valid) {
          this.submitting = true
          this.$emit('submit', this.localFormData)
          
          // 提交完成后重置状态（由父组件控制）
          setTimeout(() => {
            this.submitting = false
          }, 1000)
        }
      })
    },
    
    // 外部调用的方法
    validate() {
      return new Promise((resolve, reject) => {
        this.$refs.formRef.validate(valid => {
          if (valid) {
            resolve(this.localFormData)
          } else {
            reject(new Error('表单验证失败'))
          }
        })
      })
    },
    
    resetFields() {
      this.$refs.formRef.resetFields()
    },
    
    clearValidate() {
      this.$refs.formRef.clearValidate()
    }
  }
}
</script>

<style scoped>
.field-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}
</style>
