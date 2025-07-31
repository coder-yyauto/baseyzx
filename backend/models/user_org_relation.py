from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, UniqueConstraint
from sqlalchemy.ext.declarative import declarative_base
import uuid
from datetime import datetime

Base = declarative_base()

class UserOrgRelation(Base):
    """
    用户机构关系模型
    """
    __tablename__ = 'user_org_relations'
    
    # 关系记录号，UUID格式
    uuid = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    
    # 用户ID
    user_id = Column(Integer, ForeignKey('users.user_id'), nullable=False)
    
    # 机构ID
    org_id = Column(Integer, ForeignKey('organizations.org_id'), nullable=False)
    
    # 是否为管理员
    is_administrator = Column(Boolean, default=False, nullable=False)
    
    # 是否有特殊权限
    is_special = Column(Boolean, default=False, nullable=False)
    
    # 备注
    note = Column(String(500), nullable=True)
    
    # 创建时间
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    
    # 更新时间
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    
    # 添加唯一约束，确保用户和机构的关系唯一
    __table_args__ = (UniqueConstraint('user_id', 'org_id', name='uq_user_org'),)
    
    def __repr__(self):
        return f'<UserOrgRelation user_id={self.user_id} org_id={self.org_id}>'
        
    def to_dict(self):
        return {
            'uuid': self.uuid,
            'user_id': self.user_id,
            'org_id': self.org_id,
            'is_administrator': self.is_administrator,
            'is_special': self.is_special,
            'note': self.note,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }