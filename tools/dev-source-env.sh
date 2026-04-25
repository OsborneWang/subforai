#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${PROJECT_ROOT}/deploy/.env"

usage() {
  cat <<'EOF'
Usage:
  tools/dev-source-env.sh print
  tools/dev-source-env.sh backend [args...]
  tools/dev-source-env.sh <command> [args...]

Examples:
  tools/dev-source-env.sh print
  tools/dev-source-env.sh backend
  tools/dev-source-env.sh go test ./backend/...
EOF
}

if [ ! -f "${ENV_FILE}" ]; then
  echo "missing ${ENV_FILE}" >&2
  exit 1
fi

if [ "${1:-}" = "" ]; then
  usage
  exit 1
fi

set -a
# shellcheck disable=SC1090
. "${ENV_FILE}"
set +a

export AUTO_SETUP="${AUTO_SETUP:-true}"
export DATA_DIR="${DATA_DIR:-${PROJECT_ROOT}/deploy/data}"
export SERVER_HOST="${SERVER_HOST:-127.0.0.1}"

# deploy/.env is written for Docker Compose. Source-mode backend startup expects
# the resolved application connection variables below.
export DATABASE_HOST="${DATABASE_HOST:-127.0.0.1}"
export DATABASE_PORT="${DATABASE_PORT:-5432}"
export DATABASE_USER="${DATABASE_USER:-${POSTGRES_USER:-sub2api}}"
export DATABASE_PASSWORD="${DATABASE_PASSWORD:-${POSTGRES_PASSWORD:-}}"
export DATABASE_DBNAME="${DATABASE_DBNAME:-${POSTGRES_DB:-sub2api}}"
export DATABASE_SSLMODE="${DATABASE_SSLMODE:-disable}"

export REDIS_HOST="${REDIS_HOST:-127.0.0.1}"
export REDIS_PORT="${REDIS_PORT:-6379}"
export REDIS_DB="${REDIS_DB:-0}"
export REDIS_ENABLE_TLS="${REDIS_ENABLE_TLS:-false}"

# Keep local builds inside writable paths.
export GOCACHE="${GOCACHE:-/tmp/subforai-go-build-cache}"

if [ "${1}" = "print" ]; then
  cat <<EOF
ENV_FILE=${ENV_FILE}
AUTO_SETUP=${AUTO_SETUP}
DATA_DIR=${DATA_DIR}
SERVER_HOST=${SERVER_HOST}
SERVER_PORT=${SERVER_PORT:-8080}
DATABASE_HOST=${DATABASE_HOST}
DATABASE_PORT=${DATABASE_PORT}
DATABASE_USER=${DATABASE_USER}
DATABASE_DBNAME=${DATABASE_DBNAME}
REDIS_HOST=${REDIS_HOST}
REDIS_PORT=${REDIS_PORT}
REDIS_DB=${REDIS_DB}
GOCACHE=${GOCACHE}
EOF
  exit 0
fi

if [ "${1}" = "backend" ]; then
  shift
  cd "${PROJECT_ROOT}/backend"
  exec go run ./cmd/server "$@"
fi

exec "$@"
