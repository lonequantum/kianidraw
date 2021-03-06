include(src/common.M4)dnl
#!/bin/sh
. __LIB_DIR/kianidraw-common

PROG_NAME=$(basename $0)
MSG_PREFIX="$PROG_NAME[$(basename "$(pwd)")]"

is_structure_ok || exit_bad_location "$PROG_NAME"

input_size_max=$(kianidraw-get config/input_size_max)
__config_value_ok_or_die(input_size_max, $input_size_max, 0)

move=false
test X"$1" = X"-m" && {
	move=true
	shift
}

test $# -eq 2 \
|| exit_bad_args "Usage: $PROG_NAME [-m] <resourceName> <file>"

__item_name_ok_or_die($1, 0)

case $1 in
all)
	exit_error "$MSG_PREFIX: \"$1\": reserved keyword"
esac

! item_exists resources/$1 \
|| exit_error "$MSG_PREFIX: \"$1\": resource name already in use"

test -r "$2" \
|| exit_error "$MSG_PREFIX: \"$2\": unreadable file"

sum=$(cksum "$2" | awk '{print $1}')
! $(ls -A $EXTERNAL_IN_D | grep -q $sum) \
|| exit_error "$MSG_PREFIX: \"$2\": file already imported"

new_filename=${sum}_$(basename $2)
if $move; then
	mv "$2" $EXTERNAL_IN_D/"$new_filename"
else
	cp "$2" $EXTERNAL_IN_D/"$new_filename"
fi

ln -s $(return_path $INTERNAL_IN_D)/$EXTERNAL_IN_D/"$new_filename" $INTERNAL_IN_D/$1
mkdir $INTERNAL_IN_D/$1.d
convert -resize $input_size_max $INTERNAL_IN_D/$1 $INTERNAL_IN_D/$1.d/$1.xcf

echo "$MSG_PREFIX: imported \"$2\" as \"$1\""
