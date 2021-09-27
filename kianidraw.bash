#/usr/bin/env bash

alias kian=kianidraw

kian_completion() {
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
				$(kianidraw-get resources 2>/dev/null | awk '{print "resources/"$0}')\
				"\
				"${COMP_WORDS[2]}"\
			));;
		update)
			COMPREPLY=($(compgen -W "\
				resources/all\
				$(kianidraw-get resources 2>/dev/null | awk '{print "resources/"$0}')\
				"\
				"${COMP_WORDS[2]}"\
			));;
		set)
			COMPREPLY=($(compgen -W "\
				config/all\
				$(kianidraw-get config 2>/dev/null | awk '{print "config/"$0}')\
				"\
				"${COMP_WORDS[2]}"\
			));;
		get)
			COMPREPLY=($(compgen -W "\
				config/all\
				$(kianidraw-get config 2>/dev/null | awk '{print "config/"$0}')\
				resources/all\
				$(kianidraw-get resources 2>/dev/null | awk '{print "resources/"$0}')\
				"\
				"${COMP_WORDS[2]}"\
			))
		esac;;

	3)
		case ${COMP_WORDS[1]} in
		set)
			COMPREPLY=($(compgen -W "\
				default\
				"\
				"${COMP_WORDS[3]}"\
			));;
		import)
			if [ "${COMP_WORDS[2]}" != "-m" ]; then
				compopt -o default
				COMPREPLY=()
			fi
		esac;;

	4)
		case ${COMP_WORDS[1]} in
		import)
			if [ "${COMP_WORDS[2]}" = "-m" ]; then
				compopt -o default
				COMPREPLY=()
			fi
		esac
	esac
}

complete -F kianidraw_completion kianidraw
