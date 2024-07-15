# Dev Container Features: emacs-lsp-bridge

This repository provides automation to generate devcontainer features for every language server supported by [lsp-bridge](https://github.com/manateelazycat/lsp-bridge). It uses [nix packages](https://search.nixos.org/packages) to install the language server and lsp-bridge environment inside the container.

![Emacs lsp-bridge showing auto-completion menu when opeing a file in container](https://github.com/nohzafk/devcontainer-feature-emacs-lsp-bridge/blob/main/Screenshot.jpeg?raw=true)

# Available Features
You can find all available features in the [Packages](https://github.com/nohzafk?tab=packages&repo_name=devcontainer-feature-emacs-lsp-bridge) section.

# Connect lsp-bridge to Container
Here is how you can set up [lsp-bridge](https://github.com/manateelazycat/lsp-bridge) to connect to the container and open a file in Emacs to start the auto-completion.

## Setup devcontainer
Add a `.devcontainer/devcontainer.json` to your project. Below is an example configuration:

```json
// For format details, see https://aka.ms/devcontainer.json. For config options, see the
// README at: https://github.com/devcontainers/templates/tree/main/src/typescript-node
{
	"name": "Node.js & TypeScript",
    // Your base image
	"image": "mcr.microsoft.com/devcontainers/typescript-node:1-20-bullseye",
    // Features to add to the dev container. More info: https://containers.dev/features.
	"features": {
		"ghcr.io/nohzafk/devcontainer-feature-emacs-lsp-bridge/typescript_eslint:latest": {}
	},
	"forwardPorts": [
        9997,
        9998,
        9999
    ],
    // More info: https://aka.ms/dev-containers-non-root.
	"remoteUser": "root"
}
```

In this configuration, you need to add the `features`, `forwardPorts`, and `remoteUser` fields.


### Features
Select the language server you want to use in the `features` section. For example:

```json
"ghcr.io/nohzafk/devcontainer-feature-emacs-lsp-bridge/typescript_eslint:latest": {}
```

You can find all available features in the [Packages](https://github.com/nohzafk?tab=packages&repo_name=devcontainer-feature-emacs-lsp-bridge) section.

Use the file name of the language server definition file in lsp-bridge as the feature name.

```shell
❯ cd lsp-bridge
# ls langserver/
❯ ls multiserver/
 css_emmet.json          jedi_ruff.json                          python-ms_ruff.json
 css_tailwindcss.json    pylsp_ruff.json                         qmlls_javascript.json
 html_emmet.json         pyright-background-analysis_ruff.json   typescript_eslint.json
 html_tailwindcss.json   pyright_ruff.json                       volar_emmet.json
```

For example, to use the `pyright-background-analysis_ruff` language server, add this line to the `features` section in the `devcontainer.json`:

```json
"ghcr.io/nohzafk/devcontainer-feature-emacs-lsp-bridge/pyright-background-analysis_ruff:latest": {}
```

### Forward Ports
This is needed to communicate with the lsp-bridge server inside the container. Ensure you list the ports `9997` `9998` `9999` in the `forwardPorts` section.

### Remote User
Identify the **default user** used by your base image, such as `root` or `vscode`.

This user is used to spawn the `lsp-bridge` server process, and you need to use it when opening a file in Emacs. For more information, see the [remoteUser documentation](https://containers.dev/implementors/json_reference/#remoteUser).

## Start the devcontainer

Use [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) with `VSCode` to start the devcontainer

By default devcontainer mount the current project folder under `/workspaces/` inside the container, [more details](https://code.visualstudio.com/remote/advancedcontainers/change-default-source-mount).


### Without VSCode
If you don't want to use `VSCode`, you can use the [devcontainer CLI](https://github.com/devcontainers/cli) command line tool and [devcontainer cli port forwarder](https://github.com/nohzafk/devcontainer-cli-port-forwarder) to start the devcontaienr on Terminal.

the port forwarder is needed because forwardPorts is not implemented by `devcontainer CLI`, see [#issue 22](https://github.com/devcontainers/cli/issues/22#issuecomment-2053940737)


## Use Emacs to open file in devcontainer

use `find-file` and input the file name prefix **/docker:user@**, press `TAB`, and Emacs will list out the container name for use

```shell
C-x C-f /docker:user@container:/workspaces/project/file

where
  user           is the user that you want to use inside the container, use the same user as remoteUser in devcontainer.json
  container      is the id or name of the container
```


check [docker-tramp](https://github.com/emacs-pe/docker-tramp.el) for more details.


# Supported LSP
- ansible-language-server
- basedpyright
- basedpyright_ruff
- bash-language-server
- beancount-language-server
- ccls
- clojure-lsp
- cmake-language-server
- csharp-ls
- css_emmet
- css_tailwindcss
- dart-analysis-server
- deno
- docker-langserver
- elixirLS
- elm-language-server
- emmet-ls
- erlang-ls
- fortls
- fsautocomplete
- futhark-lsp
- gleam
- glsl-language-server
- gopls
- hls
- html_emmet
- html_tailwindcss
- intelephense
- javascript
- javascriptreact
- jdtls
- jedi
- jedi_ruff
- jsonnet-language-server
- kotlin-language-server
- lua-lsp
- marksman
- metals
- mint-ls
- nil
- nixd
- nls
- perl-language-server
- phpactor
- purescript-language-server
- pylsp
- pylsp_ruff
- pyright
- pyright-background-analysis
- pyright-background-analysis_ruff
- pyright_ruff
- rlanguageserver
- ruff
- rust-analyzer
- serve-d
- solargraph
- sumneko
- tailwindcss
- terraform-ls
- texlab
- typescript
- typescript_eslint
- typescriptreact
- typescriptreact_eslint
- typst-lsp
- vale-ls
- verible
- vscode-css-language-server
- vscode-eslint-language-server
- vscode-html-language-server
- vscode-json-language-server
- yaml-language-server
- zls

# Contributing

Nix Package Definition

The definition of which nix package to use for the language server is specified in `_generator/langserver.json`. Here is an example:

```json
{
    "langserver": "typescript",
    "packages": "nodePackages.typescript-language-server",
    "langserver_binary": "typescript-language-server"
}
```

The `packages` field for some definitions is left empty. Contributions to fill in the missing packages are welcome.

use `_generator/run_generator.sh` to gnerate the `langserver.json`

use `_generator/test.sh <feature_name>` to test the feature
