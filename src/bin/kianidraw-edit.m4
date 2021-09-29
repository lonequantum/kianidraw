#!/bin/sh
PROG_NAME=$(basename $0)
MSG_PREFIX="$PROG_NAME[$(basename "$(pwd)")]"
. /usr/local/lib/kianidraw-common

is_structure_ok || exit_bad_location "$PROG_NAME"

USAGE="Usage: $PROG_NAME resources/<resourceName>"

test -n "$1" || exit_bad_args "$USAGE"

class=$(expr "$1" : '\([^/]*\)')
name=$(expr "$1" : '[^/]*/\(.*\)' | sed 's/\//\\\//g')

case $class in
resources)
	test -n "$name" || exit_bad_args "$USAGE"

	item_exists resources/"$name" \
	|| exit_error "$MSG_PREFIX: resources/\"$name\": not found"

	gimp $INTERNAL_IN_D/$name.d/$name.xcf &
	;;
*)
	exit_bad_args "$USAGE"
esac
