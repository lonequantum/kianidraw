include(src/common.m4)dnl
#!/bin/sh
. __LIB_DIR/kianidraw-common

PROG_NAME=$(basename $0)
MSG_PREFIX="$PROG_NAME[$(basename "$(pwd)")]"

is_structure_ok || exit_bad_location "$PROG_NAME"

USAGE="\
Usage: $PROG_NAME config/<name> <value>|default
       $PROG_NAME config/all default"

test $# -eq 2 || exit_bad_args "$USAGE"

class=$(expr "$1" : '\([^/]*\)')
name=$(expr "$1" : '[^/]*/\(.*\)' | sed 's/\//\\\//g')
value=$2

delete_config_line() {
	_line=$1

	awk "!/$_line/" $INTERNAL_CONFIG > $INTERNAL_CONFIG.tmp
	rm $INTERNAL_CONFIG
	mv $INTERNAL_CONFIG.tmp $INTERNAL_CONFIG
}

case $class in
config)
	test -n "$name" || exit_bad_args "$USAGE"

	test X"$name" = Xall && {
		case $value in
		default)
			> $INTERNAL_CONFIG
			echo "$MSG_PREFIX: deleted local config"
			exit
			;;
		*)
			exit_bad_args "$USAGE"
		esac
	}

	expr "$name" : "$CONFIG_NAME_PATTERN\$" >/dev/null \
	|| exit_error "$MSG_PREFIX: config/\"$name\": bad name"

	old_value=$(kianidraw-get config/$name 2>/dev/null)

	case $value in
	default)
		test -n "$old_value" \
		|| exit_error "$MSG_PREFIX: config/\"$name\": unknown, default value not available"

		delete_config_line "^$name=$old_value\$"
		echo "$MSG_PREFIX: deleted \"$name\" from local config"
		;;
	*)
		__check_config_value_or_exit_error($name, $value, 2)

		delete_config_line "^$name=$old_value\$"
		echo "$name=$value" >> $INTERNAL_CONFIG
		echo "$MSG_PREFIX: updated local config with \"$name=$value\""
	esac
	;;
*)
	exit_bad_args "$USAGE"
esac
