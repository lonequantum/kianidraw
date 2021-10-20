divert(-1)
changequote(«,»)

define(tab,
	«ifelse($#, 0,
		««$0»»,
		«ifelse(eval($1 > 0), 1,
			«	tab(eval($1 - 1))»)»)»)

define(__ETC_DIR,
	«syscmd(awk -v FS== '/^etc_DIR=/ {printf("%s", $«»2)}' EDITME)»)

define(__LIB_DIR,
	«syscmd(awk -v FS== '/^lib_DIR=/ {printf("%s", $«»2)}' EDITME)»)

define(__DEV_MODE,
	«syscmd(awk -v FS== '/^dev_mode=/ {printf("%s", $«»2)}' EDITME)»)

define(__config_value_ok_or_die,
	«is_config_value_ok $1 "$2" \
tab($3)«»|| exit_error "$MSG_PREFIX: config/$1: \"$2\": bad value"»)

define(__item_name_ok_or_die,
	«is_item_name_ok "$1" \
tab($2)«»|| exit_error "$MSG_PREFIX: \"$1\": bad item name"»)

define(__set_frame_from_name_or_die,
	«frame=$(echo "$name" | cut -d@ -f2)
tab($1)«»expr "$frame" : '[0-9]\{1,\}$' >/dev/null || exit_bad_args "$USAGE"
tab($1)«»test $frame -gt 0 || exit_error "$MSG_PREFIX: \"$name\": frame cannot be < 1"»)

divert(0)dnl
