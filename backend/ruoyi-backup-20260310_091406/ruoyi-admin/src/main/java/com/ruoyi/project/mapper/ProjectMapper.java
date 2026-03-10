package com.ruoyi.project.mapper;

import com.ruoyi.project.domain.Project;
import java.util.List;

/**
 * 项目管理 数据层
 */
public interface ProjectMapper {
    
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
     * 删除项目
     */
    int deleteProjectById(Long projectId);
    
    /**
     * 批量删除项目
     */
    int deleteProjectByIds(Long[] projectIds);
}
