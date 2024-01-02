#!/bin/bash
set -eu

# Check if the SSHD configuration file exists or the SSH server process is running
# if [ -f /etc/ssh/sshd_config ] || pgrep -x "sshd" > /dev/null; then
#     echo "SSHD feature is installed."
# else
#     echo "Error: SSHD feature is not installed. Please install the SSHD feature and try again."
#     exit 1
# fi

PYTHON_CMD="/tmp/lsp-bridge-venv/bin/python3"
LSP_BRIDGE_SCRIPT="/tmp/lsp-bridge/lsp_bridge.py"
LOG_FILE="/tmp/lsp-bridge.log"

if ! pidof $PYTHON_CMD > /dev/null 2>&1; then
    echo -e "Start lsp-bridge process as user $(whoami)" | tee > $LOG_FILE
    start_ok=false
    nohup $PYTHON_CMD $LSP_BRIDGE_SCRIPT >> $LOG_FILE 2>&1 &
    if [ "$?" = "0" ]; then
        start_ok=true
    fi      
    if [ "${start_ok}" = "false" ]; then
        echo -e 'Failed to start lsp-bridge' | tee >> $LOG_FILE
    else
        echo -e 'Start lsp-bridge process successfully' | tee >> $LOG_FILE
    fi
fi
disown