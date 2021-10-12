include(src/common.m4)dnl
#!/bin/sh
. __LIB_DIR/kianidraw-common

PROG_NAME=$(basename $0)
MSG_PREFIX="$PROG_NAME[$(basename "$(pwd)")]"

USAGE="Usage: $PROG_NAME <kalFile> <outputDir> <duration> <fps>"
test $# -eq 4 || exit_bad_args "$USAGE"

test -r "$1" \
|| exit_error "$MSG_PREFIX: \"$1\": unreadable file"

test -w "$2" \
|| exit_error "$MSG_PREFIX: \"$2\": unwritable directory"

