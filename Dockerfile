FROM python:3.9-slim

WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# 复制项目文件
COPY . /app

# 安装项目依赖
RUN pip install --no-cache-dir -e .

# 下载模型
RUN python -c "from huggingface_hub import snapshot_download; snapshot_download('microsoft/VibeVoice-Realtime-0.5B', local_dir='/app/models/VibeVoice-Realtime-0.5B')"

# 设置环境变量（默认值）
ENV MODEL_PATH="/app/models/VibeVoice-Realtime-0.5B"
ENV MODEL_DEVICE="cpu"
ENV PORT=8080

# 暴露端口
EXPOSE $PORT

# 启动命令
CMD python demo/vibevoice_realtime_demo.py --port $PORT --model_path $MODEL_PATH --device $MODEL_DEVICE
