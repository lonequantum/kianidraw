#/usr/bin/env bash

alias kian=kianidraw

kianidraw_completion() {
	index=$COMP_CWORD
	current_word=${COMP_WORDS[$COMP_CWORD]}
	previous_word=${COMP_WORDS[$((COMP_CWORD - 1))]}

	config_list=$(kianidraw-get config 2>/dev/null | awk '{print "config/"$0}')
	resources_list=$(kianidraw-get resources 2>/dev/null | awk '{print "resources/"$0}')

	while [[ $index > 0 ]]; do
		sub_arg_no=$((COMP_CWORD - index))

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
				[ $previous_word != '-m' ] && compopt -o default
				COMPREPLY=()
				return
				;;
			3)
				if [ ${COMP_WORDS[$((COMP_CWORD - 2))]} = '-m' ]; then
					compopt -o default
					COMPREPLY=()
					return
				else
					break
				fi;;
			*)
				break
			esac;;
		set)
			case $sub_arg_no in
			1)
				COMPREPLY=($(compgen -W " \
					timeline \
					config/all \
					$config_list \
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
					$config_list \
					resources/all \
					$resources_list \
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
					timeline \
					$resources_list \
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
					timeline \
					resources/all \
					$resources_list \
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
