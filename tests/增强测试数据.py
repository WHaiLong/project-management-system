#!/usr/bin/env python3
"""
增强版测试数据生成器
支持快速生成大量测试数据
"""

import random
import datetime
import json
import csv
from faker import Faker

fake = Faker('zh_CN')

class EnhancedTestDataGenerator:
    def __init__(self):
        self.projects = []
        self.tasks = []
        self.work_hours = []
        self.users = []
        
    def generate_users(self, count=20):
        """生成用户数据"""
        print(f"生成 {count} 个用户...")
        departments = ['研发部', '测试部', '产品部', '设计部', '运维部', '市场部']
        positions = ['工程师', '高级工程师', '专家', '经理', '总监']
        
        for i in range(1, count + 1):
            user = {
                'user_id': i,
                'username': fake.user_name(),
                'real_name': fake.name(),
                'email': fake.email(),
                'phone': fake.phone_number(),
                'department': random.choice(departments),
                'position': random.choice(positions),
                'hourly_rate': round(random.uniform(100, 300), 2),
                'join_date': fake.date_between(start_date='-5y', end_date='today').isoformat()
            }
            self.users.append(user)
        
        print(f"✅ 用户数据生成完成: {len(self.users)} 条")
        return self.users
    
    def generate_projects(self, count=10):
        """生成项目数据"""
        print(f"生成 {count} 个项目...")
        statuses = ['planning', 'in_progress', 'paused', 'completed']
        
        for i in range(1, count + 1):
            start_date = fake.date_between(start_date='-60d', end_date='today')
            end_date = start_date + datetime.timedelta(days=random.randint(30, 180))
            
            project = {
                'project_id': i,
                'project_code': f'PROJ-{i:03d}',
                'project_name': f'{fake.company()}项目',
                'description': fake.text(max_nb_chars=200),
                'manager_id': random.randint(1, 5),
                'start_date': start_date.isoformat(),
                'end_date': end_date.isoformat(),
                'budget': round(random.uniform(50000, 500000), 2),
                'status': random.choice(statuses),
                'progress': random.randint(0, 100)
            }
            self.projects.append(project)
        
        print(f"✅ 项目数据生成完成: {len(self.projects)} 条")
        return self.projects
    
    def generate_tasks(self, count_per_project=5):
        """生成任务数据"""
        print("生成任务数据...")
        priorities = ['P0', 'P1', 'P2', 'P3']
        statuses = ['pending', 'in_progress', 'completed', 'overdue']
        task_id = 1
        
        for project in self.projects:
            for i in range(count_per_project):
                due_date = fake.date_between(
                    start_date=datetime.date.today(),
                    end_date=datetime.date.today() + datetime.timedelta(days=30)
                )
                
                task = {
                    'task_id': task_id,
                    'task_code': f'TASK-{task_id:04d}',
                    'title': f'{fake.bs()}任务',
                    'description': fake.text(max_nb_chars=100),
                    'project_id': project['project_id'],
                    'assignee_id': random.randint(1, 20),
                    'priority': random.choice(priorities),
                    'status': random.choice(statuses),
                    'estimate_hours': round(random.uniform(4, 40), 1),
                    'actual_hours': round(random.uniform(0, 50), 1),
                    'due_date': due_date.isoformat(),
                    'completed_date': None
                }
                
                if task['status'] == 'completed':
                    task['completed_date'] = fake.date_between(
                        start_date=datetime.date.today() - datetime.timedelta(days=30),
                        end_date=datetime.date.today()
                    ).isoformat()
                
                self.tasks.append(task)
                task_id += 1
        
        print(f"✅ 任务数据生成完成: {len(self.tasks)} 条")
        return self.tasks
    
    def generate_work_hours(self, count_per_user=20):
        """生成工时数据"""
        print("生成工时数据...")
        statuses = ['pending', 'approved', 'rejected']
        work_hour_id = 1
        
        for user in self.users[:10]:  # 前10个用户
            for i in range(count_per_user):
                work_date = fake.date_between(
                    start_date=datetime.date.today() - datetime.timedelta(days=30),
                    end_date=datetime.date.today()
                )
                
                task = random.choice(self.tasks) if self.tasks else None
                
                work_hour = {
                    'work_hour_id': work_hour_id,
                    'user_id': user['user_id'],
                    'project_id': random.choice(self.projects)['project_id'] if self.projects else 1,
                    'task_id': task['task_id'] if task else None,
                    'work_date': work_date.isoformat(),
                    'hours': round(random.uniform(0.5, 12), 1),
                    'description': fake.text(max_nb_chars=50),
                    'status': random.choice(statuses),
                    'approver_id': random.randint(1, 5)                }
                
                if work_hour['status'] != 'pending':
                    work_hour['approved_time'] = fake.date_time_between(
                        start_date=work_date,
                        end_date=datetime.datetime.now()
                    ).isoformat()
                
                self.work_hours.append(work_hour)
                work_hour_id += 1
        
        print(f"✅ 工时数据生成完成: {len(self.work_hours)} 条")
        return self.work_hours
    
    def export_to_sql(self, filename='test_data.sql'):
        """导出为SQL文件"""
        print(f"导出SQL文件: {filename}")
        
        with open(filename, 'w', encoding='utf-8') as f:
            f.write('-- 项目管理系统测试数据\n')
            f.write('-- 生成时间: {}\n\n'.format(datetime.datetime.now()))
            
            # 清空表
            f.write('-- 清空现有数据\n')
            f.write('TRUNCATE TABLE pm_work_hour;\n')
            f.write('TRUNCATE TABLE pm_task;\n')
            f.write('TRUNCATE TABLE pm_project;\n')
            f.write('TRUNCATE TABLE pm_user_ext;\n\n')
            
            # 插入用户数据
            f.write('-- 用户扩展数据\n')
            for user in self.users:
                f.write("INSERT INTO pm_user_ext (user_id, hourly_rate, department, position, join_date) VALUES (")
                f.write(f"{user['user_id']}, ")
                f.write(f"{user['hourly_rate']}, ")
                f.write(f"'{user['department']}', ")
                f.write(f"'{user['position']}', ")
                f.write(f"'{user['join_date']}');\n")
            
            # 插入项目数据
            f.write('\n-- 项目数据\n')
            for project in self.projects:
                f.write("INSERT INTO pm_project (project_id, project_name, project_code, description, manager_id, start_date, end_date, budget, status, progress) VALUES (")
                f.write(f"{project['project_id']}, ")
                f.write(f"'{project['project_name']}', ")
                f.write(f"'{project['project_code']}', ")
                f.write(f"'{project['description']}', ")
                f.write(f"{project['manager_id']}, ")
                f.write(f"'{project['start_date']}', ")
                f.write(f"'{project['end_date']}', ")
                f.write(f"{project['budget']}, ")
                f.write(f"'{project['status']}', ")
                f.write(f"{project['progress']});\n")
            
            # 插入任务数据
            f.write('\n-- 任务数据\n')
            for task in self.tasks:
                f.write("INSERT INTO pm_task (task_id, task_code, title, description, project_id, assignee_id, priority, status, estimate_hours, actual_hours, due_date, completed_date) VALUES (")
                f.write(f"{task['task_id']}, ")
                f.write(f"'{task['task_code']}', ")
                f.write(f"'{task['title']}', ")
                f.write(f"'{task['description']}', ")
                f.write(f"{task['project_id']}, ")
                f.write(f"{task['assignee_id']}, ")
                f.write(f"'{task['priority']}', ")
                f.write(f"'{task['status']}', ")
                f.write(f"{task['estimate_hours']}, ")
                f.write(f"{task['actual_hours']}, ")
                f.write(f"'{task['due_date']}', ")
                f.write(f"{'NULL' if task['completed_date'] is None else f\"'{task['completed_date']}'\"});\n")
            
            # 插入工时数据
            f.write('\n-- 工时数据\n')
            for work_hour in self.work_hours:
                f.write("INSERT INTO pm_work_hour (work_hour_id, user_id, project_id, task_id, work_date, hours, description, status, approver_id, approved_time) VALUES (")
                f.write(f"{work_hour['work_hour_id']}, ")
                f.write(f"{work_hour['user_id']}, ")
                f.write(f"{work_hour['project_id']}, ")
                f.write(f"{'NULL' if work_hour['task_id'] is None else work_hour['task_id']}, ")
                f.write(f"'{work_hour['work_date']}', ")
                f.write(f"{work_hour['hours']}, ")
                f.write(f"'{work_hour['description']}', ")
                f.write(f"'{work_hour['status']}', ")
                f.write(f"{work_hour['approver_id']}, ")
                f.write(f"{'NULL' if 'approved_time' not in work_hour else f\"'{work_hour['approved_time']}'\"});\n")
            
            f.write('\n-- 数据统计\n')
            f.write('SELECT "用户数" AS type, COUNT(*) AS count FROM pm_user_ext\n')
            f.write('UNION ALL\n')
            f.write('SELECT "项目数", COUNT(*) FROM pm_project\n')
            f.write('UNION ALL\n')
            f.write('SELECT "任务数", COUNT(*) FROM pm_task\n')
            f.write('UNION ALL\n')
            f.write('SELECT "工时记录数", COUNT(*) FROM pm_work_hour;\n')
        
        print(f"✅ SQL文件导出完成: {filename}")
    
    def export_to_json(self, filename='test_data.json'):
        """导出为JSON文件"""
        print(f"导出JSON文件: {filename}")
        
        data = {
            'users': self.users,
            'projects': self.projects,
            'tasks': self.tasks,
            'work_hours': self.work_hours,
            'metadata': {
                'generated_at': datetime.datetime.now().isoformat(),
                'total_records': len(self.users) + len(self.projects) + len(self.tasks) + len(self.work_hours)
            }
        }
        
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        
        print(f"✅ JSON文件导出完成: {filename}")
    
    def export_to_csv(self):
        """导出为CSV文件"""
        print("导出CSV文件...")
        
        # 导出用户数据
        with open('users.csv', 'w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=self.users[0].keys())
            writer.writeheader()
            writer.writerows(self.users)
        
        # 导出项目数据
        with open('projects.csv', 'w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=self.projects[0].keys())
            writer.writeheader()
            writer.writerows(self.projects)
        
        # 导出任务数据
        with open('tasks.csv', 'w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=self.tasks[0].keys())
            writer.writeheader()
            writer.writerows(self.tasks)
        
        # 导出工时数据
        with open('work_hours.csv', 'w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=self.work_hours[0].keys())
            writer.writeheader()
            writer.writerows(self.work_hours)
        
        print("✅ CSV文件导出完成: users.csv, projects.csv, tasks.csv, work_hours.csv")

def main():
    """主函数"""
    print("🚀 增强版测试数据生成器")
    print("=" * 50)
    
    generator = EnhancedTestDataGenerator()
    
    # 生成数据
    generator.generate_users(20)
    generator.generate_projects(10)
    generator.generate_tasks(5)  # 每个项目5个任务
    generator.generate_work_hours(20)  # 每个用户20条工时记录
    
    # 导出数据
    generator.export_to_sql()
    generator.export_to_json()
    generator.export_to_csv()
    
    print("\n🎉 测试数据生成完成！")
    print(f"总计生成: {len(generator.users)} 用户")
    print(f"总计生成: {len(generator.projects)} 项目")
    print(f"总计生成: {len(generator.tasks)} 任务")
    print(f"总计生成: {len(generator.work_hours)} 工时记录")
    print(f"总计记录: {len(generator.users) + len(generator.projects) + len(generator.tasks) + len(generator.work_hours)}")

if __name__ == '__main__':
    main()
