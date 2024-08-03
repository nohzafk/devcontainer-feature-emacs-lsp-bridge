set shell := ["bash", "-c"]

# update all features
generate:
    cd _generator && ./run_generator.sh

# test an example feature
test: generate
    #!/bin/bash

    # Function to extract the "got:" value followed by "specified:"
    extract_got_value() {
        awk '/got:/ {got=$NF} /specified:/ && got {print got; exit}' | tail -n 1
    }

    # Run the commands, display output in real-time, and capture the "got:" value
    got_value=$(
        (cd _generator && ./test.sh basedpyright && ./test.sh typescript_eslint) 2>&1 |
        tee >(cat >&2) |
        extract_got_value
    )

    if [ -n "$got_value" ]; then
        echo "The 'got:' value is: $got_value"
        sed -i "s/sha256 = .*/sha256 = $got_value/" _generator/src_template/{{cookiecutter.langserver}}/lsp-bridge.nix

        echo "Updated lsp-bridge.nix with the new sha256 value."
        echo "Generate and test again."
        exit 1
    else
        echo "Test passed"
    fi

# open a devcontainer in VSCode
devcontainer:
    p=$(printf "%s" "$PWD" | hexdump -v -e '/1 "%02x"') && code --folder-uri "vscode-remote://dev-container+${p}/workspaces/$(basename $PWD)"
