#!/bin/bash
set -eu

PYTHON_CMD="/tmp/lsp-bridge-venv/bin/python3"
LSP_BRIDGE_SCRIPT="/tmp/lsp-bridge/lsp_bridge.py"
LOG_FILE="/tmp/lsp-bridge.log"

is_process_running() {
    if command -v pgrep >/dev/null 2>&1; then
        pgrep -f "$PYTHON_CMD.*$LSP_BRIDGE_SCRIPT" >/dev/null
    elif command -v ps >/dev/null 2>&1; then
        ps aux | grep "$PYTHON_CMD.*$LSP_BRIDGE_SCRIPT" | grep -v grep >/dev/null
    else
        # no ps under debian:latest
        apt-get -y update && apt-get -y install procps
        ps aux | grep "$PYTHON_CMD.*$LSP_BRIDGE_SCRIPT" | grep -v grep >/dev/null
    fi
}

if ! is_process_running; then
    echo "Start lsp-bridge process as user $(whoami)" | tee "$LOG_FILE"

    # Start the process in background
    $PYTHON_CMD $LSP_BRIDGE_SCRIPT >>"$LOG_FILE" 2>&1 &

    # Wait a moment for the process to start
    sleep 2

    # Check if the process is running
    if is_process_running; then
        echo "Start lsp-bridge successfully" | tee -a "$LOG_FILE"
    else
        echo "Start lsp-bridge failed" | tee -a "$LOG_FILE"
        cat "$LOG_FILE"
        exit 1
    fi
else
    echo "lsp-bridge process is already running" | tee -a "$LOG_FILE"
fi
