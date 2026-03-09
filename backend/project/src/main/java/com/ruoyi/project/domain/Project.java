package com.ruoyi.project.domain;

import lombok.Data;
import java.util.Date;

/**
 * 项目管理实体类
 */
@Data
public class Project {
    private Long projectId;
    private String projectName;
    private String projectCode;
    private String description;
    private Long managerId;
    private Date startDate;
    private Date endDate;
    private Double budget;
    private String status;
    private Integer progress;
    private String createBy;
    private Date createTime;
    private String updateBy;
    private Date updateTime;
    private String remark;
}
