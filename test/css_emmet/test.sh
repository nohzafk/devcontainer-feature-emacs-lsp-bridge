#!/bin/bash
set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

uid="$(id -u)"
echo "Current user UID is ${uid}."
if [ "${uid}" != "1000" ]; then
    echo "Current user UID was adjusted."
fi
set +e 
vscode_uid="$(id -u vscode)"
set -e
if [ "${vscode_uid}" != "" ]; then
    echo "User vscode UID is ${vscode_uid}."
    if [ "${vscode_uid}" != "1000" ]; then
        echo "User vscode UID was adjusted."
    fi
fi
nix_uid="$(stat /nix -c "%u")"
echo "/nix UID is ${nix_uid}."

cat /etc/os-release

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "nix-env" type nix-env

langserver_binary="emmet-ls,vscode-css-language-server"

IFS=','
for item in $langserver_binary; do
    # Trim leading and trailing whitespace
    item=$(echo $item | xargs)
    # Perform the check
    check "$item installed" type $item
done

check "lsp_bridge can be started successfully" cat /tmp/lsp-bridge.log | grep successfully

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults &2>1