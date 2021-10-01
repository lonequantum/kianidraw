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

define(__check_config_value_or_exit_error,
	«check_config_value $1 "$2" \
tab($3)«»|| exit_error "$MSG_PREFIX: config/$1: \"$2\": bad value"»)

divert(0)dnl
