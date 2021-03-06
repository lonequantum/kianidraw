include(src/common.M4)dnl
#!/bin/sh
PROG_NAME=$(basename $0)

command=":"
add_subcommand() {
	test -n "$1" || return
	command="$command && $*"
	test $1 = kianidraw-new && command="$command && cd $2"
}

subcommand=""
while test $# -ge 1; do
	case $1 in
	new|import|edit|update|get|set|make|clean)
		test -n "$subcommand" && add_subcommand $subcommand
		subcommand=kianidraw-$1
		;;
	*)
		if test -z "$subcommand"; then
			echo "$PROG_NAME: warning: \"$1\": arg ignored" >&2
		else
			subcommand="$subcommand \"$1\""
		fi
	esac
	shift
done
add_subcommand $subcommand

eval $command
