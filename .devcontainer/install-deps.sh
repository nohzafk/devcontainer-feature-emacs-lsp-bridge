#!/bin/bash

npm install -g @devcontainers/cli
npm install -g just-install
pipx install cookiecutter
pipx inject cookiecutter requests
