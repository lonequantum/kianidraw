changequote(«,»)dnl
include(«common.m4»)dnl
#!/bin/sh
PROG_NAME=$(basename $0)
. /usr/local/lib/kianidraw-common

test -n "$1" || exit_bad_args "Usage: $PROG_NAME <projectName>"

mkdir "$1" || exit 1

cd "$1"

mkdir -p $INTERNAL_IN_D $EXTERNAL_IN_D \
&& > $INTERNAL_CONFIG \
&& echo "$PROG_NAME: created project \"$1\", remember to cd into it"
