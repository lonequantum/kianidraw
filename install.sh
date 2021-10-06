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
		cp $file "$dest_dir" \
		&& echo $dest_dir/$(basename $file)
	done
done

if $use_bash; then
	rm -f "$BASH_COMP_DIR"/kianidraw
	cp kianidraw.bash "$BASH_COMP_DIR"/kianidraw \
	&& echo $BASH_COMP_DIR/kianidraw
fi
