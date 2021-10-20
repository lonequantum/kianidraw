include(src/common.M4)dnl
#!/bin/sh
SYSTEM_CONFIG=__ETC_DIR/kianidraw.config
INTERNAL_CONFIG=.kianidraw/config

EXTERNAL_TIMELINE=timeline
INTERNAL_TIMELINE_D=.kianidraw/timeline

INTERNAL_IN_D=.kianidraw/in
EXTERNAL_IN_D=in

INTERNAL_OUT_D=.kianidraw/out
EXTERNAL_OUT_D=out

ITEM_NAME_PATTERN='[_a-zA-Z0-9][-_.a-zA-Z0-9]*'

CONFIG_VALUE_PATTERN='[-_.a-zA-Z0-9][-_. a-zA-Z0-9]*'
CONFIG_input_size_max_PATTERN='[1-9][0-9]\{2,\}x[1-9][0-9]\{2,\}'
CONFIG_final_size_max_PATTERN='[1-9][0-9]\{2,\}x[1-9][0-9]\{2,\}'
CONFIG_testing_size_max_PATTERN='[1-9][0-9]\{2,\}x[1-9][0-9]\{2,\}'
CONFIG_duration_PATTERN='[1-9][0-9]\{0,1\}'
CONFIG_final_fps_PATTERN='[1-9][0-9]\{0,1\}'
CONFIG_testing_fps_PATTERN='[1-9][0-9]\{0,1\}'

DEFAULT_SRT_VALUES="0,0 1,1 0 0,0"

exit_bad_location() {
	_msg_prefix=$1

	exit_error "$_msg_prefix: not in a valid/usable kianidraw project, please cd or check permissions"
}

exit_bad_args() {
	_msg=$1

	echo "$_msg" >&2
	exit 64
}

exit_error() {
	_msg=$1

	echo "$_msg" >&2
	exit 1
}

are_file_perms_ok() {
	_file=$1

	if test X"$_file" = X"-"; then
		while read _file; do
			test -r "$_file" || return 1
			test -w "$_file" || return 1
		done
	else
		test -r "$_file" || return 1
		test -w "$_file" || return 1
	fi
}

are_dir_perms_ok() {
	_dir=$1

	if test X"$_dir" = X"-"; then
		while read _dir; do
			test -r "$_dir" || return 1
			test -w "$_dir" || return 1
			test -x "$_dir" || return 1
		done
	else
		test -r "$_dir" || return 1
		test -w "$_dir" || return 1
		test -x "$_dir" || return 1
	fi
}

is_structure_ok() {
	_dir=${1:-.}

	test -d "$_dir"/$INTERNAL_IN_D       || return 1
	test -d "$_dir"/$EXTERNAL_IN_D       || return 1
	test -d "$_dir"/$INTERNAL_OUT_D      || return 1
	test -d "$_dir"/$EXTERNAL_OUT_D      || return 1
	test -d "$_dir"/$INTERNAL_TIMELINE_D || return 1
	test -f "$_dir"/$EXTERNAL_TIMELINE   || return 1
	test -f "$_dir"/$INTERNAL_CONFIG     || return 1
	find "$_dir" -type d | are_dir_perms_ok -  || return 1
	find "$_dir" -type f | are_file_perms_ok - || return 1
}

return_path() {
	_path=$1

	echo "$_path" | sed 's/[^/]\{1,\}/../g'
}

item_exists() {
	_item=$1

	kianidraw-get "$_item" >/dev/null 2>&1
}

is_item_name_ok() {
	_name=$1

	expr "$_name" : "$ITEM_NAME_PATTERN\$" >/dev/null
}

is_config_value_ok() {
	_name=$1
	_value=$2

	_pattern=$(eval echo \$CONFIG_${_name}_PATTERN)
	_pattern=${_pattern:-$CONFIG_VALUE_PATTERN}

	expr "$_value" : "$_pattern\$" >/dev/null
}
