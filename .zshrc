#!/bin/sh

fpath=(~/.zsh/functions $fpath)
fpath=(~/.zsh/plugins/zsh-completions/src $fpath)

# Aliases
source ~/.zsh/aliases.zsh

# Disable beeps
unsetopt BEEP

# History
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

# Emacs binds
bindkey -e

# Load Version Control System
autoload -Uz vcs_info
precmd() { vcs_info }

# Init completion
setopt AUTO_MENU
autoload -Uz compinit
compinit

# Autocomplete dotfiles
_comp_options+=(globdots)

# Completions
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' file-list all
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':vcs_info:git:*' formats '%b '
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# Prompt
setopt PROMPT_SUBST
PROMPT='%F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '

# Symfony autocomplete
source ~/.zsh/plugins/symfony-complete.plugin.zsh/symfony-complete.plugin.zsh
compdef _symfony_complete symfony
# compdef _symfony_complete composer
compdef _symfony_complete console
compdef _symfony_complete phpstan
compdef _symfony_complete php-cs-fixer

# Npm completions
source ~/.zsh/plugins/zsh-better-npm-completion/zsh-better-npm-completion.plugin.zsh

# Autosuggestions
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax Highlighting plugin
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# History substring search
source ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# Additionnal config
for file in ~/.zsh/custom/*; do
  if [ -f "$file" ]; then
    . "$file"
  fi
done
