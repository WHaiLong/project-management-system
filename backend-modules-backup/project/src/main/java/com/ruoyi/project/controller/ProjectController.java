package com.ruoyi.project.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.project.domain.Project;
import com.ruoyi.project.service.IProjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

/**
 * 项目管理控制器
 */
@RestController
@RequestMapping("/project")
public class ProjectController extends BaseController {
    
    @Autowired
    private IProjectService projectService;
    
    /**
     * 查询项目列表
     */
    @GetMapping("/list")
    public TableDataInfo list(Project project) {
        startPage();
        List<Project> list = projectService.selectProjectList(project);
        return getDataTable(list);
    }
    
    /**
     * 获取项目详细信息
     */
    @GetMapping(value = "/{projectId}")
    public AjaxResult getInfo(@PathVariable("projectId") Long projectId) {
        return success(projectService.selectProjectById(projectId));
    }
    
    /**
     * 新增项目
     */
    @PostMapping
    public AjaxResult add(@RequestBody Project project) {
        return toAjax(projectService.insertProject(project));
    }
    
    /**
     * 修改项目
     */
    @PutMapping
    public AjaxResult edit(@RequestBody Project project) {
        return toAjax(projectService.updateProject(project));
    }
    
    /**
     * 删除项目
     */
    @DeleteMapping("/{projectIds}")
    public AjaxResult remove(@PathVariable Long[] projectIds) {
        return toAjax(projectService.deleteProjectByIds(projectIds));
    }
}
