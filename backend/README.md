# 后端服务

## 环境管理

本项目使用miniforge3管理Python虚拟环境，所有操作都需要指定`-n python3.12`参数。

### 创建环境
```bash
conda create -n python3.12 python=3.12
```

### 激活环境
```bash
conda activate python3.12
```

### 安装依赖
```bash
conda activate python3.12
pip install -r requirements.txt
```

## 配置环境变量

复制环境变量示例文件并根据需要修改：
```bash
cp .env.example .env
```

## 启动服务

```bash
conda activate python3.12
python run.py
```