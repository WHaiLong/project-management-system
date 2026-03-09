package com.project.management.repository;

import com.project.management.domain.entity.Project;
import org.apache.ibatis.annotations.*;
import java.util.List;

/**
 * 项目管理数据访问接口
 */
@Mapper
public interface ProjectRepository {
    
    @Select("SELECT * FROM pm_project WHERE project_id = #{projectId}")
    Project selectById(Long projectId);
    
    @Select("<script>" +
            "SELECT * FROM pm_project " +
            "<where>" +
            "  <if test='projectName != null and projectName != \"\"'>" +
            "    AND project_name LIKE CONCAT('%', #{projectName}, '%')" +
            "  </if>" +
            "  <if test='projectCode != null and projectCode != \"\"'>" +
            "    AND project_code = #{projectCode}" +
            "  </if>" +
            "  <if test='status != null and status != \"\"'>" +
            "    AND status = #{status}" +
            "  </if>" +
            "</where>" +
            "ORDER BY create_time DESC" +
            "</script>")
    List<Project> selectList(Project query);
    
    @Insert("INSERT INTO pm_project (project_name, project_code, description, manager_id, " +
            "start_date, end_date, budget, status, progress, create_by, create_time) " +
            "VALUES (#{projectName}, #{projectCode}, #{description}, #{managerId}, " +
            "#{startDate}, #{endDate}, #{budget}, #{status}, #{progress}, #{createBy}, NOW())")
    @Options(useGeneratedKeys = true, keyProperty = "projectId")
    int insert(Project project);
    
    @Update("UPDATE pm_project SET " +
            "project_name = #{projectName}, project_code = #{projectCode}, " +
            "description = #{description}, manager_id = #{managerId}, " +
            "start_date = #{startDate}, end_date = #{endDate}, " +
            "budget = #{budget}, status = #{status}, progress = #{progress}, " +
            "update_by = #{updateBy}, update_time = NOW() " +
            "WHERE project_id = #{projectId}")
    int update(Project project);
    
    @Delete("DELETE FROM pm_project WHERE project_id = #{projectId}")
    int delete(Long projectId);
    
    @Delete("<script>" +
            "DELETE FROM pm_project WHERE project_id IN " +
            "<foreach collection='ids' item='id' open='(' separator=',' close=')'>" +
            "#{id}" +
            "</foreach>" +
            "</script>")
    int batchDelete(@Param("ids") List<Long> ids);
}
