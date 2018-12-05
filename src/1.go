package main

import (
	"fmt"

	"github.com/afonsojramos/advent-of-code-2018/src/utils"
)

func main() {
	// Part 1
	dat := utils.ReadLines("1.input")
	nums := utils.IntList(dat)
	fmt.Println(utils.IntSum(nums))

	// Part 2
	sum := 0
	sums := map[int]int{0: 1}
	for i := 0; ; i = (i + 1) % len(nums) {
		sum += nums[i]
		sums[sum]++
		if sums[sum] == 2 {
			fmt.Println(sum)
			break
		}
	}
}
