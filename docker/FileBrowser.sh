#!/bin/bash

# === 1. 安裝 Docker（如果沒裝）===
if ! command -v docker &> /dev/null
then
    echo "Docker 未安裝，開始安裝 Docker..."
    apt update
    apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt update
    apt install -y docker-ce docker-ce-cli containerd.io
else
    echo "Docker 已安裝，跳過此步驟。"
fi

# === 2. 建立 FileBrowser 資料夾（如果尚未存在）===
mkdir -p /srv/filebrowser/files
mkdir -p /srv/filebrowser/config

# === 3. 啟動 FileBrowser 容器 ===
docker run -d \
  --name filebrowser \
  -v /srv/filebrowser/files:/srv \
  -v /srv/filebrowser/config:/config \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  -p 8080:80 \
  filebrowser/filebrowser:s6

echo "FileBrowser 已啟動！"
echo "請在瀏覽器中開啟：http://你的伺服器IP:8080"
echo "預設帳號：admin"
echo "預設密碼：admin"