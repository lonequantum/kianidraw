#!/bin/sh
bin_DIR=/usr/local/bin
lib_DIR=/usr/local/lib
etc_DIR=/usr/local/etc

test $(id -u) -eq 0 || {
	echo "permission denied" >&2
	exit 77
}

dev_mode=true

for dir in bin lib etc; do
	dest_dir=$(eval printf "\$${dir}_DIR")
	rm -f "$dest_dir"/kianidraw*

	for file in target/$dir/kianidraw*; do
		if $dev_mode; then
			ln -s "$(pwd)"/$file "$dest_dir"
		else
			cp $file "$dest_dir"
		fi
		echo $dest_dir/$(basename $file)
	done
done

BASH_COMP_DIR=/etc/bash_completion.d

rm -f "$BASH_COMP_DIR"/kianidraw
if $dev_mode; then
	ln -s "$(pwd)"/kianidraw.bash "$BASH_COMP_DIR"/kianidraw
else
	cp kianidraw.bash "$BASH_COMP_DIR"/kianidraw
fi && echo $BASH_COMP_DIR/kianidraw
