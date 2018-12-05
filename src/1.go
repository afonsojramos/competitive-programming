package main

import (
	"fmt"
	"utils"
)

func main() {
	dat := utils.ReadLines("1.input")
	nums := utils.IntList(dat)
	fmt.Println(utils.IntSum(nums))
}
