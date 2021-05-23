package main

import (
	"fmt"
	"strconv"
	"time"
)

const ITERATIONS = 793031

func part1() {
	recipies := []int{3, 7}

	elf1 := 0
	elf2 := 1

	for i := 0; i < ITERATIONS+10; i++ {
		newRecipies := recipies[elf1] + recipies[elf2]
		temp := strconv.Itoa(newRecipies)
		for _, v := range temp {
			recipies = append(recipies, int(v-48))
		}

		elf1 = (elf1 + 1 + recipies[elf1]) % len(recipies)
		elf2 = (elf2 + 1 + recipies[elf2]) % len(recipies)

	}

	fmt.Println(recipies[ITERATIONS : ITERATIONS+10])
}

func part2() {
	recipies := []int{3, 7}
	SEQUENCE := []int{7, 9, 3, 0, 3, 1}

	elf1 := 0
	elf2 := 1
	foundSequence := false
	for !foundSequence {
		newRecipies := recipies[elf1] + recipies[elf2]
		temp := strconv.Itoa(newRecipies)
		for _, v := range temp {
			recipies = append(recipies, int(v-48))
		}

		elf1 = (elf1 + 1 + recipies[elf1]) % len(recipies)
		elf2 = (elf2 + 1 + recipies[elf2]) % len(recipies)

		if len(recipies)-len(SEQUENCE) > 0 {
			if testEq(recipies[len(recipies)-len(SEQUENCE):], SEQUENCE) {
				fmt.Println(len(recipies) - len(SEQUENCE))
				foundSequence = true
			} else if testEq(recipies[len(recipies)-len(SEQUENCE)-1:len(recipies)-1], SEQUENCE) {
				fmt.Println(len(recipies) - len(SEQUENCE) - 1)
				foundSequence = true
			}
		}
	}
}

func testEq(a, b []int) bool {

	// If one is nil, the other must also be nil.
	if (a == nil) != (b == nil) {
		return false
	}

	if len(a) != len(b) {
		return false
	}

	for i := range a {
		if a[i] != b[i] {
			return false
		}
	}

	return true
}

func main() {
	t0 := time.Now()
	part1()
	t1 := time.Now()
	fmt.Println(t1.Sub(t0))
	part2()
	t2 := time.Now()
	fmt.Println(t2.Sub(t1))
	fmt.Println()
}
