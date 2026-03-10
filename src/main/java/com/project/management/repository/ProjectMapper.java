package com.ruoyi.project.mapper;

import java.util.List;
import com.ruoyi.project.domain.Project;

/**
 * 项目管理Mapper接口
 * 
 * @author ruoyi
 * @date 2026-03-09
 */
public interface ProjectMapper 
{
    /**
     * 查询项目管理
     * 
     * @param projectId 项目管理ID
     * @return 项目管理
     */
    public Project selectProjectById(Long projectId);

    /**
     * 查询项目管理列表
     * 
     * @param project 项目管理
     * @return 项目管理集合
     */
    public List<Project> selectProjectList(Project project);

    /**
     * 新增项目管理
     * 
     * @param project 项目管理
     * @return 结果
     */
    public int insertProject(Project project);

    /**
     * 修改项目管理
     * 
     * @param project 项目管理
     * @return 结果
     */
    public int updateProject(Project project);

    /**
     * 删除项目管理
     * 
     * @param projectId 项目管理ID
     * @return 结果
     */
    public int deleteProjectById(Long projectId);

    /**
     * 批量删除项目管理
     * 
     * @param projectIds 需要删除的数据ID
     * @return 结果
     */
    public int deleteProjectByIds(Long[] projectIds);
}
