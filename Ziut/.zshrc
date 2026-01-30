setopt prompt_subst
autoload colors; colors;

alias up="cd ../"
alias magazyn="cd /c/Users/Ziut/Desktop/magazyn/frontend"
alias c="clear"

alias ls="ls -a"
alias ll="ls -G -la"

if which nvim >/dev/null 2>&1; then
  alias vim='nvim'
  export EDITOR='nvim'
  export VISUAL='nvim'
elif which vim >/dev/null 2>&1; then
  export EDITOR='vim'
  export VISUAL='vim'
fi



git_prompt_info() {
  local clear=""
  local dirty="%{$fg_bold[red]%} X%{$reset_color%}"
  
  local dirstatus="$clear"
  if [[ ! -z $(git status --porcelain 2> /dev/null | tail -n1) ]]; then
    dirstatus=$dirty
  fi

  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo " %{$fg_bold[green]%}${ref#refs/heads/}$dirstatus%{$reset_color%}"
}

local dir_info_color="%B"
local dir_info="%{$dir_info_color%}%(5~|%-1~/.../%2~|%4~)%{$reset_color%}"
local promptnormal="φ %{$reset_color%}"
local promptjobs="%{$fg_bold[red]%}φ %{$reset_color%}"

PROMPT='${dir_info}$(git_prompt_info) %(1j.$promptjobs.$promptnormal)'
