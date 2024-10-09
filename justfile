set shell := ["bash", "-c"]

# update all features
generate:
    cd _generator && ./run_generator.sh

# test an example feature
test: generate
    #!/bin/bash

    # Function to extract the "got:" value followed by "specified:"
    extract_got_value() {
        awk '/got:/ {got=$NF} /specified:/ && got {print got; exit}' | tail -n 1 | tr -d '\r\n'
    }

    # Run the commands, display output in real-time, and capture the "got:" value
    got_value=$(
        (cd _generator && ./test.sh basedpyright && ./test.sh typescript_eslint) 2>&1 |
        tee >(cat >&2) |
        extract_got_value
    )

    if [ -n "$got_value" ]; then
        echo "The 'got:' value is: $got_value"    

        # Update sha256 in lsp-bridge.nix with latest value        
        sed -i 's|sha256 = .*|sha256 = "'"$got_value"'";|' _generator/src_template/{{{{cookiecutter.langserver}}/lsp-bridge.nix
        echo "Updated lsp-bridge.nix with the new sha256 value: $got_value"

        # Update version in lsp-bridge.nix with today's date
        current_date=$(date +"%Y%m%d")
        sed -i "s|version = .*|version = \"$current_date\";|" _generator/src_template/{{{{cookiecutter.langserver}}/lsp-bridge.nix
        echo "Updated lsp-bridge.nix with the new version: $current_date"

        echo "Generate and test again."
        exit 1
    else
        echo "Test passed"
    fi

# update the version for release tag
update_version:
    #!/bin/bash
    file="_generator/src_template/{{{{cookiecutter.langserver}}/devcontainer-feature.json"
    
    # Read the current version
    current_version=$(jq -r '.version' "$file")
    
    # Split the version into parts
    IFS='.' read -ra version_parts <<< "$current_version"
    
    # Increment the last part
    ((version_parts[2]++))
    
    # Join the parts back together
    new_version="${version_parts[0]}.${version_parts[1]}.${version_parts[2]}"
    
    # Update the file with the new version
    jq --arg version "$new_version" '.version = $version' "$file" > temp.json && mv temp.json "$file"
    
    echo "Version updated from $current_version to $new_version"

# open a devcontainer in VSCode
devcontainer:
    p=$(printf "%s" "$PWD" | hexdump -v -e '/1 "%02x"') && code --folder-uri "vscode-remote://dev-container+${p}/workspaces/$(basename $PWD)"
