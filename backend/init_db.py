"""
数据库初始化脚本
"""
import sys
import os

# 添加项目根目录到Python路径
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app import create_app
from models import all_models

def init_db():
    """
    初始化数据库表
    """
    app = create_app()
    
    with app.app_context():
        # 创建所有表
        from app import db
        db.create_all()
        
        print("数据库表创建成功！")
        print("创建的表:")
        for model in all_models:
            print(f"  - {model.__name__} ({model.__tablename__})")

if __name__ == '__main__':
    init_db()