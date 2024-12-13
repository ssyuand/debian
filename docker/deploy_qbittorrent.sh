#!/bin/bash

# 设置变量
CONTAINER_NAME="qbittorrent"
CONFIG_DIR="$HOME/qbittorrent/config"
DOWNLOAD_DIR="$HOME/qbittorrent/downloads"
WEBUI_PORT=8080
PUID=1000
PGID=1000
IMAGE="linuxserver/qbittorrent"

# 创建配置和下载目录
echo "创建配置和下载目录..."
mkdir -p "$CONFIG_DIR" "$DOWNLOAD_DIR"

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo "Docker 未安装，请先安装 Docker。"
    exit 1
fi

# 部署容器
echo "部署 qBittorrent 容器..."
docker run -d \
    --name="$CONTAINER_NAME" \
    -e PUID="$PUID" \
    -e PGID="$PGID" \
    -e TZ="Asia/Shanghai" \
    -p "$WEBUI_PORT:8080" \
    -p 6881:6881 \
    -p 6881:6881/udp \
    -v "$CONFIG_DIR:/config" \
    -v "$DOWNLOAD_DIR:/downloads" \
    --restart unless-stopped \
    "$IMAGE"

# 删除密码字段（可选，保证使用默认密码）
if [ -f "$CONFIG_DIR/qBittorrent.conf" ]; then
    echo "移除默认密码字段..."
    sed -i '/WebUI\\Password_ha1=/d' "$CONFIG_DIR/qBittorrent.conf"
fi

# 重启容器以确保配置生效
docker restart "$CONTAINER_NAME"

# 检查是否成功运行
if [ $? -eq 0 ]; then
    echo "qBittorrent 部署成功！"
    echo "Web 界面地址: http://<服务器IP>:${WEBUI_PORT}"
    echo "默认用户名: admin"
    echo "默认密码: adminadmin"
else
    echo "qBittorrent 部署失败，请检查日志。"
    exit 1
fi
