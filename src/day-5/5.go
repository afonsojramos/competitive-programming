package main

import (
	"bytes"
	"fmt"
	"utils"
)

const capDist = 'a' - 'A'
const aCode = 'A'
const zCode = 'Z'

func reactPoly(chars []byte) []byte {
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

	return chars
}

func main() {
	// Part 1
	line := utils.ReadLines("day-5/5.input")
	chars := []byte(line[0])
	fmt.Println(len(reactPoly(chars)))

	// Part 2
	min := 100000000000000
	for charCode := aCode; charCode < zCode+1; charCode++ {
		newChars := []byte(line[0])
		newChars = bytes.Replace(newChars, []byte{byte(charCode)}, nil, -1)
		newChars = bytes.Replace(newChars, []byte{byte(charCode + capDist)}, nil, -1)

		if x := len(reactPoly(newChars)); x < min {
			min = x
		}
	}
	fmt.Println(min)
}
