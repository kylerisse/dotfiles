if status is-interactive
  if type -q nvim
    set EDITOR nvim
    alias vi='nvim'
    alias vim='nvim'
  else
    set EDITOR vi
  end

  if type -q icdiff
    alias diff='icdiff --line-numbers'
  end

  set LESS '-xR'
  alias less='less -xR'

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

  # set GOROOT to nix location
  if test -e /run/current-system/sw/bin/go
    set GOROOT (ls -al /run/current-system/sw/bin/go | awk '{print $11}' | string replace '/bin/' '/share/')
  end
end
