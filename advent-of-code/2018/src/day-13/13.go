package main

import (
	"fmt"
	"utils"
)

var left, up, right, down = 0, 1, 2, 3

type cart struct {
	x, y, dir, turn int
}

var carts []cart

func (c *cart) move() {
	switch c.dir {
	case left:
		c.x--
	case up:
		c.y--
	case right:
		c.x++
	case down:
		c.y++
	}
}

func (c *cart) tick(grid [][]byte) {
	c.move()

	switch grid[c.y][c.x] {
	case '+':
		switch c.turn % 3 {
		case 0:
			c.dir--
			if c.dir < 0 {
				c.dir += 4
			}
		case 2:
			c.dir++
			if c.dir > 3 {
				c.dir -= 4
			}
		}
		c.turn++
	case '\\':
		switch c.dir {
		case left:
			c.dir = up
		case up:
			c.dir = left
		case right:
			c.dir = down
		case down:
			c.dir = right
		}
	case '/':
		switch c.dir {
		case left:
			c.dir = down
		case up:
			c.dir = right
		case right:
			c.dir = up
		case down:
			c.dir = left
		}
	}
}

func main() {
	// Part 1
	lines := utils.ReadLines("day-13/13.input")
	grid := make([][]byte, len(lines))
	for i := range grid {
		grid[i] = []byte(lines[i])
	}

	for y, line := range grid {
		for x, char := range line {
			switch char {
			case '<':
				carts = append(carts, cart{x, y, left, 0})
			case '^':
				carts = append(carts, cart{x, y, up, 0})
			case '>':
				carts = append(carts, cart{x, y, right, 0})
			case 'v':
				carts = append(carts, cart{x, y, down, 0})
			}
		}
	}

	fmt.Print(len(carts))
	crashX, crashY := 0, 0

	for len(carts) != 1 {
		crashed := make([]bool, len(carts))
		for i := range carts {
			fmt.Println(carts[i], i)
			carts[i].tick(grid)

			for j, c := range carts {
				if carts[i].x == c.x && carts[i].y == c.y && i != j {
					if crashed[i] || crashed[j] { // Already crashed
						continue
					}
					crashed[i] = true
					crashed[j] = true

					if crashX == 0 || crashY == 0 { // First crash for Part 1
						crashX, crashY = c.x, c.y
					}
				}
			}
		}

		// Remove crashed for Part 2
		removeCrashed := carts[:0]
		for i, c := range carts {
			if !crashed[i] {
				removeCrashed = append(removeCrashed, c)
			}
		}
		carts = removeCrashed
	}

	// Part 1
	fmt.Printf("%d,%d\n", crashX, crashY)

	// Part 2
	fmt.Printf("%d,%d\n", carts[0].x, carts[0].y)
}
