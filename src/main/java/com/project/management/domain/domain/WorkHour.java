package com.ruoyi.workhour.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import java.util.Date;

/**
 * 工时管理对象 pm_work_hour
 * 
 * @author ruoyi
 * @date 2026-03-09
 */
public class WorkHour extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 工时ID */
    private Long workHourId;

    /** 用户ID */
    @Excel(name = "用户ID")
    private Long userId;

    /** 项目ID */
    @Excel(name = "项目ID")
    private Long projectId;

    /** 任务ID */
    @Excel(name = "任务ID")
    private Long taskId;

    /** 工作日期 */
    @Excel(name = "工作日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date workDate;

    /** 工时数 */
    @Excel(name = "工时数")
    private Double hours;

    /** 工作描述 */
    @Excel(name = "工作描述")
    private String description;

    /** 状态 */
    @Excel(name = "状态")
    private String status;

    /** 审批人ID */
    @Excel(name = "审批人ID")
    private Long approverId;

    /** 审批时间 */
    @Excel(name = "审批时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date approvedTime;

    public void setWorkHourId(Long workHourId) 
    {
        this.workHourId = workHourId;
    }

    public Long getWorkHourId() 
    {
        return workHourId;
    }
    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }
    public void setProjectId(Long projectId) 
    {
        this.projectId = projectId;
    }

    public Long getProjectId() 
    {
        return projectId;
    }
    public void setTaskId(Long taskId) 
    {
        this.taskId = taskId;
    }

    public Long getTaskId() 
    {
        return taskId;
    }
    public void setWorkDate(Date workDate) 
    {
        this.workDate = workDate;
    }

    public Date getWorkDate() 
    {
        return workDate;
    }
    public void setHours(Double hours) 
    {
        this.hours = hours;
    }

    public Double getHours() 
    {
        return hours;
    }
    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
    }
    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }
    public void setApproverId(Long approverId) 
    {
        this.approverId = approverId;
    }

    public Long getApproverId() 
    {
        return approverId;
    }
    public void setApprovedTime(Date approvedTime) 
    {
        this.approvedTime = approvedTime;
    }

    public Date getApprovedTime() 
    {
        return approvedTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("workHourId", getWorkHourId())
            .append("userId", getUserId())
            .append("projectId", getProjectId())
            .append("taskId", getTaskId())
            .append("workDate", getWorkDate())
            .append("hours", getHours())
            .append("description", getDescription())
            .append("status", getStatus())
            .append("approverId", getApproverId())
            .append("approvedTime", getApprovedTime())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
