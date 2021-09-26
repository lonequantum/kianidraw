#/usr/bin/env bash

alias kian=kianidraw

_kian_completion() {
	case $COMP_CWORD in
	1)
		COMPREPLY=($(compgen -W "new import edit update get set" "${COMP_WORDS[1]}"));;
	2)
		case ${COMP_WORDS[1]} in
		edit)
			COMPREPLY=($(compgen -W "$(kianidraw-get resources 2>/dev/null)" "${COMP_WORDS[2]}"));;
		update)
			COMPREPLY=($(compgen -W "all $(kianidraw-get resources 2>/dev/null)" "${COMP_WORDS[2]}"));;
		set)
			COMPREPLY=($(compgen -W "config" "${COMP_WORDS[2]}"));;
		get)
			COMPREPLY=($(compgen -W "config resources" "${COMP_WORDS[2]}"));;
		esac
	esac
}

complete -F _kian_completion kianidraw kian
