package com.ruoyi.task.service;

import com.ruoyi.task.domain.Task;
import java.util.List;
import java.util.Map;

/**
 * 任务 服务层
 */
public interface ITaskService {
    /**
     * 查询任务
     */
    Task selectTaskByTaskId(Long taskId);

    /**
     * 查询任务列表
     */
    List<Task> selectTaskList(Task task);

    /**
     * 查询我的任务列表
     */
    List<Task> selectMyTaskList();
    
    /**
     * 查询项目下的任务
     */
    List<Task> selectTasksByProjectId(Long projectId);

    /**
     * 新增任务
     */
    int insertTask(Task task);

    /**
     * 修改任务
     */
    int updateTask(Task task);
    
    /**
     * 更新任务状态
     */
    int updateTaskStatus(Long taskId, String status);

    /**
     * 批量删除任务
     */
    int deleteTaskByTaskIds(Long[] taskIds);

    /**
     * 删除任务信息
     */
    int deleteTaskByTaskId(Long taskId);
    
    /**
     * 获取任务统计信息
     */
    Map<String, Object> getTaskStatistics();
    
    /**
     * 获取看板数据
     */
    Map<String, List<Task>> getKanbanData();
}
