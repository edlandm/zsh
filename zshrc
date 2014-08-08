# vim:fdm=marker
# ZSHRC -- Miles Edland ========================================================
# Prezto Authors: Sorin Ionescu <sorin.ionescu@gmail.com>
#===============================================================================
# Configure Path ==============================================================={{{
# Path for zsh files (mostly ones that get sourced
ZHOME=$HOME/.zsh
if [ ! -d $ZHOME ];then
    mkdir -p $ZHOME
fi
# Export PATH
PATH=$HOME/bin:/opt/local/bin:/opt/local/sbin:/Library/Frameworks/Python.framework/Versions/2.7/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH=$PATH

#===============================================================================}}}
# Source ======================================================================={{{
#===============================================================================
# Source Prezto.
if [[ -s "${ZDOTDIR:-$ZHOME}/init.zsh" ]]; then
  source "${ZDOTDIR:-$ZHOME}/init.zsh"
fi
# opp.zsh enables text objects for zsh
# if [ ! -d "$HOME/.zsh/opp.zsh" ];then
    # cd $ZHOME
    # git clone https://github.com/hchbaw/opp.zsh
    # cd -
# fi
# source "$HOME/.zsh/opp.zsh/opp.zsh"

# Local zrc file
if [ -e $HOME/.zshrc.local ];then
    source $HOME/.zshrc.local
fi
#===============================================================================}}}
# Settings ====================================================================={{{
#===============================================================================
APPEND_HISTORY="true"
AUTO_MENU="true"
AUTO_REMOVE_SLASH="true"
DVORAK="false"
EXTENDED_GLOB="true"
GLOB_DOTS="true"
HISTORY_IGNORE_DUPS="true"
HISTORY_IGNORE_SPACE="true"
NULL_GLOBS="true"
#Set terminal type
export TERM="xterm-256color"
# Lets you cd into a directory by just typing its name (without cd)
setopt autocd
#Fuzzy matching of completions for when you mistype them:
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
# History Expansion on <space>
bindkey " " magic-space
#Loads zmv (zmv is for some massive file moving magic)
autoload -U zmv
# blink matching parenthesis
set blink-matching-paren on
# Get rid of that confounded beep
unset beep
set nobeep
#===============================================================================}}}
# Plugins ======================================================================{{{
#===============================================================================
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git pip zsh-syntax-highlighting)
#===============================================================================}}}
# etc  ======================================================================{{{
#===============================================================================
# use ctr-z instead of fg
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# Enable globbing in history search
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^S" history-incremental-pattern-search-forward
#===============================================================================}}}
# vi-mode ======================================================================{{{
#===============================================================================
bindkey -v
export KEYTIMEOUT=80
# Insert-Mode Mappings (To make it behave more like a normal terminal)

# "^" = Ctrl
bindkey -M viins '^a' beginning-of-line
bindkey -M viins '^e' end-of-line
bindkey -M viins '^l' clear-screen
bindkey -M viins '^u' kill-whole-line
bindkey -M viins 'hh' vi-cmd-mode
# ctrl-p ctrl-n history navigation
bindkey '^P' up-history
bindkey '^N' down-history
# backspace and ^h working even after returning from command mode
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^h' backward-delete-char
# Multi-level undo/redo
bindkey -M vicmd 'u' undo
bindkey -M vicmd '^R' redo
# ctrl-w removed word backwards
bindkey -M viins '^w' backward-kill-word
# ctrl-r starts searching history backward
bindkey -M viins '^r' history-incremental-search-backward

# Stop weird behavior when hitting escape multiple times
noop () {}
zle -N noop
bindkey -M vicmd '\E' noop

# Changes cursor shape depending on mode
if [ "$ITERM_CURSOR" != "false" ]; then # {{{

    BLOCK='\E]50;CursorShape=0\x7' # Block Cursor
    LINE='\E]50;CursorShape=1\x7' # Line Cursor
    BAR='\E]50;CursorShape=2\x7' # Bar Cursor

    print-ins () {
        if [ $TERM = screen-256color ]; then
            print -n -- "\EPtmux;\E$LINE\E\\"
        else
            print -n -- $LINE
        fi
    }

    print-cmd () {
        if [ $TERM = screen-256color ]; then
            print -n -- "\EPtmux;\E$BLOCK\E\\"
        else
            print -n -- $BLOCK
        fi
    }

    zle-keymap-select () {
        if [ $KEYMAP = vicmd ]; then
            print-cmd
        elif [ $KEYMAP = main ]; then
            print-ins
        fi
    }

    zle-line-init () {
        print-ins
    }

    zle -N print-ins
    zle -N print-cmd
    zle -N zle-line-init
    zle -N zle-keymap-select

    # Binds the escape sequences to change cursor accordingly.
    bindkey -M vicmd '\E[I' print-cmd
    bindkey -M vicmd '\E[O' noop
    bindkey -M viins '\E[I' print-ins
    bindkey -M viins '\E[O' noop
fi # }}}
#===============================================================================}}}
