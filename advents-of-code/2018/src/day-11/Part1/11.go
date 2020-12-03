package main

import (
	"fmt"
	"utils"
)

const serial int = 7689

func getPowerLevel(x, y int) int {
	powerLevel := utils.GetDigit(((x+10)*y+serial)*(x+10), 3) - 5
	return powerLevel
}

func main() {
	grid := make([][]int, 300)
	for i := 0; i < len(grid); i++ {
		grid[i] = make([]int, 300)
	}

	for x := 0; x < len(grid); x++ {
		for y := 0; y < len(grid); y++ {
			grid[x][y] = getPowerLevel(x, y)
		}
	}

	largestPower := 0
	largestPowerX := 0
	largestPowerY := 0

	for x := 0; x < len(grid)-2; x++ {
		for y := 0; y < len(grid)-2; y++ {
			squarePower := 0
			for xof := 0; xof < 3; xof++ {
				for yof := 0; yof < 3; yof++ {
					squarePower = squarePower + grid[x+xof][y+yof]
				}
			}
			if squarePower > largestPower {
				largestPower = squarePower
				largestPowerX = x
				largestPowerY = y
			}
		}
	}

	fmt.Println(largestPower, largestPowerX, largestPowerY)
}
