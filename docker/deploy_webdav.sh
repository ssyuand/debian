#!/bin/bash

# 更新系统并安装 Docker 和 Docker Compose
echo "Updating system and installing Docker..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io docker-compose

# 创建 WebDAV 工作目录
WEB_DAV_DIR=~/webdav
mkdir -p "$WEB_DAV_DIR"
cd "$WEB_DAV_DIR"

# 创建 docker-compose.yml 文件
cat <<EOF > docker-compose.yml
version: '3.3'

services:
  webdav:
    image: httpd:2.4
    container_name: webdav
    environment:
      - APACHE_RUN_USER=www-data
      - APACHE_RUN_GROUP=www-data
    volumes:
      - ./data:/usr/local/apache2/htdocs                # 文件存储路径
      - ./httpd.conf:/usr/local/apache2/conf/httpd.conf # WebDAV 配置文件
    ports:
      - 8080:80                                        # 容器端口映射
    restart: unless-stopped
EOF

# 创建 WebDAV 配置文件
cat <<EOF > httpd.conf
ServerRoot "/usr/local/apache2"
Listen 80

LoadModule mpm_event_module modules/mod_mpm_event.so
LoadModule dav_module modules/mod_dav.so
LoadModule dav_fs_module modules/mod_dav_fs.so
LoadModule authn_file_module modules/mod_authn_file.so
LoadModule authz_core_module modules/mod_authz_core.so

DocumentRoot "/usr/local/apache2/htdocs"
<Directory "/usr/local/apache2/htdocs">
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>

DavLockDB "/usr/local/apache2/DavLock"

<Location />
    DAV On
    AuthType Basic
    AuthName "WebDAV Restricted Area"
    AuthUserFile /usr/local/apache2/conf/.htpasswd
    Require valid-user
</Location>
EOF

# 创建文件存储目录和用户密码文件
mkdir -p ./data
echo "Creating WebDAV user..."
WEB_DAV_USER="yourusername"
WEB_DAV_PASSWORD="yourpassword"
docker run --rm httpd:2.4 htpasswd -cb /tmp/.htpasswd "$WEB_DAV_USER" "$WEB_DAV_PASSWORD"
mv /tmp/.htpasswd ./data/.htpasswd

# 启动 WebDAV 服务
echo "Starting WebDAV service..."
docker-compose up -d

# 输出访问信息
echo "WebDAV service is now running!"
echo "Access URL: http://<your-server-ip>:8080"
echo "Username: $WEB_DAV_USER"
echo "Password: $WEB_DAV_PASSWORD"
