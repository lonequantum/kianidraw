/^[[:space:]]*$/ || «substr»($1, 1, 1) == "#" {next}

$1 != "ALIAS" {
	for (alias in aliases)
		gsub(alias, aliases[alias], $0)
}

$1 == "ALIAS" {
	aliases[$2] = $3
	next
}

$1 == "AT" {
	sub("%", "", $2)
	start_frame = TOTAL_FRAMES * $2/100 + 1
	next
}

$1 == "STACK" {
	$1 = ""
	gsub("[[:space:]]+", ",", $0)
	printf("%d\t%s", start_frame, «substr»($0, 2)) >> "stack"
	next
}

$1 ~ "[@]?(REFXY|NEWXY|NEW[XY]|XY|X|Y|ANGLE|SCALE[XY])" {
	path = $2".srt"
	if (system("test -f "path) != 0) {
		system("mkdir -p $(dirname "path")")
		i = TOTAL_FRAMES
		while (i--)
			print "0	0	0	1	1	0	0" >> path
	}
}
