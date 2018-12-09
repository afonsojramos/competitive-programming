package utils

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

// Check panics if error is nil
func Check(e error) {
	if e != nil {
		panic(e)
	}
}

// ReadLines reads a file and creates an array of strings with it
func ReadLines(path string) []string {
	file, err := os.Open(path)
	Check(err)
	defer file.Close()

	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	Check(scanner.Err())
	return lines
}

// Atoi is just a function that panics upon failure of strconv.Atoi.
func Atoi(s string) int {
	i, err := strconv.Atoi(s)
	Check(err)
	return i
}

// IntList converts an array of strings into an array of ints
func IntList(s []string) []int {
	ints := make([]int, len(s))
	for i, n := range s {
		ints[i] = Atoi(n)
	}
	return ints
}

// IntSum adds all the ints in an array of ints and returns its sum
func IntSum(xs []int) int {
	sum := 0
	for _, x := range xs {
		sum += x
	}
	return sum
}

// CharCounts returns the count of each character in s.
func CharCounts(s string) map[rune]int {
	chars := make(map[rune]int)
	for _, c := range s {
		chars[c]++
	}
	return chars
}

// Sscanf is a passthrough for fmt.Sscanf that panics upon failure.
func Sscanf(str, format string, args ...interface{}) {
	_, err := fmt.Sscanf(str, format, args...)
	if err != nil {
		panic(err)
	}
}
