#!/bin/bash

# 设置变量
BASE_DIR="$HOME/paperless-ngx"
COMPOSE_FILE="$BASE_DIR/docker-compose.yml"

# 创建目录结构
echo "创建目录结构..."
mkdir -p "$BASE_DIR/{data,media,consume,db_data}"

# 检查是否已安装 Docker 和 Docker Compose
echo "检查 Docker 和 Docker Compose..."
if ! command -v docker &> /dev/null; then
    echo "Docker 未安装，请先安装 Docker。"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose 未安装，请先安装 Docker Compose。"
    exit 1
fi

# 创建 Docker Compose 文件
echo "生成 Docker Compose 文件..."
cat <<EOF > "$COMPOSE_FILE"
version: '3.3'

services:
  paperless-ngx:
    image: ghcr.io/paperless-ngx/paperless-ngx:latest
    container_name: paperless-ngx
    restart: unless-stopped
    ports:
      - 8000:8000
    volumes:
      - ./data:/usr/src/paperless/data
      - ./media:/usr/src/paperless/media
      - ./consume:/usr/src/paperless/consume
    environment:
      PAPERLESS_REDIS: redis://redis:6379
      PAPERLESS_DBHOST: db
      PAPERLESS_DBUSER: paperless
      PAPERLESS_DBPASS: paperless
      PAPERLESS_DBNAME: paperless
    depends_on:
      - db
      - redis

  db:
    image: postgres:14
    container_name: paperless-ngx-db
    restart: unless-stopped
    volumes:
      - ./db_data:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: paperless
      POSTGRES_PASSWORD: paperless
      POSTGRES_DB: paperless

  redis:
    image: redis:alpine
    container_name: paperless-ngx-redis
    restart: unless-stopped
EOF

# 启动服务
echo "启动 Docker Compose 服务..."
cd "$BASE_DIR" || exit
docker-compose up -d

# 检查服务状态
if [ $? -eq 0 ]; then
    echo "Paperless-ngx 部署成功！"
    echo "访问地址: http://<服务器IP>:8000"
else
    echo "Paperless-ngx 部署失败，请检查日志。"
fi
