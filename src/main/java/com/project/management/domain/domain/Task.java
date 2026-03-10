package com.ruoyi.task.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import java.util.Date;

/**
 * 任务管理对象 pm_task
 * 
 * @author ruoyi
 * @date 2026-03-09
 */
public class Task extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 任务ID */
    private Long taskId;

    /** 任务编号 */
    @Excel(name = "任务编号")
    private String taskCode;

    /** 任务标题 */
    @Excel(name = "任务标题")
    private String title;

    /** 任务描述 */
    @Excel(name = "任务描述")
    private String description;

    /** 项目ID */
    @Excel(name = "项目ID")
    private Long projectId;

    /** 负责人ID */
    @Excel(name = "负责人ID")
    private Long assigneeId;

    /** 优先级 */
    @Excel(name = "优先级")
    private String priority;

    /** 任务状态 */
    @Excel(name = "任务状态")
    private String status;

    /** 预估工时 */
    @Excel(name = "预估工时")
    private Double estimateHours;

    /** 实际工时 */
    @Excel(name = "实际工时")
    private Double actualHours;

    /** 截止日期 */
    @Excel(name = "截止日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date dueDate;

    /** 完成日期 */
    @Excel(name = "完成日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date completedDate;

    public void setTaskId(Long taskId) 
    {
        this.taskId = taskId;
    }

    public Long getTaskId() 
    {
        return taskId;
    }
    public void setTaskCode(String taskCode) 
    {
        this.taskCode = taskCode;
    }

    public String getTaskCode() 
    {
        return taskCode;
    }
    public void setTitle(String title) 
    {
        this.title = title;
    }

    public String getTitle() 
    {
        return title;
    }
    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
    }
    public void setProjectId(Long projectId) 
    {
        this.projectId = projectId;
    }

    public Long getProjectId() 
    {
        return projectId;
    }
    public void setAssigneeId(Long assigneeId) 
    {
        this.assigneeId = assigneeId;
    }

    public Long getAssigneeId() 
    {
        return assigneeId;
    }
    public void setPriority(String priority) 
    {
        this.priority = priority;
    }

    public String getPriority() 
    {
        return priority;
    }
    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }
    public void setEstimateHours(Double estimateHours) 
    {
        this.estimateHours = estimateHours;
    }

    public Double getEstimateHours() 
    {
        return estimateHours;
    }
    public void setActualHours(Double actualHours) 
    {
        this.actualHours = actualHours;
    }

    public Double getActualHours() 
    {
        return actualHours;
    }
    public void setDueDate(Date dueDate) 
    {
        this.dueDate = dueDate;
    }

    public Date getDueDate() 
    {
        return dueDate;
    }
    public void setCompletedDate(Date completedDate) 
    {
        this.completedDate = completedDate;
    }

    public Date getCompletedDate() 
    {
        return completedDate;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("taskId", getTaskId())
            .append("taskCode", getTaskCode())
            .append("title", getTitle())
            .append("description", getDescription())
            .append("projectId", getProjectId())
            .append("assigneeId", getAssigneeId())
            .append("priority", getPriority())
            .append("status", getStatus())
            .append("estimateHours", getEstimateHours())
            .append("actualHours", getActualHours())
            .append("dueDate", getDueDate())
            .append("completedDate", getCompletedDate())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
