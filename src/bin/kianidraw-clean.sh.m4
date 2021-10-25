include(src/common.M4)dnl
#!/bin/sh
. __LIB_DIR/kianidraw-common

PROG_NAME=$(basename $0)
MSG_PREFIX="$PROG_NAME[$(basename "$(pwd)")]"

is_structure_ok || exit_bad_location "$PROG_NAME"

{
	rm -f $EXTERNAL_OUT_D/*
	rm -f $INTERNAL_OUT_D/*
	rm -rf $INTERNAL_TIMELINE_D/*
	for dir in $INTERNAL_IN_D/*.d; do
		rm $dir/*.png
	done
} 2>/dev/null

echo "$MSG_PREFIX: deleted all temporary data"
