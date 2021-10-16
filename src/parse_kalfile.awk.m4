BEGIN {
	DEFAULT_SET = "0	0	0	1	1	0	0"
	COMP_INDEXES["X"]      = 1
	COMP_INDEXES["Y"]      = 2
	COMP_INDEXES["ANGLE"]  = 3
	COMP_INDEXES["SCALEX"] = 4
	COMP_INDEXES["SCALEY"] = 5
	COMP_INDEXES["NEWX"]   = 6
	COMP_INDEXES["NEWY"]   = 7
	for (name in COMP_INDEXES)
		COMPONENTS = COMPONENTS""(++i == 1 ? "" : "|" )""name

	frame = 1
}

function yield (command, restart) {
	if (restart != "")
		close(command)
	(command) | getline result
	return result
}

function _save (len_to_save, what) {
	tmp_file = path".tmp"

	system("awk \x27NR < "frame"\x27 "path" > "tmp_file)
	for (i = 0; i < len_to_save; i++)
		print to_save[i] >> tmp_file
	system("awk \x27NR >= "(frame + len_to_save)"\x27 "path" >> "tmp_file)

	close(tmp_file)
	system("mv -f "tmp_file" "path)
	print item", "what", frames "frame" to "(frame + len_to_save - 1)
}

function _get_set (line_number) {
	return yield("awk -v OFS=\x27\t\x27 \x27NR == "line_number"\x27 "path, 1)
}

function make_set (what, from) {
	if (from == "")
		from = DEFAULT_SET
	return yield("echo \""from"\" | awk -v OFS=\x27\t\x27 \x27{"what"; print $0}\x27", 1)
}

function percent_to_frame (percent) {
	gsub(/[^0-9.-]/, "", percent)
	percent = int(percent)
	if (percent < 0 || percent > 100) {
		print "line "NR": error: "percent": invalid percentage"
		exit 1
	}

	return int(TOTAL_FRAMES * percent/100) + 1
}

/^[[:space:]]*$/ || «substr»($1, 1, 1) == "#" {
	next
}

{
	for (alias in aliases)
		gsub(alias, aliases[alias], $0)
}

$1 == "ALIAS" {
	aliases[$2] = $3
	next
}

$1 == "AT" {
	frame = percent_to_frame($2)
	next
}

$1 == "ITEM" {
	item = $2
	path = $2".srt"

	if (system("test -f "path) != 0) {
		system("mkdir -p $(dirname "path"); > "path)
		i = TOTAL_FRAMES
		while (i-- >= 0)
			print DEFAULT_SET >> path
		close(path)
	}

	next
}

$1 == "STACK" {
	$1 = ""
	gsub("[[:space:]]+", ",", $0)
	printf("%d\t%s", frame, «substr»($0, 2)) >> "stack"
	next
}

$1 ~ "^("COMPONENTS")(=("COMPONENTS"))*$" {
	if (item == "") {
		print "line "NR": error: no ITEM defined"
		exit 1
	}

	split($0, tmp, "\"")
	if (tmp[3] !~ "^[[:space:]]*$") {
		n = percent_to_frame(tmp[3]) - frame + 1
		if (n < 1) {
			print "line "NR": error: cannot define values towards the past"
			exit 1
		}
	} else
		n = TOTAL_FRAMES - frame + 2

	sav1 = $1
	for (name in COMP_INDEXES)
		sub(name, "$"COMP_INDEXES[name] , $1)

	for (i = 0; i < n; i++) {
		value = yield("mvalues "tmp[2]" "n, (i == 0 ? 1 : ""))
		to_save[i] = make_set($1"="value, _get_set(frame + i))
	}
	_save(n, sav1)

	next
}

{
	print "line "NR": warning: \""$1"\": unknown command or component"
}
