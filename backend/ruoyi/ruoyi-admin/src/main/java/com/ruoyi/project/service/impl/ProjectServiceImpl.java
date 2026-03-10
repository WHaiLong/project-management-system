package com.ruoyi.project.service.impl;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.project.domain.Project;
import com.ruoyi.project.mapper.ProjectMapper;
import com.ruoyi.project.service.IProjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 项目管理 服务层实现
 */
@Service
public class ProjectServiceImpl implements IProjectService {
    
    @Autowired
    private ProjectMapper projectMapper;
    
    /**
     * 查询项目列表
     */
    @Override
    public List<Project> selectProjectList(Project project) {
        return projectMapper.selectProjectList(project);
    }
    
    /**
     * 根据ID查询项目
     */
    @Override
    public Project selectProjectById(Long projectId) {
        return projectMapper.selectProjectById(projectId);
    }
    
    /**
     * 新增项目
     */
    @Override
    public int insertProject(Project project) {
        project.setCreateTime(DateUtils.getNowDate());
        return projectMapper.insertProject(project);
    }
    
    /**
     * 修改项目
     */
    @Override
    public int updateProject(Project project) {
        project.setUpdateTime(DateUtils.getNowDate());
        return projectMapper.updateProject(project);
    }
    
    /**
     * 批量删除项目
     */
    @Override
    public int deleteProjectByIds(Long[] projectIds) {
        return projectMapper.deleteProjectByIds(projectIds);
    }
}
