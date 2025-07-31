#!/bin/bash

# 项目根目录
PROJECT_ROOT="/Volumes/MiniData/1_trae/baseyzx"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# 检查后端服务状态
check_backend_status() {
  echo -e "${YELLOW}=== 后端服务状态检查 ===${NC}"
  if pgrep -f "python run.py" > /dev/null; then
    echo -e "${GREEN}后端服务状态: 运行中${NC}"
    echo "进程信息:"
    ps aux | grep "python run.py" | grep -v grep
    echo "端口占用情况:"
    lsof -i :5000 2>/dev/null || echo "端口5000未被占用"
    return 0  # 服务运行中
  else
    echo -e "${RED}后端服务状态: 未运行${NC}"
    return 1  # 服务未运行
  fi
}

# 检查前端服务状态
check_frontend_status() {
  echo -e "${YELLOW}=== 前端服务状态检查 ===${NC}"
  if pgrep -f "npm run dev" > /dev/null; then
    echo -e "${GREEN}前端服务状态: 运行中${NC}"
    echo "进程信息:"
    ps aux | grep "npm run dev" | grep -v grep
    echo "端口占用情况:"
    lsof -i :5173 2>/dev/null || echo "端口5173未被占用"
    return 0  # 服务运行中
  else
    echo -e "${RED}前端服务状态: 未运行${NC}"
    return 1  # 服务未运行
  fi
}

# 启动后端服务
b_up() {
  echo -e "${YELLOW}正在启动后端服务...${NC}"
  cd "$PROJECT_ROOT/backend"
  
  # 检查并终止占用5000端口的进程
  if lsof -i :5000 | grep LISTEN > /dev/null; then
    echo -e "${YELLOW}发现5000端口被占用，正在终止相关进程...${NC}"
    BACKEND_PIDS=$(lsof -t -i :5000)
    if [ -n "$BACKEND_PIDS" ]; then
      echo "找到以下占用5000端口的进程:"
      echo "$BACKEND_PIDS"
      kill -9 $BACKEND_PIDS
      echo -e "${GREEN}占用5000端口的进程已终止${NC}"
    fi
    sleep 2
  fi
  
  nohup conda run -n python3.12 python run.py > "$PROJECT_ROOT/backend.log" 2>&1 &
  sleep 3
  check_backend_status
}

# 启动后端服务（带状态检查）
start_backend() {
  echo -e "${YELLOW}正在启动后端服务...${NC}"
  
  # 调用纯启动函数
  b_up
  
  # 再次检查状态，如果不正常则重试一次
  if ! check_backend_status; then
    echo -e "${YELLOW}后端服务启动失败，重试一次...${NC}"
    sleep 2
    b_up
  fi
}

# 启动前端服务
f_up() {
  echo -e "${YELLOW}正在启动前端服务...${NC}"
  cd "$PROJECT_ROOT/frontend"
  
  # 检查并终止占用5173端口的进程
  if lsof -i :5173 | grep LISTEN > /dev/null; then
    echo -e "${YELLOW}发现5173端口被占用，正在终止相关进程...${NC}"
    FRONTEND_PIDS=$(lsof -t -i :5173)
    if [ -n "$FRONTEND_PIDS" ]; then
      echo "找到以下占用5173端口的进程:"
      echo "$FRONTEND_PIDS"
      kill -9 $FRONTEND_PIDS
      echo -e "${GREEN}占用5173端口的进程已终止${NC}"
    fi
    sleep 2
  fi
  
  # 启动前端服务并强制使用5173端口
  echo -e "${YELLOW}启动前端服务(端口5173)...${NC}"
  nohup npm run dev -- --port 5173 > "$PROJECT_ROOT/frontend.log" 2>&1 &
  sleep 3
  check_frontend_status
}

# 启动前端服务（带端口检查）
f_up_with_port_check() {
  echo -e "${YELLOW}正在启动前端服务...${NC}"
  cd "$PROJECT_ROOT/frontend"
  
  # 检查并终止占用5173端口的进程
  if lsof -i :5173 | grep LISTEN > /dev/null; then
    echo -e "${YELLOW}发现5173端口被占用，正在终止相关进程...${NC}"
    # 直接终止占用5173端口的进程，不调用带有状态检查的kill_frontend
    FRONTEND_PIDS=$(lsof -t -i :5173)
    if [ -n "$FRONTEND_PIDS" ]; then
      echo "找到以下占用5173端口的进程:"
      echo "$FRONTEND_PIDS"
      kill -9 $FRONTEND_PIDS
      echo -e "${GREEN}占用5173端口的进程已终止${NC}"
    fi
    sleep 2  # 等待进程终止
  fi

  # 启动前端服务，让Vite自动选择可用端口
  echo -e "${YELLOW}启动前端服务...${NC}"
  nohup npm run dev > "$PROJECT_ROOT/frontend.log" 2>&1 &
  sleep 5  # 增加等待时间，确保Vite完全启动
  
  # 获取Vite实际使用的端口
  ACTUAL_PORT=$(grep -o "http://localhost:[0-9]*" "$PROJECT_ROOT/frontend.log" | head -1 | cut -d: -f3)
  if [ -n "$ACTUAL_PORT" ]; then
    echo -e "${GREEN}前端服务已在端口 $ACTUAL_PORT 上启动${NC}"
    # 更新FRONTEND_PORT变量供状态检查使用
    FRONTEND_PORT=$ACTUAL_PORT
  else
    echo -e "${YELLOW}未能确定前端服务实际端口${NC}"
  fi
  
  check_frontend_status
}

# 启动前端服务（带状态检查）
start_frontend() {
  echo -e "${YELLOW}正在启动前端服务...${NC}"
  
  # 调用带端口检查的启动函数
  f_up_with_port_check
  
  # 再次检查状态，如果不正常则重试一次
  if ! check_frontend_status; then
    echo -e "${YELLOW}前端服务启动失败，重试一次...${NC}"
    sleep 2
    f_up_with_port_check
  fi
}

# 停止后端服务
stop_backend() {
  echo -e "${YELLOW}正在停止后端服务...${NC}"
  # 直接杀进程
  kill_backend
}

# 停止前端服务
stop_frontend() {
  echo -e "${YELLOW}正在停止前端服务...${NC}"
  # 直接杀进程
  kill_frontend
}

# 强制终止后端服务
kill_backend() {
  echo -e "${YELLOW}正在强制终止后端服务...${NC}"
  # 使用更精确的匹配方式，避免误杀其他进程
  BACKEND_PIDS=$(pgrep -f "python.*run\.py")

  if [ -z "$BACKEND_PIDS" ]; then
    echo -e "${RED}没有找到后端服务进程${NC}"
  else
    echo "找到以下后端服务进程:"
    echo "$BACKEND_PIDS"
    # 检查进程是否确实是要终止的后端服务
    for pid in $BACKEND_PIDS; do
      CMDLINE=$(ps -o command= -p $pid)
      # 更严格的检查，确保进程命令行包含完整的路径和文件名
      if [[ $CMDLINE == *"python"* && $CMDLINE == *"$PROJECT_ROOT/backend/run.py"* && $CMDLINE != *"firefox"* ]]; then
        echo "终止后端服务进程: $pid"
        kill -9 $pid
      else
        echo "跳过非后端服务进程: $pid"
      fi
    done
    echo -e "${GREEN}后端服务进程已终止${NC}"
  fi
}

# 强制终止前端服务
kill_frontend() {
  echo -e "${YELLOW}正在强制终止前端服务...${NC}"
  # 使用更精确的匹配方式，避免误杀其他进程
  FRONTEND_PIDS=$(pgrep -f "npm.*run.*dev")

  if [ -z "$FRONTEND_PIDS" ]; then
    echo -e "${RED}没有找到前端服务进程${NC}"
  else
    echo "找到以下前端服务进程:"
    echo "$FRONTEND_PIDS"
    # 检查进程是否确实是要终止的前端服务
    for pid in $FRONTEND_PIDS; do
      CMDLINE=$(ps -o command= -p $pid)
      # 更严格的检查，确保进程命令行不包含firefox
      if [[ $CMDLINE == *"npm"* && $CMDLINE == *"run"* && $CMDLINE == *"dev"* && $CMDLINE != *"firefox"* ]]; then
        echo "终止前端服务进程: $pid"
        kill -9 $pid
      else
        echo "跳过非前端服务进程: $pid"
      fi
    done
    echo -e "${GREEN}前端服务进程已终止${NC}"
  fi
}

# 重启后端服务
restart_backend() {
  echo -e "${YELLOW}正在重启后端服务...${NC}"
  
  # 杀进程
  kill_backend
  
  # 启动服务
  b_up
  
  # 检查状态，如果不正常则重试最多三次
  local retry_count=0
  while [ $retry_count -lt 3 ]; do
    if check_backend_status; then
      break
    else
      echo -e "${YELLOW}后端服务启动失败，重试第 $((retry_count+1)) 次...${NC}"
      sleep 2
      b_up
      retry_count=$((retry_count+1))
    fi
  done
  
  if [ $retry_count -eq 3 ]; then
    echo -e "${RED}后端服务重启失败，已重试3次${NC}"
  fi
}

# 重启前端服务
restart_frontend() {
  echo -e "${YELLOW}正在重启前端服务...${NC}"
  
  # 杀进程
  kill_frontend
  
  # 启动服务
  f_up_with_port_check
  
  # 检查状态，如果不正常则重试最多三次
  local retry_count=0
  while [ $retry_count -lt 3 ]; do
    if check_frontend_status; then
      break
    else
      echo -e "${YELLOW}前端服务启动失败，重试第 $((retry_count+1)) 次...${NC}"
      sleep 2
      f_up_with_port_check
      retry_count=$((retry_count+1))
    fi
  done
  
  if [ $retry_count -eq 3 ]; then
    echo -e "${RED}前端服务重启失败，已重试3次${NC}"
  fi
}

# 显示帮助信息
show_help() {
  echo "用法: $0 {start|restart|stop|status} [front|back|all]"
  echo "示例:"
  echo "  $0 start            # 启动前后端服务"
  echo "  $0 start front      # 启动前端服务"
  echo "  $0 restart          # 重启前后端服务"
  echo "  $0 restart back     # 重启后端服务"
  echo "  $0 stop             # 停止所有服务"
  echo "  $0 stop back        # 停止后端服务"
  echo "  $0 status           # 检查所有服务状态"
  echo "  $0 status back      # 检查后端服务状态"
}

# 主逻辑
if [ $# -lt 1 ]; then
  show_help
  exit 1
fi

ACTION=$1
TARGET=$2

# 如果ACTION是start/restart/stop且没有TARGET，则设置TARGET为all
if [ -z "$TARGET" ]; then
  case "$ACTION" in
    start|restart|stop)
      TARGET="all"
      ;;
  esac
fi

case "$ACTION" in
  start)
    case "$TARGET" in
      front) 
        # 先检查服务状态
        if check_frontend_status; then
          echo -e "${YELLOW}前端服务已启动，无需重复启动${NC}"
        else
          start_frontend
          # 最后检查状态
          check_frontend_status
        fi
        ;;
      back) 
        # 先检查服务状态
        if check_backend_status; then
          echo -e "${YELLOW}后端服务已启动，无需重复启动${NC}"
        else
          start_backend
          # 最后检查状态
          check_backend_status
        fi
        ;;
      all) 
        # 先检查服务状态
        if check_frontend_status; then
          echo -e "${YELLOW}前端服务已启动，无需重复启动${NC}"
        else
          start_frontend
          # 最后检查状态
          check_frontend_status
        fi
        
        if check_backend_status; then
          echo -e "${YELLOW}后端服务已启动，无需重复启动${NC}"
        else
          start_backend
          # 最后检查状态
          check_backend_status
        fi
        ;;
      *) show_help ;;
    esac
    ;;
  restart)
    case "$TARGET" in
      front) 
        restart_frontend
        # 最后检查状态
        check_frontend_status
        ;;
      back) 
        restart_backend
        # 最后检查状态
        check_backend_status
        ;;
      all) 
        restart_frontend
        # 最后检查状态
        check_frontend_status
        
        restart_backend
        # 最后检查状态
        check_backend_status
        ;;
      *) show_help ;;
    esac
    ;;
  stop)
    case "$TARGET" in
      front) 
        stop_frontend
        # 最后检查状态
        check_frontend_status
        ;;
      back) 
        stop_backend
        # 最后检查状态
        check_backend_status
        ;;
      all) 
        stop_frontend
        # 最后检查状态
        check_frontend_status
        
        stop_backend
        # 最后检查状态
        check_backend_status
        ;;
      *) show_help ;;
    esac
    ;;

  status)
    # 如果没有TARGET参数，则设置TARGET为all
    if [ -z "$TARGET" ]; then
      TARGET="all"
    fi
    
    case "$TARGET" in
      front) check_frontend_status ;;
      back) check_backend_status ;;
      all) check_frontend_status; check_backend_status ;;
      *) show_help ;;
    esac
    ;;
  *)
    show_help
    exit 1
    ;;
esac

exit 0