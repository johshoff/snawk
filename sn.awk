function locate (x, y) {
	printf("\033[%d;%dH", y, x)
}

function set_map(x, y, chr) {
	locate(x, y)
	printf(chr)
	line[y] = substr(line[y], 1, x - 1) chr substr(line[y], x + 1, length(line[y]))

	# Debug: print whole level
	# printf("\033[2J")
	# locate(1, 1)
	# for (i = 1; i <= map_height; i = i + 1) {
	# 	print line[i]
	# }
}

function moved() {
	map_chr = substr(line[y], x, 1)
	set_map(x, y, "*")

	read_index = (write_index + max_length * 2 - len - 1) % max_length + 1
	if (xs[read_index] != -1) {
		set_map(xs[read_index], ys[read_index], " ")
	}

	locate(1, map_height + 1)

	xs[write_index] = x
	ys[write_index] = y

	write_index = write_index % max_length + 1

	if (map_chr == "*") {
		print "You ate yourself."
		exit
	}
	if (map_chr == "#") {
		print "You dead."
		exit
	}
	if (map_chr == "o") {
		len = len + 1
		if (len > max_length) {
			print "You ate too much, piggy."
			exit
		}

		while (1) {
			new_x = int(rand() * map_width) + 1
			new_y = int(rand() * map_height) + 1
			map_chr = substr(line[new_y], new_x, 1)
			if (map_chr == " ") {
				set_map(new_x, new_y, "o")
				locate(1, map_height + 1)
				break
			}
		}
	}
}

BEGIN {
	printf("\033[2J")
	locate(1, 1)
	len = 3
	max_length = 20
	for (i = 1; i <= max_length; i = i + 1) {
		xs[i] = -1
		ys[i] = -1
	}
	write_index = 2
}
FILENAME != "-" {
	print $0
	map_height = NR
	map_width = length($0)
	line[NR] = $0

	start_x = index($0, "*")
	if (start_x != 0) {
		x = start_x
		y = NR
		xs[1] = x
		ys[1] = y
	}
}
FILENAME == "-" && $0 == "k" { y = y - 1; moved() }
FILENAME == "-" && $0 == "j" { y = y + 1; moved() }
FILENAME == "-" && $0 == "h" { x = x - 1; moved() }
FILENAME == "-" && $0 == "l" { x = x + 1; moved() }
