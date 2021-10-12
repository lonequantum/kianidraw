include(src/common.m4)dnl
#!/bin/sh
. __LIB_DIR/kianidraw-common

PROG_NAME=$(basename $0)

USAGE="Usage: $PROG_NAME <kalFile> <outputDir> <duration> <fps>"
test $# -eq 4 || exit_bad_args "$USAGE"

test -r "$1" \
|| exit_error "$PROG_NAME: \"$1\": unreadable file"

test -w "$2" \
|| exit_error "$PROG_NAME: \"$2\": unwritable directory"

