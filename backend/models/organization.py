from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime

Base = declarative_base()

class Organization(Base):
    """
    机构模型
    """
    __tablename__ = 'organizations'
    
    # 机构序号，从5001开始的序列
    org_id = Column(Integer, primary_key=True, autoincrement=True)
    
    # 机构名称
    org_name = Column(String(200), nullable=False)
    
    # 机构代码
    org_code = Column(String(50), unique=True, nullable=False)
    
    # 父机构的org_id
    parent_org_id = Column(Integer, ForeignKey('organizations.org_id'), nullable=True)
    
    # 活跃状态
    is_active = Column(Boolean, default=True, nullable=False)
    
    # 备注
    note = Column(String(500), nullable=True)
    
    # 创建时间
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    
    # 更新时间
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    
    def __repr__(self):
        return f'<Organization {self.org_name}>'
        
    def to_dict(self):
        return {
            'org_id': self.org_id,
            'org_name': self.org_name,
            'org_code': self.org_code,
            'parent_org_id': self.parent_org_id,
            'is_active': self.is_active,
            'note': self.note,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }