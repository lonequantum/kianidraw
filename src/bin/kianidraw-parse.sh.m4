include(src/common.M4)dnl
#!/bin/sh
. __LIB_DIR/kianidraw-common

PROG_NAME=$(basename $0)

USAGE="Usage: $PROG_NAME <kalFile> <outputDir> <duration> <fps>"
test $# -eq 4 || exit_bad_args "$USAGE"

test -f "$1" && test -r "$1" \
|| exit_error "$PROG_NAME: \"$1\": unreadable file"

test -d "$2" && test -w "$2" && test -x "$2" \
|| exit_error "$PROG_NAME: \"$2\": unwritable directory"

is_config_value_ok duration "$3" \
|| exit_error "$PROG_NAME: \"$3\": bad duration value"

is_config_value_ok final_fps "$4" \
|| exit_error "$PROG_NAME: \"$4\": bad fps value"

echo "$PROG_NAME: processing elements of timeline…"
{
	cd "$2"
	rm -rf *
	awk -v TOTAL_FRAMES=$(expr $3 \* $4) \
'
include(src/parse_kalfile.awk.m4)dnl
'
} < "$1"
