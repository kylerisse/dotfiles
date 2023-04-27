if status is-interactive
  if hash nvim 2>/dev/null
    set EDITOR nvim
    alias vi='nvim'
    alias vim='nvim'
  else
    set EDITOR vi
  end

  if hash icdiff 2>/dev/null
    alias diff='icdiff --line-numbers'
  end

  set LESS '-xR'
  alias less='less -xR'

  # TODO: ssh completions
end
