#!/bin/sh
INSTALL_DIR=/usr/local/bin


test $(id -u) -eq 0 || {
	echo "permission denied" >&2
	exit 77
}

dev_mode=false
case $1 in
[dD][eE][vV])
	dev_mode=true
	echo "DEV mode => symlinks instead of copies";;
esac

rm -f "$INSTALL_DIR"/kianidraw*

for command in kianidraw*; do
	if $dev_mode; then
		ln -s "$(pwd)"/$command "$INSTALL_DIR"
	else
		cp $command "$INSTALL_DIR"
	fi
done
