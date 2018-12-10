package main

import (
	"fmt"
	"utils"
)

const capDist = 'a' - 'A'

func main() {
	// Part 1
	line := utils.ReadLines("day-5/5.input")
	chars := []byte(line[0])
	changes := true

	for changes {
		changes = false
		for i := 0; i < len(chars)-1; i++ {
			if utils.Abs(int(chars[i])-int(chars[i+1])) == capDist {
				chars = append(chars[:i], chars[i+2:]...)
				changes = true
			}
		}
	}

	fmt.Println(len(chars))
}
