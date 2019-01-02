package main

import (
	"fmt"
	"utils"
)

type claim struct {
	id   int
	x, y int
	w, h int
}

func (c *claim) apply(grid [][]int) {
	for x := 0; x < c.w; x++ {
		for y := 0; y < c.h; y++ {
			grid[c.x+x][c.y+y]++
		}
	}
}

func (c *claim) overlap(grid [][]int) bool {
	for x := 0; x < c.w; x++ {
		for y := 0; y < c.h; y++ {
			if grid[c.x+x][c.y+y] > 1 {
				return true
			}
		}
	}
	return false
}

func main() {
	// Part 1
	var claims []claim
	dat := utils.ReadLines("day-03/3.input")
	for _, line := range dat {
		var c claim
		utils.Sscanf(line, "#%d @ %d,%d: %dx%d", &c.id, &c.x, &c.y, &c.w, &c.h)
		claims = append(claims, c)
	}

	grid := make([][]int, 1000)
	for i := range grid {
		grid[i] = make([]int, 1000)
	}

	for _, c := range claims {
		c.apply(grid)
	}

	n := 0
	for x := range grid {
		for _, c := range grid[x] {
			if c > 1 {
				n++
			}
		}
	}
	fmt.Println(n)

	// Part 2
	for _, c := range claims {
		if !c.overlap(grid) {
			fmt.Println(c.id)
		}
	}
}
