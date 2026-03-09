package com.project.management.service;

import com.project.management.domain.entity.Task;
import java.util.List;

/**
 * 任务管理服务接口
 */
public interface TaskService {
    
    /**
     * 查询任务列表
     */
    List<Task> listTasks(Task query);
    
    /**
     * 根据ID查询任务
     */
    Task getTaskById(Long taskId);
    
    /**
     * 创建任务
     */
    boolean createTask(Task task);
    
    /**
     * 更新任务
     */
    boolean updateTask(Task task);
    
    /**
     * 删除任务
     */
    boolean deleteTask(Long taskId);
    
    /**
     * 根据项目ID查询任务
     */
    List<Task> getTasksByProjectId(Long projectId);
}
