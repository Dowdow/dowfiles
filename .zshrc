#!/bin/sh

fpath=(~/zsh/plugins/zsh-completions/src $fpath)

# Aliases
source ~/zsh/aliases.zsh

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
setopt MENU_COMPLETE
setopt COMPLETE_IN_WORD
autoload -Uz compinit
compinit

# Autocomplete dotfiles
_comp_options+=(globdots)

# Completions
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' file-list all
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':vcs_info:git:*' formats '%b '

# Prompt
setopt PROMPT_SUBST
PROMPT='%F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '

# Autosuggestions
source ~/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax Highlighting plugin (must be at the end)
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
