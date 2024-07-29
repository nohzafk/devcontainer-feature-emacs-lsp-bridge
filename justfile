set shell := ["bash", "-c"]

# update all features
generate:
    cd _generator && ./run_generator.sh

# test an example feature
test: generate
    cd _generator && ./test.sh basedpyright && ./test.sh typescript_eslint

# open a devcontainer in VSCode
devcontainer:
    p=$(printf "%s" "$PWD" | hexdump -v -e '/1 "%02x"') && code --folder-uri "vscode-remote://dev-container+${p}/workspaces/$(basename $PWD)"
