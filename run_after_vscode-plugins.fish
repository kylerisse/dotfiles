#!/usr/bin/env fish

# idempotent script meant to run on every chezmoi apply
# will sync installed vscode extensions with the list
# which includes uninstalls

if not type -q code
    exit 0
end

set -l NODE_OPTIONS ""

set wanted_extensions (echo "bmalehorn.vscode-fish
Boto3typed.boto3-ide
golang.go
hashicorp.terraform
jdforsythe.add-new-line-to-files
jnoortheen.nix-ide
ms-python.isort
ms-python.python
ms-python.vscode-pylance
ms-vscode-remote.remote-containers
ms-vscode-remote.remote-ssh
ms-vscode-remote.remote-ssh-edit
ms-vscode.makefile-tools
ms-vscode.remote-explorer
redhat.ansible
redhat.vscode-yaml
scriplit.perl6-lsp
shardulm94.trailing-spaces
timonwong.shellcheck
vscodevim.vim
waderyan.gitblame
yzane.markdown-pdf")

set installed_extensions (code --list-extensions)

for extension in $installed_extensions
    if not contains $extension $wanted_extensions
        code --uninstall-extension $extension
    end
end

for extension in $wanted_extensions
    if not contains $extension $installed_extensions
        code --install-extension $extension
    end
end
