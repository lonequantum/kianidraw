BEGIN {
	total_frames = DURATION * FPS
}

function replace_aliases(line) {
	new = line
	for (alias in aliases)
		gsub(alias, aliases[alias], new)
	return new
}

/^[[:space:]]*$/ || «substr»($1, 1, 1) == "#" {next}

$1 != "ALIAS" {
	$0 = replace_aliases($0)
}

$1 == "ALIAS" {
	aliases[$2] = $3
}

$1 == "AT" {
	sub("%", "", $2)
	start_frame = total_frames * $2/100 + 1
}
