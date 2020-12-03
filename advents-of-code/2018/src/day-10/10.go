package main

import (
	"fmt"
	"os"
	"strconv"
	"utils"
)

var minX = make(map[int]int)
var minY = make(map[int]int)
var maxX = make(map[int]int)
var maxY = make(map[int]int)

func getDist(a, b []int, second int) int {
	distX := (a[0] + a[2]*second) - (b[0] + b[2]*second)
	distY := (a[1] + a[3]*second) - (b[1] + b[3]*second)
	return utils.Abs(distX) + utils.Abs(distY)
}

func main() {
	// Part 1
	lines := utils.ReadLines("day-10/10.input")
	points := make([][]int, len(lines))

	for i, line := range lines {
		split := utils.RegSplit(line, "[=< ,>]+")
		points[i] = []int{utils.Atoi(split[1]), utils.Atoi(split[2]), utils.Atoi(split[4]), utils.Atoi(split[5])}
	}

	lastDistance := getDist(points[0], points[1], 0)
	nextDistance := getDist(points[0], points[1], 1)
	second := 2
	for nextDistance < lastDistance {
		lastDistance = nextDistance
		nextDistance = getDist(points[0], points[1], second)
		second++
	}
	fmt.Println("Closest second:", second)
	/*
		Being close doesn't mean that it's the final position, but at least we know it should be close to it.
		For that reason, we will analyze some offsets
		In my case the offset was -3
	*/

	for offset := -5; offset < 5; offset++ {
		file, err := os.Create("day-10/result-offset" + strconv.Itoa(offset) + ".txt")
		utils.Check(err)
		defer file.Close()

		output := make([][]string, 1000)
		for y := 0; y < 1000; y++ {
			output[y] = make([]string, 1000)
			for x := 0; x < 1000; x++ {
				output[y][x] = " "
			}
		}

		minX[offset] = 1000
		minY[offset] = 1000
		maxX[offset] = 0
		maxY[offset] = 0

		for i := 0; i < len(points); i++ {
			output[points[i][0]+points[i][2]*(second+offset)][points[i][1]+points[i][3]*(second+offset)] = "#"
			if points[i][0]+points[i][2]*(second+offset) < minX[offset] {
				minX[offset] = points[i][0] + points[i][2]*(second+offset)
			}
			if points[i][1]+points[i][3]*(second+offset) < minY[offset] {
				minY[offset] = points[i][1] + points[i][3]*(second+offset)
			}
			if points[i][0]+points[i][2]*(second+offset) > maxX[offset] {
				maxX[offset] = points[i][0] + points[i][2]*(second+offset)
			}
			if points[i][1]+points[i][3]*(second+offset) > maxY[offset] {
				maxY[offset] = points[i][1] + points[i][3]*(second+offset)
			}
		}

		for y := minY[offset]; y <= maxY[offset]; y++ {
			line := ""
			for x := minX[offset]; x <= maxX[offset]; x++ {
				line = line + output[x][y]
			}
			fmt.Fprint(file, line, "\n")
		}
	}

	fmt.Println("Answer should be in one of the files now")
}
