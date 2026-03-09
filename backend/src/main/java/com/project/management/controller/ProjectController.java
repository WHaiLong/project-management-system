package com.project.management.controller;

import com.project.management.domain.entity.Project;
import com.project.management.service.ProjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

/**
 * 项目管理控制器
 */
@RestController
@RequestMapping("/api/projects")
public class ProjectController {
    
    @Autowired
    private ProjectService projectService;
    
    @GetMapping
    public List<Project> listProjects(Project query) {
        return projectService.listProjects(query);
    }
    
    @GetMapping("/{id}")
    public Project getProject(@PathVariable Long id) {
        return projectService.getProjectById(id);
    }
    
    @PostMapping
    public boolean createProject(@RequestBody Project project) {
        return projectService.createProject(project);
    }
    
    @PutMapping("/{id}")
    public boolean updateProject(@PathVariable Long id, @RequestBody Project project) {
        project.setProjectId(id);
        return projectService.updateProject(project);
    }
    
    @DeleteMapping("/{id}")
    public boolean deleteProject(@PathVariable Long id) {
        return projectService.deleteProject(id);
    }
    
    @DeleteMapping("/batch")
    public boolean batchDeleteProjects(@RequestBody List<Long> ids) {
        return projectService.batchDeleteProjects(ids);
    }
}
