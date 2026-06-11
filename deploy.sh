#!/usr/bin/env bash
#
# 部署要点（2026-04 更新）
# ----------------------------------------------------------
# 必填环境变量:
#   SERVER_IP        目标服务器 IP
#   SERVER_USER      默认 root
# 认证二选一:
#   SSH_KEY=/path/to/key  (推荐，公钥已放到服务器 ~/.ssh/authorized_keys)
#   SERVER_PASS=...       (fallback，需安装 sshpass)
#
# 生产切换到 Postgres（推荐）:
#   在服务器 shared/server.env 中设置:
#     DB_TYPE=postgres
#     DB_HOST=... DB_PORT=5432 DB_USERNAME=... DB_PASSWORD=... DB_DATABASE=conference_app
#   上线前执行一次 schema 初始化（第一次部署可临时 DB_SYNCHRONIZE=true；
#   之后生产环境会强制忽略该开关，必须通过 TypeORM 迁移升级表结构）。
#
# 备份策略 (sqlite 或 postgres):
#   sqlite:  在服务器 crontab 加:
#     0 3 * * * cp /opt/yuanshimeetingnotice/data/conference.db /opt/yuanshimeetingnotice/backups/conference-$(date +\%F).db
#   postgres: 用 pg_dump + cron:
#     0 3 * * * pg_dump -U $USER conference_app | gzip > /opt/yuanshimeetingnotice/backups/db-$(date +\%F).sql.gz
#   保留 14 天:  find /opt/yuanshimeetingnotice/backups -name '*.db' -mtime +14 -delete
#
# HTTPS / TLS (nginx 层):
#   1) 先用本脚本部署完成，确认 http://$SERVER_IP:$ADMIN_PORT 可访问。
#   2) DNS 解析一个域名到 $SERVER_IP。
#   3) 在服务器安装 certbot:
#        apt install certbot python3-certbot-nginx
#        certbot --nginx -d your-domain.com --non-interactive --agree-tos -m ops@your-domain.com
#      certbot 会自动改 nginx 配置监听 443 + 自动续签 (cron)。
#   4) 手工编辑 /www/server/panel/vhost/nginx/yuanshimeetingnotice.conf 将 80 端口 301 到 443，
#      或使用 certbot 的 --redirect。
#   5) 配置环境变量让后端信任反代协议: server.env 加上
#        CORS_ORIGIN=https://your-domain.com
#      （生产必须是 https，且不可为 *）
#
# 回滚:
#   /opt/yuanshimeetingnotice/run/server.pid 为当前进程，kill 后手动重启旧版本 dist 即可。
#
# 本次升级需要的数据库 schema 变更 (2026-04, 生产要手工执行):
#   SQLite:
#     ALTER TABLE users ADD COLUMN token_version INTEGER NOT NULL DEFAULT 0;
#     ALTER TABLE users ADD COLUMN must_change_password INTEGER NOT NULL DEFAULT 0;
#   PostgreSQL:
#     ALTER TABLE users ADD COLUMN token_version INTEGER NOT NULL DEFAULT 0;
#     ALTER TABLE users ADD COLUMN must_change_password BOOLEAN NOT NULL DEFAULT false;
# ----------------------------------------------------------

set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVER_IP="${SERVER_IP:-}"
SERVER_USER="${SERVER_USER:-root}"
SERVER_PASS="${SERVER_PASS:-}"
SSH_KEY="${SSH_KEY:-}"
SSH_PORT="${SSH_PORT:-22}"

APP_NAME="${APP_NAME:-yuanshimeetingnotice}"
REMOTE_BASE_DIR="${REMOTE_BASE_DIR:-/opt/${APP_NAME}}"
REMOTE_ADMIN_DIR="${REMOTE_BASE_DIR}/admin"
REMOTE_SERVER_DIR="${REMOTE_BASE_DIR}/server"
REMOTE_SHARED_DIR="${REMOTE_BASE_DIR}/shared"
REMOTE_RUN_DIR="${REMOTE_BASE_DIR}/run"
REMOTE_LOG_DIR="${REMOTE_BASE_DIR}/logs"
REMOTE_DATA_DIR="${REMOTE_BASE_DIR}/data"
REMOTE_ADMIN_BUILD_LOG="${REMOTE_LOG_DIR}/admin-build.log"
REMOTE_SERVER_BUILD_LOG="${REMOTE_LOG_DIR}/server-build.log"

BACKEND_PORT="${BACKEND_PORT:-}"
ADMIN_PORT="${ADMIN_PORT:-}"
BACKEND_PORT_BASE="${BACKEND_PORT_BASE:-3100}"
ADMIN_PORT_BASE="${ADMIN_PORT_BASE:-3200}"

# nginx server_name (e.g. admin.apscvir.top). Default "_" matches any host.
NGINX_SERVER_NAME="${NGINX_SERVER_NAME:-_}"
# Override CORS origin (e.g. https://admin.apscvir.top). Empty => derived from IP:ADMIN_PORT.
CORS_ORIGIN="${CORS_ORIGIN:-}"

SSH_OPTS=(
  -p "$SSH_PORT"
  -o ConnectTimeout=10
  -o ServerAliveInterval=15
  -o ServerAliveCountMax=4
  -o StrictHostKeyChecking=no
)

if [[ -n "$SSH_KEY" ]]; then
  [[ -f "$SSH_KEY" ]] || die "SSH_KEY 指向的文件不存在: $SSH_KEY"
  SSH_OPTS+=(
    -i "$SSH_KEY"
    -o IdentitiesOnly=yes
    -o PreferredAuthentications=publickey
    -o PubkeyAuthentication=yes
  )
else
  SSH_OPTS+=(
    -o PreferredAuthentications=password
    -o PubkeyAuthentication=no
  )
fi

log() {
  printf '[deploy] %s\n' "$*"
}

die() {
  printf '[deploy] %s\n' "$*" >&2
  exit 1
}

require_bin() {
  command -v "$1" >/dev/null 2>&1 || die "缺少命令: $1"
}

require_env() {
  local key="$1"
  [[ -n "${!key:-}" ]] || die "缺少环境变量: ${key}"
}

ssh_cmd() {
  local status=0
  local attempt
  local max_attempts=3

  for attempt in $(seq 1 "$max_attempts"); do
    if [[ -n "$SSH_KEY" ]]; then
      if ssh "${SSH_OPTS[@]}" "${SERVER_USER}@${SERVER_IP}" "$@"; then
        return 0
      fi
    else
      if sshpass -p "$SERVER_PASS" ssh "${SSH_OPTS[@]}" "${SERVER_USER}@${SERVER_IP}" "$@"; then
        return 0
      fi
    fi

    status=$?
    if [[ "$status" -ne 255 || "$attempt" -eq "$max_attempts" ]]; then
      return "$status"
    fi

    log "SSH 连接异常，准备重试 (${attempt}/${max_attempts})"
    sleep 2
  done

  return "$status"
}

tail_remote_server_log() {
  log "输出远端后端日志尾部"
  ssh_cmd "tail -n 80 '${REMOTE_LOG_DIR}/server.log' 2>/dev/null || true"
}

tail_remote_build_logs() {
  log "输出远端 admin 构建日志尾部"
  ssh_cmd "tail -n 80 '${REMOTE_ADMIN_BUILD_LOG}' 2>/dev/null || true"
  log "输出远端 server 构建日志尾部"
  ssh_cmd "tail -n 80 '${REMOTE_SERVER_BUILD_LOG}' 2>/dev/null || true"
}

pick_free_port() {
  local start_port="$1"
  ssh_cmd "python3 - <<'PY'
import socket

for port in range(${start_port}, ${start_port} + 200):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        try:
            sock.bind(('0.0.0.0', port))
        except OSError:
            continue
        print(port)
        break
else:
    raise SystemExit('No free port found')
PY"
}

print_port_report() {
  log "服务器当前监听端口"
  ssh_cmd "ss -lntup"
}

prepare_remote_dirs() {
  ssh_cmd "mkdir -p \
    '${REMOTE_ADMIN_DIR}' \
    '${REMOTE_SERVER_DIR}' \
    '${REMOTE_SHARED_DIR}' \
    '${REMOTE_RUN_DIR}' \
    '${REMOTE_LOG_DIR}' \
    '${REMOTE_DATA_DIR}'"
}

upload_sources() {
  COPYFILE_DISABLE=1 tar \
    --exclude='.git' \
    --exclude='admin/node_modules' \
    --exclude='admin/dist' \
    --exclude='server/node_modules' \
    --exclude='server/dist' \
    --exclude='server/conference.db' \
    --exclude='conference_app' \
    -czf - \
    -C "$ROOT_DIR" \
    admin \
    server \
    deploy.sh \
    | ssh_cmd "cat > '${REMOTE_BASE_DIR}/src.tgz'"

  ssh_cmd "tar -xzf '${REMOTE_BASE_DIR}/src.tgz' -C '${REMOTE_BASE_DIR}' && rm -f '${REMOTE_BASE_DIR}/src.tgz'"
}

upload_apscvir_content_seed() {
  local local_content="${ROOT_DIR}/conference_app/assets/apscvir2026"
  if [[ ! -d "$local_content" ]]; then
    log "本地无 APSCVIR 内容资源，跳过内容种子上传"
    return 0
  fi

  log "上传 APSCVIR 内容种子到后端 uploads/apscvir2026"
  COPYFILE_DISABLE=1 tar -czf - -C "$local_content" . \
    | ssh_cmd "mkdir -p '${REMOTE_SERVER_DIR}/uploads/apscvir2026' && tar -xzf - -C '${REMOTE_SERVER_DIR}/uploads/apscvir2026'"
}

load_local_env_defaults() {
  # 当 shell 没显式 export 时，从本地 server/.env 读取常用配置兜底，
  # 防止部署把生产 SMTP / JPUSH 等敏感字段写空。
  local env_file="${ROOT_DIR}/server/.env"
  [[ -f "$env_file" ]] || return 0
  local key val
  for key in SMTP_HOST SMTP_PORT SMTP_USER SMTP_PASS SMTP_FROM SMTP_FROM_NAME \
             JPUSH_APP_KEY JPUSH_MASTER_SECRET JWT_SECRET JWT_EXPIRES_IN \
             APP_DOWNLOAD_URL AUTH_SIMULATE_VERIFICATION AUTH_SIMULATED_CODE \
             SCHEDULE_TIMEZONE REDIS_HOST REDIS_PORT; do
    [[ -n "${!key:-}" ]] && continue
    val="$(grep -E "^${key}=" "$env_file" | head -n 1 | cut -d= -f2-)"
    val="${val#\"}"; val="${val%\"}"
    val="${val#\'}"; val="${val%\'}"
    [[ -n "$val" ]] && export "${key}=${val}"
  done
}

write_server_env() {
  load_local_env_defaults
  local jwt_secret
  jwt_secret="${JWT_SECRET:-deploy-change-this-secret}"

  ssh_cmd "cat > '${REMOTE_SHARED_DIR}/server.env' <<EOF
NODE_ENV=production
PORT=${BACKEND_PORT}
API_PREFIX=api/v1
DB_TYPE=sqlite
DB_DATABASE=${REMOTE_DATA_DIR}/conference.db
DB_SYNCHRONIZE=false
JWT_SECRET=${jwt_secret}
JWT_EXPIRES_IN=${JWT_EXPIRES_IN:-7d}
REDIS_HOST=${REDIS_HOST:-127.0.0.1}
REDIS_PORT=${REDIS_PORT:-6379}
SMTP_HOST=${SMTP_HOST:-}
SMTP_PORT=${SMTP_PORT:-465}
SMTP_USER=${SMTP_USER:-}
SMTP_PASS=${SMTP_PASS:-}
SMTP_FROM=${SMTP_FROM:-noreply@example.com}
SMTP_FROM_NAME=${SMTP_FROM_NAME:-APSCVIR}
JPUSH_APP_KEY=${JPUSH_APP_KEY:-}
JPUSH_MASTER_SECRET=${JPUSH_MASTER_SECRET:-}
APP_DOWNLOAD_URL=${APP_DOWNLOAD_URL:-https://app.apscvir.top}
AUTH_SIMULATE_VERIFICATION=${AUTH_SIMULATE_VERIFICATION:-false}
AUTH_SIMULATED_CODE=${AUTH_SIMULATED_CODE:-0000}
SCHEDULE_TIMEZONE=${SCHEDULE_TIMEZONE:-Asia/Shanghai}
CORS_ORIGIN=${CORS_ORIGIN:-http://${SERVER_IP}:${ADMIN_PORT}}
APSCVIR_CONTENT_DIR=${REMOTE_SERVER_DIR}/uploads/apscvir2026
EOF"
}

# 首次部署时把本地已建好 schema 的 sqlite 库作为初始数据库上传。
# 生产 synchronize=false 不会自动建表，缺少该步骤后端启动会因无表而崩溃。
# 仅当远端尚无数据库文件时上传，避免覆盖线上数据。
seed_initial_db() {
  local local_db="${ROOT_DIR}/server/conference.db"
  if [[ ! -f "$local_db" ]]; then
    log "本地无 server/conference.db，跳过初始数据库注入"
    return 0
  fi
  if ssh_cmd "test -s '${REMOTE_DATA_DIR}/conference.db'"; then
    log "远端已存在数据库，保留线上数据，跳过初始库上传"
    return 0
  fi
  log "上传初始 sqlite 数据库到 ${REMOTE_DATA_DIR}/conference.db"
  ssh_cmd "cat > '${REMOTE_DATA_DIR}/conference.db'" < "$local_db"
}

build_remote() {
  log "远端安装依赖并构建 admin"
  if ! ssh_cmd "cd '${REMOTE_ADMIN_DIR}' && : > '${REMOTE_ADMIN_BUILD_LOG}' && env NPM_CONFIG_REGISTRY=https://registry.npmjs.org/ NPM_CONFIG_REPLACE_REGISTRY_HOST=never NPM_CONFIG_FETCH_TIMEOUT=300000 NPM_CONFIG_FETCH_RETRIES=5 NPM_CONFIG_FETCH_RETRY_MINTIMEOUT=20000 NPM_CONFIG_FETCH_RETRY_MAXTIMEOUT=120000 npm ci --no-audit --no-fund >> '${REMOTE_ADMIN_BUILD_LOG}' 2>&1 && VITE_API_URL=/api/v1 npm run build >> '${REMOTE_ADMIN_BUILD_LOG}' 2>&1 && test -f '${REMOTE_ADMIN_DIR}/dist/index.html'"
  then
    tail_remote_build_logs
    die 'admin 远端构建失败'
  fi

  log "远端安装依赖并构建 server"
  if ! ssh_cmd "cd '${REMOTE_SERVER_DIR}' && : > '${REMOTE_SERVER_BUILD_LOG}' && env NPM_CONFIG_REGISTRY=https://registry.npmjs.org/ NPM_CONFIG_REPLACE_REGISTRY_HOST=never NPM_CONFIG_FETCH_TIMEOUT=300000 NPM_CONFIG_FETCH_RETRIES=5 NPM_CONFIG_FETCH_RETRY_MINTIMEOUT=20000 NPM_CONFIG_FETCH_RETRY_MAXTIMEOUT=120000 npm ci --no-audit --no-fund >> '${REMOTE_SERVER_BUILD_LOG}' 2>&1 && npm run build >> '${REMOTE_SERVER_BUILD_LOG}' 2>&1 && test -f '${REMOTE_SERVER_DIR}/dist/main.js'"
  then
    tail_remote_build_logs
    die 'server 远端构建失败'
  fi
}

install_nginx_site() {
  local nginx_conf
  local tls_available=false
  nginx_conf="$(mktemp -t "${APP_NAME}.nginx.XXXXXX")"

  if [[ "$NGINX_SERVER_NAME" != "_" ]] && ssh_cmd "test -s '/etc/letsencrypt/live/${NGINX_SERVER_NAME}/fullchain.pem' && test -s '/etc/letsencrypt/live/${NGINX_SERVER_NAME}/privkey.pem' && test -s /etc/letsencrypt/options-ssl-nginx.conf && test -s /etc/letsencrypt/ssl-dhparams.pem"; then
    tls_available=true
  fi

  if [[ "$tls_available" == "true" ]]; then
    cat > "$nginx_conf" <<EOF
server {
    listen ${ADMIN_PORT};
    listen [::]:${ADMIN_PORT};
    server_name ${NGINX_SERVER_NAME};

    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name ${NGINX_SERVER_NAME};

    ssl_certificate /etc/letsencrypt/live/${NGINX_SERVER_NAME}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${NGINX_SERVER_NAME}/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    root ${REMOTE_ADMIN_DIR}/dist;
    index index.html;
    client_max_body_size 50m;

    location ^~ /api/ {
        proxy_pass http://127.0.0.1:${BACKEND_PORT};
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location ^~ /uploads/ {
        proxy_pass http://127.0.0.1:${BACKEND_PORT};
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location ^~ /assets/home-banners/ {
        proxy_pass http://127.0.0.1:${BACKEND_PORT};
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
EOF
  else
    cat > "$nginx_conf" <<EOF
server {
    listen ${ADMIN_PORT};
    listen [::]:${ADMIN_PORT};
    server_name ${NGINX_SERVER_NAME};

    root ${REMOTE_ADMIN_DIR}/dist;
    index index.html;
    client_max_body_size 50m;

    location ^~ /api/ {
        proxy_pass http://127.0.0.1:${BACKEND_PORT};
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location ^~ /uploads/ {
        proxy_pass http://127.0.0.1:${BACKEND_PORT};
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location ^~ /assets/home-banners/ {
        proxy_pass http://127.0.0.1:${BACKEND_PORT};
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
EOF
  fi

  cat "$nginx_conf" | ssh_cmd "cat > '/tmp/${APP_NAME}.nginx.conf'"
  rm -f "$nginx_conf"

  # 宝塔面板: 放到 vhost 目录; 系统 nginx (apt): 放到 conf.d 并停用默认站点。
  ssh_cmd "set -e
if [ -d /www/server/panel/vhost/nginx ]; then
  cp '/tmp/${APP_NAME}.nginx.conf' '/www/server/panel/vhost/nginx/${APP_NAME}.conf'
else
  mkdir -p /etc/nginx/conf.d
  cp '/tmp/${APP_NAME}.nginx.conf' '/etc/nginx/conf.d/${APP_NAME}.conf'
  rm -f /etc/nginx/sites-enabled/default
fi
rm -f '/tmp/${APP_NAME}.nginx.conf'

if [ -x /www/server/nginx/sbin/nginx ] && [ -f /www/server/nginx/conf/nginx.conf ]; then
  /www/server/nginx/sbin/nginx -t -c /www/server/nginx/conf/nginx.conf
  /www/server/nginx/sbin/nginx -s reload -c /www/server/nginx/conf/nginx.conf
else
  nginx -t
  if systemctl is-active --quiet nginx; then
    systemctl reload nginx
  else
    nginx -s reload
  fi
fi"
}

open_admin_port() {
  ssh_cmd "if command -v ufw >/dev/null 2>&1 && ufw status | grep -q 'Status: active'; then
  ufw allow '${ADMIN_PORT}/tcp'
  if [ '${NGINX_SERVER_NAME}' != '_' ] && [ -s '/etc/letsencrypt/live/${NGINX_SERVER_NAME}/fullchain.pem' ]; then
    ufw allow '443/tcp'
  fi
fi"
}

restart_server() {
  log "重启后端服务"
  ssh_cmd "cat > '${REMOTE_RUN_DIR}/start-server.py' <<'PY'
import os
from pathlib import Path

base = Path('${REMOTE_BASE_DIR}')
env_file = base / 'shared' / 'server.env'
server_dir = base / 'server'

extra_env = {}
for raw_line in env_file.read_text().splitlines():
    line = raw_line.strip()
    if not line or line.startswith('#') or '=' not in line:
        continue
    key, value = line.split('=', 1)
    extra_env[key] = value

os.environ.update(extra_env)
os.chdir(server_dir)
os.execvp('node', ['node', 'dist/main'])
PY
chmod 755 '${REMOTE_RUN_DIR}/start-server.py'

cat > '/etc/systemd/system/${APP_NAME}.service' <<EOF
[Unit]
Description=${APP_NAME} API
After=network.target nginx.service

[Service]
Type=simple
WorkingDirectory=${REMOTE_SERVER_DIR}
ExecStart=/usr/bin/python3 ${REMOTE_RUN_DIR}/start-server.py
Restart=always
RestartSec=5
StandardOutput=append:${REMOTE_LOG_DIR}/server.log
StandardError=append:${REMOTE_LOG_DIR}/server.log

[Install]
WantedBy=multi-user.target
EOF

old_pid=''
if [ -f '${REMOTE_RUN_DIR}/server.pid' ]; then
  old_pid=\$(cat '${REMOTE_RUN_DIR}/server.pid' 2>/dev/null || true)
fi

systemctl daemon-reload
systemctl enable '${APP_NAME}.service'
systemctl restart '${APP_NAME}.service'
sleep 5
systemctl is-active --quiet '${APP_NAME}.service'
PID=\$(systemctl show -p MainPID --value '${APP_NAME}.service')
echo \"\$PID\" > '${REMOTE_RUN_DIR}/server.pid'
if [ -n \"\$old_pid\" ] && [ \"\$old_pid\" != \"\$PID\" ]; then
  kill \"\$old_pid\" 2>/dev/null || true
fi
kill -0 \"\$PID\""
}

verify_remote() {
  log "校验后端与 nginx"
  if ! ssh_cmd "set -e
    sleep 3
    curl -fIsS --max-time 8 'http://127.0.0.1:${BACKEND_PORT}/api/docs' >/dev/null
    curl -fIsS --max-time 8 'http://127.0.0.1:${ADMIN_PORT}/' >/dev/null
    if [ '${NGINX_SERVER_NAME}' != '_' ] && [ -s '/etc/letsencrypt/live/${NGINX_SERVER_NAME}/fullchain.pem' ]; then
      curl -fsS --max-time 8 --resolve '${NGINX_SERVER_NAME}:443:127.0.0.1' 'https://${NGINX_SERVER_NAME}/api/v1/health' >/dev/null
    fi"
  then
    tail_remote_server_log
    die '远端服务校验失败'
  fi
}

main() {
  require_bin tar
  require_bin ssh

  require_env SERVER_IP
  if [[ -z "$SSH_KEY" ]]; then
    require_bin sshpass
    require_env SERVER_PASS
  fi

  print_port_report

  if [[ -z "$BACKEND_PORT" ]]; then
    BACKEND_PORT="$(pick_free_port "$BACKEND_PORT_BASE")"
  fi
  if [[ -z "$ADMIN_PORT" ]]; then
    ADMIN_PORT="$(pick_free_port "$ADMIN_PORT_BASE")"
  fi

  log "选定后端端口: ${BACKEND_PORT}"
  log "选定管理端口: ${ADMIN_PORT}"

  prepare_remote_dirs
  upload_sources
  upload_apscvir_content_seed
  write_server_env
  build_remote
  seed_initial_db
  install_nginx_site
  open_admin_port
  restart_server
  verify_remote

  log "部署完成"
  log "管理端: http://${SERVER_IP}:${ADMIN_PORT}"
  log "接口文档: http://${SERVER_IP}:${ADMIN_PORT}/api/docs"
  log "后端日志: ${REMOTE_LOG_DIR}/server.log"
}

main "$@"
