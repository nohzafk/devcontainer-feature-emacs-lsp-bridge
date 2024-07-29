#!/bin/bash

if ! command -v devcontainer; then
    npm install -g @devcontainers/cli
fi
if ! command -v just; then
    npm install -g just-install
fi
if [[ ! -f /usr/local/py-utils/venvs/cookiecutter/bin/cookiecutter ]]; then
    pipx install cookiecutter
    # pipx inject cookiecutter requests
fi
