include(src/common.M4)dnl
#!/bin/sh
. __LIB_DIR/kianidraw-common

PROG_NAME=$(basename $0)
MSG_PREFIX="$PROG_NAME[$(basename "$(pwd)")]"

is_structure_ok || exit_bad_location "$PROG_NAME"

kianidraw-get timeline/stack >/dev/null || exit 1

work_mode=$(kianidraw-get config/work_mode)
item_exists config/${work_mode}_fps && item_exists config/${work_mode}_size_max \
|| exit_error "$MSG_PREFIX: config/work_mode: \"$work_mode\" is not a valid work mode"

fps=$(kianidraw-get config/${work_mode}_fps)
__config_value_ok_or_die(${work_mode}_fps, $fps, 0)

size_max=$(kianidraw-get config/${work_mode}_size_max)
__config_value_ok_or_die(${work_mode}_size_max, $size_max, 0)

duration=$(kianidraw-get config/duration)
__config_value_ok_or_die(duration, $duration, 0)

total_frames=$(expr $fps \* $duration)

rm -f $INTERNAL_OUT_D/*

parse_stack() {
	echo $1 | awk '{
		substack = 0
		for (i = 1; i <= length; i++ ) {
			c = «substr»($0, i, 1)
			if (c == "{") {
				substack++; printf("{")
			} else if (c == "}") {
				substack--; printf("}")
			} else if (c == ",") {
				if (substack > 0)
					printf(",")
				else
					printf("\n")
			} else
				printf("%c", c)
		}
		printf("\n")
	}'
}

make_command() {
	_stack=$1
	_command=""

	for item in $(parse_stack $_stack); do
		if $(echo $item | grep -q '{') ; then
			pseudoitem=$(echo $item | cut -d'{' -f1)
			  substack=$(echo $item | cut -d'{' -f2- | sed 's/}$//')
			values=$(kianidraw-get timeline/$pseudoitem@$frame 2>/dev/null)

			_command="${_command}\
( $(make_command $substack)) | convert miff:- -distort SRT '$values' miff:- ; "
		else
			values=$(kianidraw-get timeline/$item@$frame 2>/dev/null)
			item=$(echo $item | sed 's/\//\.d\//')

			if test "$values" = "0,0 1,1 0 0,0"; then
				_command="${_command}\
convert $INTERNAL_IN_D/$item.png miff:- ; "
			else
				_command="${_command}\
convert $INTERNAL_IN_D/$item.png -distort SRT '$values' miff:- ; "
			fi
		fi
	done

	echo "$_command"
}

echo "$MSG_PREFIX: building $total_frames frames ($work_mode)…"
frame=1
while test $frame -le $total_frames; do
	stack=$(kianidraw-get timeline/stack@$frame)
	output=$INTERNAL_OUT_D/$(printf '%03d' $frame).png

	command="( $(make_command $stack)) | convert -layers merge miff:- \"$output\""
	if __DEV_MODE; then
		echo "$command"
		echo
	else
		printf '\r%d' $frame
	fi

	eval $command

	frame=$(expr $frame + 1)
done

output=$EXTERNAL_OUT_D/$work_mode.gif
echo "$MSG_PREFIX: generating $output…"
convert $INTERNAL_OUT_D/'???.png' \
-resize $size_max \
-set delay $(expr 100 / $fps) \
-layers Optimize \
"$output"
