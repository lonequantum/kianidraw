BEGIN {
	DEFAULT_SET = "0	0	1	1	0	0	0"
	COMP_INDEXES["X"]      = 1
	COMP_INDEXES["Y"]      = 2
	COMP_INDEXES["SCALEX"] = 3
	COMP_INDEXES["SCALEY"] = 4
	COMP_INDEXES["ANGLE"]  = 5
	COMP_INDEXES["NEWX"]   = 6
	COMP_INDEXES["NEWY"]   = 7
	for (name in COMP_INDEXES)
		COMPONENTS = COMPONENTS""(++i == 1 ? "" : "|" )""name

	Frame = 1
}


function yield (command, restart) {
	if (restart != "")
		close(command)

	(command) | getline result

	return result
}


function Save (len_to_save, components, command) {
	tmp_file = Path".tmp"

	system("awk \x27NR < "Frame"\x27 "Path" > "tmp_file)

	for (i = 0; i < len_to_save; i++)
		print To_save[i] >> tmp_file

	system("awk \x27NR >= "(Frame + len_to_save)"\x27 "Path" >> "tmp_file)

	close(tmp_file)
	system("mv -f "tmp_file" "Path)

	print Item", "components", "command", frames "Frame" to "(Frame + len_to_save - 1)
}


function Get_set (line_number) {
	return yield("awk -v OFS=\x27\t\x27 \x27NR == "line_number"\x27 "Path, 1)
}


function make_set (changes, from) {
	if (from == "")
		from = DEFAULT_SET

	return yield("echo \""from"\" | awk -v OFS=\x27\t\x27 \x27{"changes"; print $0}\x27", 1)
}


function percent_to_frame (percent) {
	gsub(/[^0-9.-]/, "", percent)
	percent = int(percent)

	if (percent < 0 || percent > 100) {
		print "line "NR": error: "percent": invalid percentage" > "/dev/stderr"
		exit 1
	}

	return int(TOTAL_FRAMES * percent/100) + 1
}


function Process_components () {
	if (Item == "") {
		print "line "NR": error: no ITEM defined" > "/dev/stderr"
		exit 1
	}

	split($0, tmp, "\"")
	if (tmp[3] !~ "^[[:space:]]*$") {
		n = percent_to_frame(tmp[3]) - Frame + 1
		if (n < 1) {
			print "line "NR": error: cannot define values towards the past" > "/dev/stderr"
			exit 1
		}
	} else
		n = TOTAL_FRAMES - Frame + 2

	sav1 = $1
	for (name in COMP_INDEXES)
		sub(name, "$"COMP_INDEXES[name] , $1)

	for (i = 0; i < n; i++) {
		value = yield("mvalues "tmp[2]" "n, (i == 0 ? 1 : ""))
		To_save[i] = make_set($1"="value, Get_set(Frame + i))
	}

	Save(n, sav1, tmp[2])
}


/^[[:space:]]*$/ || «substr»($1, 1, 1) == "#" {
	next
}


{
	for (alias in Aliases)
		gsub(alias, Aliases[alias], $0)
}


$1 == "ALIAS" {
	Aliases[$2] = $3

	next
}


$1 == "AT" {
	Frame = percent_to_frame($2)

	next
}


$1 == "ITEM" {
	Item = $2
	Path = $2".srt"

	if (system("test -f "Path) != 0) {
		system("mkdir -p $(dirname "Path"); > "Path)

		for (i = TOTAL_FRAMES; i >= 0; i--)
			print DEFAULT_SET >> Path

		close(Path)
	}

	next
}


$1 == "STACK" {
	$1 = ""
	gsub("[[:space:]]+", ",", $0)

	printf("%d\t%s\n", Frame, «substr»($0, 2)) >> "stack"

	next
}


$1 ~ "^("COMPONENTS")(=("COMPONENTS"))*$" {
	Process_components()

	next
}


$1 == "ORIGIN" {
	sav3 = $3

	$0 = "X=NEWX \"constant "$2"\""
	Process_components()
	$0 = "Y=NEWY \"constant "sav3"\""
	Process_components()

	next
}


$1 == "CENTER" {
	sav3 = $3

	$0 = "X \"constant "$2"\""
	Process_components()
	$0 = "Y \"constant "sav3"\""
	Process_components()

	next
}


$1 == "MOVETO" {
	sav3 = $3

	$0 = "NEWX \"constant "$2"\""
	Process_components()
	$0 = "NEWY \"constant "sav3"\""
	Process_components()

	next
}


{
	print "line "NR": warning: \""$1"\": unknown command or component" > "/dev/stderr"
}
