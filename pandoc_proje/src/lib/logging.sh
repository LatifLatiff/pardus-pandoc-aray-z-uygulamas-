#!/bin/bash

# ==============================================================================
# Loglama Sistemi
# ==============================================================================

LOG_DIR="$HOME/.cache/pandoc-frontend"
LOG_FILE="$LOG_DIR/app.log"
LAST_RUN_OUT="$LOG_DIR/last_run.out"
LAST_RUN_ERR="$LOG_DIR/last_run.err"

init_logging() {
    mkdir -p "$LOG_DIR"
    touch "$LOG_FILE"
}

log_info() {
    local msg="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] [INFO] $msg" >> "$LOG_FILE"
}

log_error() {
    local msg="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] [ERROR] $msg" >> "$LOG_FILE"
    echo "[$timestamp] [ERROR] $msg" >&2
}

get_last_log_path() {
    echo "$LOG_FILE"
}
