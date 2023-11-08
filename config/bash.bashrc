#!/bin/bash
#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# yay -S find-the-command
source /usr/share/doc/find-the-command/ftc.bash install

[[ $DISPLAY ]] && shopt -s checkwinsize
# alias
source /etc/bash/alias

##
if [[ $(tty) == *'tty'* ]]; then
	export LANG="en_SG.UTF-8"
	export LANGUAGE="en_SG"
	PS1="\[\033[01;31m\]\u\[\033[01;33m\]@\[\033[01;36m\]\h \[\033[01;33m\]\w \[\033[01;35m\]\$ \[\033[00m\]"
	## source .bashrc.PS1
else
	# Oh my bash
	source /usr/local/share/oh-my-bash/bashrc
fi
## PS1='[\u@\h \W]\$ '

export HISTCONTROL=ignoredups

case ${TERM} in
  Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|tmux*|xterm*)
    PROMPT_COMMAND+=('printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"')

    ;;
  screen*)
    PROMPT_COMMAND+=('printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"')
    ;;
esac

if [[ -r /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion
fi

## STOP CAT ABUSE !
: '
cat() {
	if [ -z "$@" ]; then
		while IFS= read -r line || [ -n "$line" ]; do
			echo "$line"
		done
	fi
	for arg in "$@"; do
		if ! [ -e "$arg" ]; then
			command cat "$arg"
		else
			while IFS= read -r line || [ -n "$line" ]; do
				echo "$line"
			done < "$arg"
		fi
	done
}'

run-help() { help "$READLINE_LINE" 2>/dev/null || tldr $READLINE_LINE; }
bind -m vi-insert -x '"\eh": run-help'
bind -m emacs -x     '"\eh": run-help'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
