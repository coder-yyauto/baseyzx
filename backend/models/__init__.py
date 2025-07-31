"""
数据模型模块
"""

from .user import User
from .organization import Organization
from .user_org_relation import UserOrgRelation

# 导出所有模型
__all__ = ['User', 'Organization', 'UserOrgRelation']

# 创建一个包含所有模型的列表，方便在应用中统一处理
all_models = [User, Organization, UserOrgRelation]