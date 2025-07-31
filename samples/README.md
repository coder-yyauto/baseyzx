# 数据库样本文件

## 说明

此目录包含数据库样本文件，用于开发和测试环境。

## 文件列表

- [empty_sample.db](file:///Volumes/MiniData/1_trae/baseyzx/samples/empty_sample.db) - 空数据库样本，包含表结构但无数据

## 使用方法

1. 开发环境初始化时，可以复制此文件作为初始数据库：
   ```bash
   cp samples/empty_sample.db data/sqlite3.db
   ```

2. 如果数据模型发生变更，请更新此样本文件：
   ```bash
   # 删除旧的数据库文件
   rm data/sqlite3.db
   # 重新初始化数据库
   cd backend && python init_db.py
   # 复制新的空数据库作为样本
   cp data/sqlite3.db ../samples/empty_sample.db
   ```

## 注意事项

- 样本数据库仅包含表结构，不包含任何业务数据
- 当数据模型发生变更时，需要同步更新样本数据库文件
- 不要在样本数据库中存储任何敏感或机密信息