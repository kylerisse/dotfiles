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

  # TODO: ssh completions
end
