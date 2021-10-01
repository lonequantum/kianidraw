divert(-1)

define(__ETC_DIR,
	«syscmd(awk '/^etc_DIR=/ {printf("%s", $«»2)}' FS== EDITME)»)

define(__LIB_DIR,
	«syscmd(awk '/^lib_DIR=/ {printf("%s", $«»2)}' FS== EDITME)»)

divert(0)dnl
