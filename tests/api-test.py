#!/usr/bin/env python3
"""
API自动化测试脚本
"""

import requests
import json
import time

class ProjectManagementAPITest:
    def __init__(self):
        self.base_url = "http://localhost:8080"
        self.token = None
        self.session = requests.Session()
        
    def login(self, username="admin", password="admin123"):
        """登录测试"""
        print("测试用户登录...")
        url = f"{self.base_url}/login"
        data = {
            "username": username,
            "password": password
        }
        
        try:
            response = self.session.post(url, json=data)
            if response.status_code == 200:
                result = response.json()
                if result.get("code") == 200:
                    self.token = result.get("token")
                    print("✅ 登录成功")
                    return True
                else:
                    print(f"❌ 登录失败: {result.get('msg')}")
            else:
                print(f"❌ 登录请求失败: {response.status_code}")
        except Exception as e:
            print(f"❌ 登录异常: {e}")
        
        return False
    
    def test_project_crud(self):
        """项目CRUD测试"""
        print("\n测试项目CRUD操作...")
        
        # 创建项目
        project_data = {
            "projectName": "测试项目",
            "projectCode": "TEST001",
            "description": "这是一个测试项目",
            "managerId": 1,
            "startDate": "2026-03-09",
            "endDate": "2026-04-09",
            "budget": 100000,
            "status": "进行中",
            "progress": 0
        }
        
        # 测试创建
        print("1. 测试创建项目...")
        create_url = f"{self.base_url}/api/projects"
        response = self.session.post(create_url, json=project_data)
        
        if response.status_code == 200:
            result = response.json()
            if result.get("code") == 200:
                project_id = result.get("data", {}).get("projectId")
                print(f"✅ 项目创建成功，ID: {project_id}")
                
                # 测试查询
                print("2. 测试查询项目...")
                get_url = f"{self.base_url}/api/projects/{project_id}"
                response = self.session.get(get_url)
                
                if response.status_code == 200:
                    print("✅ 项目查询成功")
                    
                    # 测试更新
                    print("3. 测试更新项目...")
                    update_data = {"progress": 50}
                    response = self.session.put(get_url, json=update_data)
                    
                    if response.status_code == 200:
                        print("✅ 项目更新成功")
                        
                        # 测试删除
                        print("4. 测试删除项目...")
                        response = self.session.delete(get_url)
                        
                        if response.status_code == 200:
                            print("✅ 项目删除成功")
                            return True
                        else:
                            print(f"❌ 项目删除失败: {response.status_code}")
                    else:
                        print(f"❌ 项目更新失败: {response.status_code}")
                else:
                    print(f"❌ 项目查询失败: {response.status_code}")
            else:
                print(f"❌ 项目创建失败: {result.get('msg')}")
        else:
            print(f"❌ 创建请求失败: {response.status_code}")
        
        return False
    
    def test_task_operations(self):
        """任务操作测试"""
        print("\n测试任务操作...")
        
        # 先创建测试项目
        project_data = {
            "projectName": "任务测试项目",
            "projectCode": "TASK_TEST",
            "description": "用于任务测试的项目",
            "managerId": 1,
            "startDate": "2026-03-09",
            "endDate": "2026-03-16",
            "budget": 50000,
            "status": "进行中",
            "progress": 0
        }
        
        create_url = f"{self.base_url}/api/projects"
        response = self.session.post(create_url, json=project_data)
        
        if response.status_code != 200:
            print("❌ 创建测试项目失败")
            return False
        
        project_id = response.json().get("data", {}).get("projectId")
        
        # 创建任务
        task_data = {
            "taskTitle": "测试任务",
            "description": "这是一个测试任务",
            "projectId": project_id,
            "assigneeId": 2,
            "priority": "P1",
            "status": "待处理",
            "estimateHours": 8,
            "dueDate": "2026-03-10"
        }
        
