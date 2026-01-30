if which nvim >/dev/null 2>&1; then
  alias vim='nvim'
  export EDITOR='nvim'
  export VISUAL='nvim'
elif which vim >/dev/null 2>&1; then
  export EDITOR='vim'
  export VISUAL='vim'
fi
