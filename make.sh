#!/bin/sh
./clean.sh

for dir in lib bin; do
	for file in src/$dir/kianidraw*; do
		command="m4 $file > $(echo $file | sed s/src/target/ | sed s/\.m4//)"
		echo $command
		eval $command
	done

	chmod 755 target/$dir/kianidraw*
done
