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

  # TODO: ssh completions
end
