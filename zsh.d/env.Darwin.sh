if which nvim &> /dev/null; then
  alias vim='nvim'
  export EDITOR='nvim'
  export GIT_EDITOR='nvim'
else
  export EDITOR="vim"
  export GIT_EDITOR="vim"
fi
