from sqlalchemy import Column, Integer, String, Boolean, DateTime
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime

Base = declarative_base()

class User(Base):
    """
    用户模型
    """
    __tablename__ = 'users'
    
    # 用户序号，从221001开始的序列
    user_id = Column(Integer, primary_key=True, autoincrement=True)
    
    # 登录用户名
    username = Column(String(80), unique=True, nullable=False)
    
    # 姓名/昵称
    realname = Column(String(100), nullable=False)
    
    # 活跃状态
    is_active = Column(Boolean, default=True, nullable=False)
    
    # 备注
    note = Column(String(500), nullable=True)
    
    # 创建时间
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    
    # 更新时间
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    
    def __repr__(self):
        return f'<User {self.username}>'
        
    def to_dict(self):
        return {
            'user_id': self.user_id,
            'username': self.username,
            'realname': self.realname,
            'is_active': self.is_active,
            'note': self.note,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }