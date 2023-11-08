#!/bin/bash
TIME=0
PROMPT_COMMAND='
((TIME++))
if [[ $TIME != 1 ]];then
	EXIT_CODE=$?
fi
PS1="\[\033[01;31m\]\u\[\033[01;33m\]@\[\033[01;36m\]\h \[\033[01;33m\]\w \[\033[01;35m\]\$ \[\033[00m\]"
if [[ $EXIT_CODE -ne 0 ]]; then
	PS1="\[\033[38;2;255;0;0m\]●\[\033[0m\]$PS1"
elif [[ -z $EXIT_CODE ]];then
	PS1="○$PS1"
else
	PS1="\[\033[38;2;0;255;255m\]●\[\033[0m\]$PS1"
fi
'
