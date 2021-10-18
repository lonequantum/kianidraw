include(src/common.M4)dnl
#!/bin/sh
. __LIB_DIR/kianidraw-common

PROG_NAME=$(basename $0)
MSG_PREFIX="$PROG_NAME[$(basename "$(pwd)")]"

is_structure_ok || exit_bad_location "$PROG_NAME"

USAGE="\
Usage: $PROG_NAME config[/(all|<name>)]
       $PROG_NAME resources[/(all|<name>)]
       $PROG_NAME stack[/(all|<frame>)]"

test -n "$1" || exit_bad_args "$USAGE"

class=$(expr "$1" : '\([^/]*\)')
name=$(expr "$1" : '[^/]*/\(.*\)' | sed 's/\//\\\//g')

case $class in
config)
	test X"$name" = Xall && {
		cat $INTERNAL_CONFIG $SYSTEM_CONFIG \
		| awk "/^$ITEM_NAME_PATTERN=$CONFIG_VALUE_PATTERN\$/" \
		| nl -s = \
		| sort -u -t = -k2,2 \
		| cut -d = -f2-
		exit
	}

	test -z "$name" && {
		kianidraw-get config/all | cut -d = -f1
		exit
	}

	value=$(kianidraw-get config/all | awk -v FS== "/^$name=/ {print \$2}")
	if test -n "$value"; then
		echo $value
	else
		exit_error "$MSG_PREFIX: config/\"$name\": not found"
	fi
	;;
resources)
	test X"$name" = Xall && {
		for r in $(kianidraw-get resources); do
			elements=$(kianidraw-get resources/$r)
			echo $r: $elements
		done
		exit
	}

	cd $INTERNAL_IN_D
	test -z "$name" && {
		find . ! -name . -prune -type l | sed 's/^\.\///'
		exit
	}

	cd "$name".d 2>/dev/null || exit_error "$MSG_PREFIX: resources/\"$name\": not found"
	ls -1 *.png 2>/dev/null | sed 's/\.png//'
	;;
stack)
	test -f $INTERNAL_TIMELINE_D/stack \
	|| exit_error "$MSG_PREFIX: no stack found, please edit/update timeline first"

	expr "$name" : '[0-9]\{1,\}$' >/dev/null && {
		test $name -gt 0 || exit_error "$MSG_PREFIX: stack/frame cannot be < 1"

		awk "\$1 <= $name {print \$2}" $INTERNAL_TIMELINE_D/stack | tail -n 1
		exit
	}

	case $name in
	all)
		cat $INTERNAL_TIMELINE_D/stack | sed 's/\t/: /';;
	"")
		awk '{print $1}' $INTERNAL_TIMELINE_D/stack;;
	*)
		exit_bad_args "$USAGE"
	esac
	;;
*)
	exit_bad_args "$USAGE"
esac
