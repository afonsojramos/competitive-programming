package main

import (
	"fmt"
	"utils"
)

func compareRest(line string, lines []string) (bool, string) {
	for _, nextline := range lines {
		diffs, index := 0, 0
		for i := range nextline {
			if line[i] != nextline[i] {
				diffs++
				index = i
			}
		}
		if diffs == 1 {
			fmt.Println(line, nextline)
			return true, line[:index] + line[index+1:]
		}
	}
	return false, ""
}

func main() {
	lines := utils.ReadLines("day-02/2.input")
	// Part 1
	var doubles, triples int
	for _, line := range lines {
		var twice, thrice bool
		for _, n := range utils.CharCounts(line) {
			twice = twice || n == 2
			thrice = thrice || n == 3
		}
		if twice {
			doubles++
		}
		if thrice {
			triples++
		}
	}
	fmt.Println(doubles * triples)

	// Part 2
	for i, line := range lines {
		if found, rest := compareRest(line, lines[i+1:]); found {
			fmt.Println(rest)
		}
	}
}
