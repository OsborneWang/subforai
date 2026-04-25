#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
COMPOSE_ARGS=(-f docker-compose.local.yml -f docker-compose.local-build.yml)
BACKUP_ROOT="${SCRIPT_DIR}/backups"
APP_SERVICE="subforai"
LEGACY_FILES=(
  "DATAMANAGEMENTD_CN.md"
  "DOCKER.md"
  "Dockerfile"
  "Makefile"
  "README.md"
  "build_image.sh"
  "docker-compose.dev.yml"
  "docker-compose.standalone.yml"
  "docker-compose.yml"
  "docker-deploy.sh"
  "install-datamanagementd.sh"
  "install.sh"
  "sub2api-datamanagementd.service"
  "sub2api.service"
)

usage() {
  cat <<'EOF'
Usage:
  ./appctl.sh up            Start or recreate the full stack from local code
  ./appctl.sh build         Build the local app image only
  ./appctl.sh deploy        Rebuild and restart the stack from local code
  ./appctl.sh upgrade       Backup first, then rebuild and restart the stack
  ./appctl.sh restart       Restart only the app container
  ./appctl.sh stop          Stop the stack without deleting data
  ./appctl.sh down          Alias of stop
  ./appctl.sh logs          Follow app logs
  ./appctl.sh ps            Show container status
  ./appctl.sh backup        Create a timestamped backup under deploy/backups
  ./appctl.sh tidy          Remove legacy deploy files that this server does not use
  ./appctl.sh pull          Sync to origin/main, then re-apply local cleanup
  ./appctl.sh pull-deploy   Sync latest code, re-apply cleanup, then deploy
  ./appctl.sh doctor        Check local prerequisites and key files
  ./appctl.sh help          Show this help

Notes:
  - This script always uses docker-compose.local.yml plus
    docker-compose.local-build.yml.
  - Data directories are preserved:
    deploy/data
    deploy/postgres_data
    deploy/redis_data
  - Do not use "down -v" unless you intentionally want to destroy data.
EOF
}

log() {
  printf '[appctl] %s\n' "$*"
}

die() {
  printf '[appctl] ERROR: %s\n' "$*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "missing command: $1"
}

repo_user_cmd() {
  if [ "$(id -u)" -eq 0 ] && [ -n "${SUDO_USER:-}" ]; then
    sudo -H -u "${SUDO_USER}" "$@"
  else
    "$@"
  fi
}

git_repo() {
  repo_user_cmd git -C "${PROJECT_ROOT}" "$@"
}

compose() {
  (cd "${SCRIPT_DIR}" && docker compose "${COMPOSE_ARGS[@]}" "$@")
}

ensure_layout() {
  mkdir -p "${SCRIPT_DIR}/data" "${SCRIPT_DIR}/postgres_data" "${SCRIPT_DIR}/redis_data" "${BACKUP_ROOT}"
  [ -f "${SCRIPT_DIR}/.env" ] || die "missing ${SCRIPT_DIR}/.env"
  [ -f "${SCRIPT_DIR}/docker-compose.local.yml" ] || die "missing docker-compose.local.yml"
  [ -f "${SCRIPT_DIR}/docker-compose.local-build.yml" ] || die "missing docker-compose.local-build.yml"
}

ensure_gitignore() {
  local line="backups/"
  local gitignore="${SCRIPT_DIR}/.gitignore"
  if [ ! -f "${gitignore}" ] || ! grep -qxF "${line}" "${gitignore}"; then
    printf '\n# Local operation artifacts\n%s\n' "${line}" >> "${gitignore}"
  fi
}

tidy_workspace() {
  local file
  mkdir -p "${BACKUP_ROOT}"

  if [ -f "${SCRIPT_DIR}/.env.bak" ]; then
    mv -f "${SCRIPT_DIR}/.env.bak" "${BACKUP_ROOT}/.env.bak"
  fi

  for file in "${LEGACY_FILES[@]}"; do
    rm -f "${SCRIPT_DIR}/${file}"
  done

  ensure_gitignore
  log "deploy directory cleaned to the local-build minimal set"
}

is_service_running() {
  local service="$1"
  local output
  output="$(compose ps --status running --services "${service}" 2>/dev/null || true)"
  [ "${output}" = "${service}" ]
}

backup() {
  local ts target
  ts="$(date -u +%Y%m%dT%H%M%SZ)"
  target="${BACKUP_ROOT}/${ts}"

  require_cmd docker
  require_cmd tar
  ensure_layout

  mkdir -p "${target}"
  log "creating backup in ${target}"

  cp "${SCRIPT_DIR}/.env" "${target}/.env"

  if [ -d "${SCRIPT_DIR}/data" ]; then
    tar -C "${SCRIPT_DIR}" -czf "${target}/app-data.tar.gz" data
  fi

  if is_service_running postgres; then
    log "postgres is running, creating logical dump"
    compose exec -T postgres sh -lc \
      'PGPASSWORD="$POSTGRES_PASSWORD" pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB"' \
      > "${target}/postgres.sql"
  elif [ -d "${SCRIPT_DIR}/postgres_data" ]; then
    log "postgres is not running, archiving raw postgres_data directory"
    tar -C "${SCRIPT_DIR}" -czf "${target}/postgres_data.tar.gz" postgres_data
  fi

  if is_service_running redis; then
    log "redis is running, forcing SAVE before archive"
    compose exec -T redis sh -lc 'redis-cli ${REDIS_PASSWORD:+-a "$REDIS_PASSWORD"} SAVE' >/dev/null
  fi

  if [ -d "${SCRIPT_DIR}/redis_data" ]; then
    tar -C "${SCRIPT_DIR}" -czf "${target}/redis_data.tar.gz" redis_data
  fi

  cat > "${target}/README.txt" <<EOF
Backup created at: ${ts}
Project root: ${PROJECT_ROOT}

Files:
- .env
- app-data.tar.gz
- postgres.sql or postgres_data.tar.gz
- redis_data.tar.gz

Restore strategy:
1. Stop services with ./appctl.sh stop
2. Restore .env if needed
3. Restore data/ and redis_data/ from tarballs
4. For PostgreSQL, prefer restoring postgres.sql into a fresh database
5. Start services with ./appctl.sh up
EOF

  log "backup completed: ${target}"
}

sync_latest() {
  require_cmd git
  log "syncing latest code from origin/main"
  git_repo fetch origin
  git_repo reset --hard origin/main
  tidy_workspace
}

doctor() {
  require_cmd docker
  require_cmd git
  ensure_layout
  ensure_gitignore
  log "project root: ${PROJECT_ROOT}"
  log "compose files: docker-compose.local.yml + docker-compose.local-build.yml"
  git_repo status --short --branch || true
  compose config >/dev/null
  log "docker compose config: OK"
}

do_up() {
  require_cmd docker
  ensure_layout
  compose up -d --build --remove-orphans
}

do_build() {
  require_cmd docker
  ensure_layout
  compose build "${APP_SERVICE}"
}

do_restart() {
  require_cmd docker
  ensure_layout
  compose restart "${APP_SERVICE}"
}

do_stop() {
  require_cmd docker
  ensure_layout
  compose down
}

do_logs() {
  require_cmd docker
  ensure_layout
  compose logs -f "${APP_SERVICE}"
}

do_ps() {
  require_cmd docker
  ensure_layout
  compose ps
}

cmd="${1:-help}"

case "${cmd}" in
  up)
    do_up
    ;;
  build)
    do_build
    ;;
  deploy)
    do_up
    ;;
  upgrade)
    backup
    do_up
    ;;
  restart)
    do_restart
    ;;
  stop|down)
    do_stop
    ;;
  logs)
    do_logs
    ;;
  ps|status)
    do_ps
    ;;
  backup)
    backup
    ;;
  tidy)
    tidy_workspace
    ;;
  pull)
    sync_latest
    ;;
  pull-deploy)
    sync_latest
    do_up
    ;;
  doctor)
    doctor
    ;;
  help|-h|--help)
    usage
    ;;
  *)
    usage
    die "unknown command: ${cmd}"
    ;;
esac
