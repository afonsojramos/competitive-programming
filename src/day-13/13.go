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

	switch grid[c.x][c.y] {
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
	fmt.Println("hwllo")

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

	for crashX == 0 && crashY == 0 {
		for i := 0; i < len(carts); i++ {
			fmt.Println(carts[i], i)
			carts[i].tick(grid)
			/* for j := i; j < len(carts); j++ {
				if carts[i].x == carts[j].x && carts[i].y == carts[j].y {
					crashX, crashY = carts[i].x, carts[i].y
					fmt.Println("whut")
					break
				}
			} */
		}
	}
}
