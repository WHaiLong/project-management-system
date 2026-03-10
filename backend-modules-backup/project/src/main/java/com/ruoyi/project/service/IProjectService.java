package com.ruoyi.project.service;

import com.ruoyi.project.domain.Project;
import java.util.List;

/**
 * 项目管理服务接口
 */
public interface IProjectService {
    
    /**
     * 查询项目列表
     */
    List<Project> selectProjectList(Project project);
    
    /**
     * 根据ID查询项目
     */
    Project selectProjectById(Long projectId);
    
    /**
     * 新增项目
     */
    int insertProject(Project project);
    
    /**
     * 修改项目
     */
    int updateProject(Project project);
    
    /**
     * 批量删除项目
     */
    int deleteProjectByIds(Long[] projectIds);
}
