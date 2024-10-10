# dotfiles

## Usage

Requires [chezmoi](https://github.com/twpayne/chezmoi) and [fish-shell](https://github.com/fish-shell/fish-shell)

```
fish
set -l dotfiles ~/go/src/github.com/kylerisse/dotfiles
mkdir -p $dotfiles
mkdir -p ~/.local/share/
ln -s $dotfiles ~/.local/share/chezmoi
set -e dotfiles
chezmoi init --apply kylerisse
```

## Config

`~/.config/chezmoi/chezmoi.toml`
```INI
[diff]
  exclude = ["scripts"]
```

`~/.config/chezmoi/private-vars.yml`
```
set GITLAB_SYNC_GROUP "1234567"
set GITLAB_BASE_PATH "/home/user/workspace"
set GITLAB_RO_API_TOKEN "ZYX-ABCDEFGH"
```

vscode mac
```
ln -s ~/.config/Code/Users/settings.json ~/Library/Application\ Support/Code/User/settings.json
```

## Helpers

```
make diff
make status
make apply
```
