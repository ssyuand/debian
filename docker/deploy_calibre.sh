#!/bin/bash

# 更新系統
echo "更新系統..."
sudo apt update && sudo apt upgrade -y

# 安裝 Docker 和 Docker Compose
echo "安裝 Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    sudo usermod -aG docker $USER
else
    echo "Docker 已安裝，跳過..."
fi

echo "安裝 Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo apt install -y docker-compose
else
    echo "Docker Compose 已安裝，跳過..."
fi

# 創建 Calibre-Web 所需目錄
echo "創建目錄結構..."
mkdir -p ~/calibre-web/config
mkdir -p ~/calibre-web/books

# 創建 docker-compose.yml 文件
echo "創建 docker-compose.yml..."
cat <<EOF > ~/calibre-web/docker-compose.yml
version: "3"
services:
  calibre-web:
    image: lscr.io/linuxserver/calibre-web:latest
    container_name: calibre-web
    environment:
      - PUID=1000                # 用戶ID
      - PGID=1000                # 用戶組ID
      - TZ=Asia/Shanghai         # 時區
    volumes:
      - ./config:/config         # 配置文件
      - ./books:/books           # 書籍目錄
    ports:
      - 8083:8083                # Web訪問端口
    restart: unless-stopped
EOF

# 啟動容器
echo "啟動 Calibre-Web 容器..."
cd ~/calibre-web
docker-compose up -d

# 等待容器啟動
echo "等待 Calibre-Web 容器啟動..."
sleep 10

# 配置數據庫
echo "配置數據庫..."
docker exec -it calibre-web sh -c "cd /app/calibre/bin && calibredb restore_database --really-do-it --with-library /books && chmod a+w /books/metadata.db"

echo "Calibre-Web 安裝並配置完成！"
echo "請訪問 http://<你的IP地址>:8083 配置您的 Calibre-Web。"
