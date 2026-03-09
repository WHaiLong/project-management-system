package com.ruoyi.task.domain;

import lombok.Data;
import java.util.Date;

/**
 * 任务管理实体类
 */
@Data
public class Task {
    private Long taskId;
    private String taskCode;
    private String title;
    private String description;
    private Long projectId;
    private Long assigneeId;
    private String priority;
    private String status;
    private Double estimateHours;
    private Double actualHours;
    private Date dueDate;
    private Date completedDate;
    private String createBy;
    private Date createTime;
    private String updateBy;
    private Date updateTime;
    private String remark;
}
