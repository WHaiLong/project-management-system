package com.project.management.service;

import com.project.management.domain.entity.Project;
import java.util.List;

/**
 * 项目管理服务接口
 */
public interface ProjectService {
    
    /**
     * 查询项目列表
     */
    List<Project> listProjects(Project query);
    
    /**
     * 根据ID查询项目
     */
    Project getProjectById(Long projectId);
    
    /**
     * 创建项目
     */
    boolean createProject(Project project);
    
    /**
     * 更新项目
     */
    boolean updateProject(Project project);
    
    /**
     * 删除项目
     */
    boolean deleteProject(Long projectId);
    
    /**
     * 批量删除项目
     */
    boolean batchDeleteProjects(List<Long> projectIds);
}
