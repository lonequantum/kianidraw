#!/bin/sh
. ./EDITME

test $(id -u) -eq 0 || {
	echo "permission denied (are you root?)" >&2
	exit 77
}

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

if $use_bash; then
	rm -f "$BASH_COMP_DIR"/kianidraw
	if $dev_mode; then
		ln -s "$(pwd)"/kianidraw.bash "$BASH_COMP_DIR"/kianidraw
	else
		cp kianidraw.bash "$BASH_COMP_DIR"/kianidraw
	fi && echo $BASH_COMP_DIR/kianidraw
fi
