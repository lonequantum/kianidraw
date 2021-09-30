define(__ETC_DIR, «syscmd(awk '/^etc_DIR=/ {printf("%s", $«»2)}' FS== EDITME)»)dnl
define(__LIB_DIR, «syscmd(awk '/^lib_DIR=/ {printf("%s", $«»2)}' FS== EDITME)»)dnl
