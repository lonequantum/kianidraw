include(src/common.M4)dnl
#!/bin/sh
. __LIB_DIR/kianidraw-common

PROG_NAME=$(basename $0)
MSG_PREFIX="$PROG_NAME[$(basename "$(pwd)")]"

is_structure_ok || exit_bad_location "$PROG_NAME"
kianidraw-get stack >/dev/null || exit 1
