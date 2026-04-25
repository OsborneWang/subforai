#!/bin/sh
set -e

# Fix data directory permissions when running as root.
# Docker bind mounts may be owned by root, which would prevent the
# non-root runtime user from writing logs, config, or cache files.
if [ "$(id -u)" = "0" ]; then
    mkdir -p /app/data
    # Ignore errors for read-only mounts such as config files.
    chown -R sub2api:sub2api /app/data 2>/dev/null || true
    exec su-exec sub2api "$0" "$@"
fi

# Preserve the old behavior where entrypoint flags are forwarded to /app/sub2api.
if [ "${1#-}" != "$1" ]; then
    set -- /app/sub2api "$@"
fi

exec "$@"
