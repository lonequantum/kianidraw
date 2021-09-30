changequote(«,»)dnl
include(«common.m4»)dnl
#!/bin/sh
PROG_NAME=$(basename $0)
MSG_PREFIX="$PROG_NAME[$(basename "$(pwd)")]"
. /usr/local/lib/kianidraw-common

is_structure_ok || exit_bad_location "$PROG_NAME"

USAGE="Usage: $PROG_NAME resources/(all|<resourceName>)"

test -n "$1" || exit_bad_args "$USAGE"

class=$(expr "$1" : '\([^/]*\)')
name=$(expr "$1" : '[^/]*/\(.*\)' | sed 's/\//\\\//g')

convert_xcf_to_pngs() {
	_infile=$1
	_outfiles_dir=$2

	{
		cat <<END
def convert(infile, outfiles_dir):
	img = pdb.gimp_file_load(infile, infile)
	for layer in img.layers:
		outfile = outfiles_dir + "/" + layer.name + ".png"
		print(layer.name)
		pdb.gimp_file_save(img, layer, outfile, outfile)
	pdb.gimp_image_delete(img)
END
		echo "convert(\"$_infile\", \"$_outfiles_dir\")"
		echo "pdb.gimp_quit(1)"
	} | gimp -i --batch-interpreter=python-fu-eval -b -
}

process_resource() {
	_resource=$1

	echo "$MSG_PREFIX: processing elements for \"$_resource\" …"
	rm -f $INTERNAL_IN_D/$_resource.d/*.png
	convert_xcf_to_pngs $INTERNAL_IN_D/$_resource.d/$_resource.xcf $INTERNAL_IN_D/$_resource.d
}

case $class in
resources)
	test -n "$name" || exit_bad_args "$USAGE"

	test X"$name" = Xall && {
		kianidraw-get resources | while read r; do
			process_resource $r
		done
		exit
	}

	item_exists resources/"$name" \
	|| exit_error "$MSG_PREFIX: resources/\"$name\": not found"

	process_resource $name
	;;
*)
	exit_bad_args "$USAGE"
esac
