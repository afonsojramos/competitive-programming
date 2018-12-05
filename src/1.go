package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func readLines(path string) ([]string, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines, scanner.Err()
}

func atoi(s string) int {
	i, err := strconv.Atoi(s)
	check(err)
	return i
}

func intList(s []string) []int {
	ints := make([]int, len(s))
	for i, n := range s {
		ints[i] = atoi(n)
	}
	return ints
}

func intSum(xs []int) int {
	sum := 0
	for _, x := range xs {
		sum += x
	}
	return sum
}

func main() {
	dat, err := readLines("1.input")
	check(err)
	nums := intList(dat)
	fmt.Println(intSum(nums))
}
