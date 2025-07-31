# 数据库迁移

本目录包含数据库迁移脚本，用于管理数据库模式的变更。

## 初始化数据库

```bash
cd backend
python init_db.py
```

## 使用Flask-Migrate管理数据库迁移

1. 初始化迁移仓库：
```bash
flask db init
```

2. 创建迁移脚本：
```bash
flask db migrate -m "初始化数据库结构"
```

3. 应用迁移：
```bash
flask db upgrade
```