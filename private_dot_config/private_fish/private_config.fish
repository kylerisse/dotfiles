if status is-interactive
  if type -q nvim
    set EDITOR nvim
    alias vi='nvim'
    alias vim='nvim'
  else if type -q vim
    set EDITOR vim
    alias vi='vim'
  else
    set EDITOR vi
  end

  if type -q icdiff
    alias diff='icdiff --line-numbers'
  end

  set LESS '-XR'
  alias less='less -XR'
  set PAGER 'less -XR'

  # private variables aren't secrets but shouldn't be public either
  if test -e ~/.config/chezmoi/private-vars.fish
    source ~/.config/chezmoi/private-vars.fish
  end

  # direnv shell hooks
  if type -q direnv
    direnv hook fish | source
  end

  # kube shorthands
  if type -q kubectl
    alias k='kubectl'
  end

  if type -q kubectx
    alias kx='kubectx'
  end

  # podman shorthands
  if type -q podman
    alias docker='podman'
    alias p='podman'
    alias renovate-config-validator='podman run -v (pwd):/usr/src/app -ti ghcr.io/renovatebot/renovate renovate-config-validator'
  end

  # set GOROOT to nix location
  if test -e /run/current-system/sw/bin/go
    set GOROOT (ls -al /run/current-system/sw/bin/go | awk '{print $11}' | string replace '/bin/' '/share/')
  end
end
