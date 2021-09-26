#/usr/bin/env bash

alias kian=kianidraw

_kian_completion() {
	case $COMP_CWORD in
	1)
		COMPREPLY=($(compgen -W "\
			new\
			import\
			edit\
			update\
			get\
			set\
			"\
			"${COMP_WORDS[1]}"\
		));;

	2)
		case ${COMP_WORDS[1]} in
		edit)
			COMPREPLY=($(compgen -W "\
				$(kianidraw-get resources 2>/dev/null)\
				"\
				"${COMP_WORDS[2]}"\
			));;
		update)
			COMPREPLY=($(compgen -W "\
				all\
				$(kianidraw-get resources 2>/dev/null)\
				"\
				"${COMP_WORDS[2]}"\
			));;
		set)
			COMPREPLY=($(compgen -W "\
				$(kianidraw-get config 2>/dev/null | cut -d = -f1 | awk '{print "config/"$0}')\
				"\
				"${COMP_WORDS[2]}"\
			));;
		get)
			COMPREPLY=($(compgen -W "\
				$(kianidraw-get config 2>/dev/null | cut -d = -f1 | awk '{print "config/"$0}')\
				resources/all\
				$(kianidraw-get resources 2>/dev/null | awk '{print "resources/"$0}')\
				"\
				"${COMP_WORDS[2]}"\
			));;
		esac;;

	3)
		case ${COMP_WORDS[1]} in
		update)
			COMPREPLY=($(compgen -W "\
				all\
				$(kianidraw-get resources 2>/dev/null)\
				"\
				"${COMP_WORDS[3]}"\
			));;
		set)
			COMPREPLY=($(compgen -W "\
				default\
				"\
				"${COMP_WORDS[3]}"\
			));;
		import)
			compopt -o default
			COMPREPLY=()
			;;
		esac;;

	*)
		case ${COMP_WORDS[1]} in
		update)
			COMPREPLY=($(compgen -W "\
				all\
				$(kianidraw-get resources 2>/dev/null)\
				"\
				"${COMP_WORDS[$COMP_CWORD]}"\
			));;
		esac
	esac
}

complete -F _kian_completion kianidraw kian
