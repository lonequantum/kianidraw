#/usr/bin/env bash

alias kian=kianidraw

kianidraw_completion() {
	index=$COMP_CWORD
	while [[ $index > 0 ]]; do
		sub_arg_no=$((COMP_CWORD - index))
		current_word=${COMP_WORDS[$COMP_CWORD]}

		case ${COMP_WORDS[$index]} in
		new)
			case $sub_arg_no in
			1)
				COMPREPLY=()
				return
				;;
			*)
				break
			esac;;
		import)
			case $sub_arg_no in
			1)
				COMPREPLY=()
				return
				;;
			2)
				compopt -o default
				COMPREPLY=()
				return
				;;
			*)
				break
			esac;;
		set)
			case $sub_arg_no in
			1)
				COMPREPLY=($(compgen -W " \
					config/all \
					$(kianidraw-get config 2>/dev/null | awk '{print "config/"$0}') \
					" \
					"$current_word" \
				))
				return
				;;
			2)
				COMPREPLY=($(compgen -W " \
					default \
					" \
					"$current_word" \
				))
				return
				;;
			*)
				break
			esac;;
		get)
			case $sub_arg_no in
			1)
				COMPREPLY=($(compgen -W " \
					config/all \
					$(kianidraw-get config 2>/dev/null | awk '{print "config/"$0}') \
					resources/all \
					$(kianidraw-get resources 2>/dev/null | awk '{print "resources/"$0}') \
					" \
					"$current_word" \
				))
				return
				;;
			*)
				break
			esac;;
		edit)
			case $sub_arg_no in
			1)
				COMPREPLY=($(compgen -W " \
					$(kianidraw-get resources 2>/dev/null | awk '{print "resources/"$0}') \
					" \
					"$current_word" \
				))
				return
				;;
			*)
				break
			esac;;
		update)
			case $sub_arg_no in
			1)
				COMPREPLY=($(compgen -W " \
					resources/all \
					$(kianidraw-get resources 2>/dev/null | awk '{print "resources/"$0}') \
					" \
					"$current_word" \
				))
				return
				;;
			*)
				break
			esac
		esac

		((index--))
	done

	COMPREPLY=($(compgen -W "\
		new\
		import\
		edit\
		update\
		get\
		set\
		"\
		"${COMP_WORDS[$COMP_CWORD]}"\
	))
}

complete -F kianidraw_completion kianidraw kian
