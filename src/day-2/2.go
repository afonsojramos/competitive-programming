package main

import (
	"fmt"
	"utils"
)

func main() {
	dat := utils.ReadLines("day-2/2.input")
	var doubles, triples int

	for _, line := range dat {
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
}
