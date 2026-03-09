#!/usr/bin/env python3
"""
测试数据生成脚本
用于生成项目、任务、工时等测试数据
"""

import random
import datetime
import csv
from faker import Faker

fake = Faker('zh_CN')

def generate_users(count=20):
    """生成用户数据"""
    users = []
    roles = ['管理员', '项目经理', '开发工程师', '测试工程师', '运维工程师']
    
    for i in range(count):
        user = {
            'user_id': i + 1,
            'username': f'user{i+1:03d}',
            'real_name': fake.name(),
            'email': fake.email(),
            'phone': fake.phone_number(),
            'role': random.choice(roles),
            'hourly_rate': round(random.uniform(100, 300), 2),
            'join_date': fake.date_between(start_date='-2y', end_date='today')
        }
        users.append(user)
    
    return users

def generate_projects(count=5):
    """生成项目数据"""
    projects = []
    statuses = ['规划中', '进行中', '已暂停', '已完成']
    
    for i in range(count):
        start_date = fake.date_between(start_date='-60d', end_date='today')
        end_date = start_date + datetime.timedelta(days=random.randint(30, 180))
        
        project = {
            'project_id': i + 1,
            'project_name': f'项目{i+1}: {fake.catch_phrase()}',
            'description': fake.text(max_nb_chars=200),
            'manager_id': random.randint(1, 3),  # 前3个用户是项目经理
            'start_date': start_date,
            'end_date': end_date,
            'budget': round(random.uniform(50000, 500000), 2),
            'status': random.choice(statuses),
            'progress': random.randint(0, 100)
        }
        projects.append(project)
    
    return projects

def generate_tasks(project_count=5, tasks_per_project=20):
    """生成任务数据"""
    tasks = []
    priorities = ['P0', 'P1', 'P2', 'P3']
    statuses = ['待处理', '进行中', '待测试', '已完成']
    
    task_id = 1
    for project_id in range(1, project_count + 1):
        for _ in range(tasks_per_project):
            due_date = fake.date_between(start_date='today', end_date='+60d')
            
            task = {
                'task_id': task_id,
                'task_title': f'任务{task_id}: {fake.sentence(nb_words=6)}',
                'description': fake.text(max_nb_chars=300),
                'project_id': project_id,
                'assignee_id': random.randint(4, 16),  # 开发工程师
                'priority': random.choice(priorities),
                'status': random.choice(statuses),
                'estimate_hours': round(random.uniform(2, 40), 1),
                'due_date': due_date,
                'created_date': fake.date_between(start_date='-30d', end_date='today')
            }
            tasks.append(task)
            task_id += 1
    
    return tasks

def generate_work_hours(user_count=20, days=30):
    """生成工时数据"""
    work_hours = []
    hour_id = 1
    
    for user_id in range(1, user_count + 1):
        for day in range(days):
            work_date = datetime.date.today() - datetime.timedelta(days=day)
            
            # 每个用户每天有0-3条工时记录
            for _ in range(random.randint(0, 3)):
                start_hour = random.randint(9, 17)
                end_hour = start_hour + random.randint(1, 4)
                
                work_hour = {
                    'hour_id': hour_id,
                    'user_id': user_id,
                    'task_id': random.randint(1, 100),  # 假设有100个任务
                    'work_date': work_date,
                    'start_time': f'{start_hour:02d}:00:00',
                    'end_time': f'{end_hour:02d}:00:00',
                    'hours': end_hour - start_hour,
                    'description': fake.sentence(nb_words=10),
                    'status': '已审核'
                }
                work_hours.append(work_hour)
                hour_id += 1
    
    return work_hours

def save_to_csv(data, filename):
    """保存数据到CSV文件"""
    if not data:
        return
    
    keys = data[0].keys()
    with open(filename, 'w', newline='', encoding='utf-8-sig') as f:
        writer = csv.DictWriter(f, fieldnames=keys)
        writer.writeheader()
        writer.writerows(data)
    
    print(f"已生成 {len(data)} 条数据到 {filename}")

def main():
    """主函数"""
    print("开始生成测试数据...")
    
    # 生成用户数据
    users = generate_users(20)
    save_to_csv(users, '测试数据-用户.csv')
    
    # 生成项目数据
    projects = generate_projects(5)
    save_to_csv(projects, '测试数据-项目.csv')
    
    # 生成任务数据
    tasks = generate_tasks(5, 20)
    save_to_csv(tasks, '测试数据-任务.csv')
    
    # 生成工时数据
    work_hours = generate_work_hours(20, 30)
    save_to_csv(work_hours, '测试数据-工时.csv')
    
    print("测试数据生成完成！")
    print("文件列表：")
    print("- 测试数据-用户.csv")
    print("- 测试数据-项目.csv")
    print("- 测试数据-任务.csv")
    print("- 测试数据-工时.csv")

if __name__ == '__main__':
    main()
