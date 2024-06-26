#!/bin/zsh

alias ls="ls --color=auto"
alias ll="ls -lahF"

alias gbr="git branch | grep -v \"main\" | xargs git branch -D"

if command -v bat >/dev/null 2>&1; then
  alias cat="bat"
fi