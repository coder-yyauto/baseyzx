# 项目管理系统

## 项目结构

本项目采用前后端一体化设计：
- 前端：Vue 3.5 + Vite + Element Plus
- 后端：Flask + SQLite

## 开发环境配置

### Python虚拟环境管理

本项目使用miniforge3管理Python虚拟环境，管理命令为conda。所有与虚拟环境相关的操作必须使用`-n python3.12`参数。

#### 创建虚拟环境
```bash
conda create -n python3.12 python=3.12
```

#### 激活虚拟环境
```bash
conda activate python3.12
```

#### 安装依赖
```bash
conda activate python3.12
pip install -r backend/requirements.txt
```

#### 检查已安装包
```bash
conda activate python3.12
conda list
```

### 环境变量配置

1. 复制后端环境变量示例文件：
```bash
cp backend/.env.example backend/.env
```

2. 根据需要修改 `.env` 文件中的配置

### 数据库配置

数据库使用SQLite，文件路径位于项目根目录的 `data/sqlite3.db`

## 服务管理

本系统起停只使用 `scripts/servicectl.sh` 脚本，不使用其他脚本。

### 服务端口规范

- 前端服务：固定运行在 5173 端口
- 后端服务：固定运行在 5000 端口

脚本在启动服务时会自动检查端口冲突，如遇冲突会先终止占用端口的进程再启动服务，确保服务正常运行。

### 使用方法

```bash
# 启动所有服务
./scripts/servicectl.sh start

# 停止所有服务
./scripts/servicectl.sh stop

# 重启所有服务
./scripts/servicectl.sh restart

# 检查所有服务状态
./scripts/servicectl.sh status

# 单独管理前端服务
./scripts/servicectl.sh start front
./scripts/servicectl.sh stop front
./scripts/servicectl.sh restart front
./scripts/servicectl.sh status front

# 单独管理后端服务
./scripts/servicectl.sh start back
./scripts/servicectl.sh stop back
./scripts/servicectl.sh restart back
./scripts/servicectl.sh status back
```

## 启动项目

### 启动后端服务
```bash
conda activate python3.12
cd backend
python run.py
```

#### 启动前端开发服务器
```bash
cd frontend
npm install
npm run dev
```