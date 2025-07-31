# 开发环境服务管理脚本

本目录包含用于管理开发环境服务的脚本，可以方便地启动、停止、重启和检查前后端服务状态。

## 脚本说明

### 统一服务管理脚本（推荐）
- `pyqctl.sh`: 统一的服务控制脚本，支持更智能的服务管理逻辑
  - `start`: 启动服务（如果服务已运行则不重复启动）
  - `stop`: 停止服务（无条件杀进程）
  - `restart`: 重启服务（先无条件杀进程再启动）
  - `kill`: 强制终止服务进程
  - `status`: 检查服务状态

### 其他脚本
- `kill-front.sh`: 强制终止前端服务进程（已废弃）
- `kill-back.sh`: 强制终止后端服务进程（已废弃）
- `start-front.sh`: 启动前端服务（已废弃）
- `stop-front.sh`: 停止前端服务（已废弃）
- `restart-front.sh`: 重启前端服务（已废弃）
- `status-front.sh`: 检查前端服务状态（已废弃）
- `start-back.sh`: 启动后端服务（已废弃）
- `stop-back.sh`: 停止后端服务（已废弃）
- `restart-back.sh`: 重启后端服务（已废弃）
- `status-back.sh`: 检查后端服务状态（已废弃）
- `start-all.sh`: 启动所有服务（已废弃）
- `stop-all.sh`: 停止所有服务（已废弃）
- `restart-all.sh`: 重启所有服务（已废弃）
- `status-all.sh`: 检查所有服务状态（已废弃）

## 使用方法

推荐使用统一服务管理脚本 `pyqctl.sh` 来管理服务：

```bash
# 启动所有服务
./scripts/pyqctl.sh start

# 停止所有服务
./scripts/pyqctl.sh stop

# 重启所有服务
./scripts/pyqctl.sh restart

# 检查所有服务状态
./scripts/pyqctl.sh status

# 单独管理前端服务
./scripts/pyqctl.sh start front
./scripts/pyqctl.sh stop front
./scripts/pyqctl.sh restart front
./scripts/pyqctl.sh status front

# 单独管理后端服务
./scripts/pyqctl.sh start back
./scripts/pyqctl.sh stop back
./scripts/pyqctl.sh restart back
./scripts/pyqctl.sh status back
```

## 注意事项

1. 所有脚本都需要在项目根目录下执行
2. 脚本会自动处理进程管理和状态检查
3. 前端服务默认运行在5173端口
4. 后端服务默认运行在5000端口