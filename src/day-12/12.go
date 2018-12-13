package main

import (
	"fmt"
	"utils"
)

func getPlants(pots string, index int) string {
	if index == -1 {
		return "..." + string(pots[0]) + string(pots[1])
	} else if index == 0 {
		return ".." + string(pots[0]) + string(pots[1]) + string(pots[2])
	} else if index == 1 {
		return "." + string(pots[0]) + string(pots[1]) + string(pots[2]) + string(pots[3])
	} else if index == len(pots)-2 {
		return string(pots[index-2]) + string(pots[index-1]) + string(pots[index]) + string(pots[index+1]) + "."
	} else if index == len(pots)-1 {
		return string(pots[index-2]) + string(pots[index-1]) + string(pots[index]) + ".."
	} else if index == len(pots) {
		return string(pots[index-2]) + string(pots[index-1]) + "..."
	} else {
		return string(pots[index-2]) + string(pots[index-1]) + string(pots[index]) + string(pots[index+1]) + string(pots[index+2])
	}
}

func main() {
	// Part 1
	lines := utils.ReadLines("day-12/12.input")

	pots := utils.RegSplit(lines[0], ": ")[1]
	rules := make(map[string]string)
	for i := 2; i < len(lines); i++ {
		split := utils.RegSplit(lines[i], "[ =>]+")
		rules[split[0]] = split[1]
	}

	leftIncrease := 0
	sum := 0
	for t := 0; t < 1000; t++ {
		newPots := ""
		for i := -1; i < len(pots)+1; i++ {
			if rule, ok := rules[getPlants(pots, i)]; ok {
				newPots = newPots + rule
				if i == -1 {
					leftIncrease = leftIncrease + 1
				}
			} else {
				if i != -1 && i != len(pots)+1 {
					newPots = newPots + "."
				}
			}
		}
		pots = newPots
		sum = 0
		for i, pot := range pots {
			if string(pot) == "#" {
				sum = sum + i - leftIncrease
			}
		}
		fmt.Println("Generation ->", t, " Sum =", sum)
		//fmt.Println(sum)
	}

	fmt.Println("Sum of last Generation", sum)
	// Part 2
	/*
		For part 2 I was rather lost and saw that it was completely out of the realm of possibility to
		calculate that many generations. So I generated the first 1000 generations, exported to an Excel
		document and calculated the increment for each line.
		Surprise surprise! Starting at Generation 96 the increment kept at 91, so, to facilitate the equation,
		I took the Generation 100 Sum, and added it with 91 * 49999999900.
	*/
}
