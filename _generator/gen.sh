#!/bin/bash

/usr/local/py-utils/venvs/cookiecutter/bin/python generator.py

cd ../
devcontainer features test \
  --remote-user vscode \
  --skip-scenarios \
  --base-image mcr.microsoft.com/devcontainers/base:ubuntu \
  .