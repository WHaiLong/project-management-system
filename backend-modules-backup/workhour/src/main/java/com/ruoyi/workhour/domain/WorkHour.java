package com.ruoyi.workhour.domain;

import lombok.Data;
import java.util.Date;

/**
 * 工时管理实体类
 */
@Data
public class WorkHour {
    private Long workHourId;
    private Long userId;
    private Long projectId;
    private Long taskId;
    private Date workDate;
    private Double hours;
    private String description;
    private String status;
    private Long approverId;
    private Date approvedTime;
    private String createBy;
    private Date createTime;
    private String updateBy;
    private Date updateTime;
    private String remark;
}
