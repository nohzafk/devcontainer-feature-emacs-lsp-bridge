#!/bin/bash
set -eu

PYTHON_CMD="/tmp/lsp-bridge-venv/bin/python3"
LSP_BRIDGE_SCRIPT="/tmp/lsp-bridge/lsp_bridge.py"
LOG_FILE="/tmp/lsp-bridge.log"

is_process_running() {
    pgrep -f "$PYTHON_CMD.*$LSP_BRIDGE_SCRIPT" >/dev/null
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
        exit 1
    fi
else
    echo "lsp-bridge process is already running" | tee -a "$LOG_FILE"
fi
