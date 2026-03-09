#!/usr/bin/env python3
# 简化的测试数据生成工具

import json
import random
from datetime import datetime, timedelta

def generate_test_data():
    """生成测试数据"""
    
    # 用户数据
    users = [
        {"id": 1, "username": "admin", "name": "管理员", "role": "admin"},
        {"id": 2, "username": "manager1", "name": "项目经理1", "role": "manager"},
        {"id": 3, "username": "manager2", "name": "项目经理2", "role": "manager"},
        {"id": 4, "username": "dev1", "name": "开发人员1", "role": "developer"},
        {"id": 5, "username": "dev2", "name": "开发人员2", "role": "developer"},
        {"id": 6, "username": "tester1", "name": "测试人员1", "role": "tester"},
        {"id": 7, "username": "tester2", "name": "测试人员2", "role": "tester"}
    ]
    
    # 项目数据
    projects = []
    for i in range(1, 6):
        projects.append({
            "id": i,
            "name": f"项目{i}",
            "code": f"PROJ-{i:03d}",
            "description": f"这是第{i}个测试项目",
            "manager_id": random.choice([2, 3]),
            "status": random.choice(["planning", "in_progress", "completed"]),
            "budget": random.randint(10000, 100000),
            "start_date": (datetime.now() - timedelta(days=random.randint(0, 30))).strftime("%Y-%m-%d"),
            "end_date": (datetime.now() + timedelta(days=random.randint(30, 90))).strftime("%Y-%m-%d")
        })
    
    # 任务数据
    tasks = []
    task_id = 1
    for project in projects:
        for i in range(random.randint(3, 8)):
            tasks.append({
                "id": task_id,
                "project_id": project["id"],
                "title": f"任务{task_id}: {project['name']}的第{i+1}个任务",
                "description": f"这是{project['name']}的第{i+1}个任务描述",
                "assignee_id": random.choice([4, 5, 6, 7]),
                "status": random.choice(["todo", "in_progress", "review", "done"]),
                "priority": random.choice(["low", "medium", "high", "urgent"]),
                "estimate_hours": random.randint(4, 40),
                "actual_hours": random.randint(0, 50),
                "due_date": (datetime.now() + timedelta(days=random.randint(1, 30))).strftime("%Y-%m-%d")
            })
            task_id += 1
    
    # 工时数据
    workhours = []
    for i in range(1, 51):
        task = random.choice(tasks)
        workhours.append({
            "id": i,
            "user_id": task["assignee_id"],
            "project_id": task["project_id"],
            "task_id": task["id"],
            "work_date": (datetime.now() - timedelta(days=random.randint(0, 30))).strftime("%Y-%m-%d"),
            "hours": round(random.uniform(0.5, 8.0), 1),
            "description": f"完成了{task['title']}的部分工作",
            "status": random.choice(["pending", "approved", "rejected"])
        })
    
    # 保存数据
    test_data = {
        "users": users,
        "projects": projects,
        "tasks": tasks,
        "workhours": workhours,
        "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "total_records": len(users) + len(projects) + len(tasks) + len(workhours)
    }
    
    with open("tests/test_data.json", "w", encoding="utf-8") as f:
        json.dump(test_data, f, ensure_ascii=False, indent=2)
    
    print(f"✅ 测试数据生成完成！")
    print(f"📊 数据统计：")
    print(f"  - 用户：{len(users)} 条")
    print(f"  - 项目：{len(projects)} 条")
    print(f"  - 任务：{len(tasks)} 条")
    print(f"  - 工时：{len(workhours)} 条")
    print(f"  - 总计：{test_data['total_records']} 条记录")
    print(f"📁 数据文件：tests/test_data.json")

if __name__ == "__main__":
    generate_test_data()
