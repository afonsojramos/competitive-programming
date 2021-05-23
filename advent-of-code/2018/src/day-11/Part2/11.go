package main

import (
	"fmt"
	"utils"
)

const serial int = 7689
const gridSize int = 300

func getPowerLevel(x, y int) int {
	powerLevel := utils.GetDigit(((x+10)*y+serial)*(x+10), 3) - 5
	return powerLevel
}

func main() {
	grid := make([][]int, gridSize)
	for i := 0; i < len(grid); i++ {
		grid[i] = make([]int, gridSize)
	}

	for x := 0; x < len(grid); x++ {
		for y := 0; y < len(grid); y++ {
			grid[x][y] = getPowerLevel(x, y)
		}
	}

	largestPower := 0
	largestPowerX := 0
	largestPowerY := 0
	largestSquareSize := 0

	for squareSize := 0; squareSize < gridSize; squareSize++ {
		fmt.Println(squareSize)
		for x := 0; x < len(grid)-squareSize+1; x++ {
			for y := 0; y < len(grid)-squareSize+1; y++ {
				squarePower := 0
				for xof := 0; xof < squareSize; xof++ {
					for yof := 0; yof < squareSize; yof++ {
						squarePower = squarePower + grid[x+xof][y+yof]
					}
				}
				if squarePower > largestPower {
					largestPower = squarePower
					largestPowerX = x
					largestPowerY = y
					largestSquareSize = squareSize
				}
			}
		}
	}

	fmt.Println(largestPower, largestPowerX, largestPowerY, largestSquareSize)
}
