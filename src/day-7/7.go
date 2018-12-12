package main

import (
	"fmt"
	"sort"
	"utils"
)

type runes []rune

func (s runes) Len() int {
	return len(s)
}

func (s runes) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}

func (s runes) Less(i, j int) bool {
	return s[i] < s[j]
}

func main() {
	lines := utils.ReadLines("day-7/7.input")
	requirements := make(map[rune][]rune)
	nTasks := make(map[rune]int)

	for _, line := range lines {
		taskFather := rune(line[5])
		taskSon := rune(line[36])
		requirements[taskFather] = append(requirements[taskFather], taskSon)
		nTasks[taskSon] = nTasks[taskSon] + 1
	}

	done := make([]rune, 0)

	for taskID := range requirements {
		if nTasks[taskID] == 0 {
			done = append(done, taskID)
		}
	}

	order := ""
	for len(done) > 0 {
		temp := make([]rune, len(done))
		copy(temp, done)
		sort.Sort(runes(temp))
		todo := temp[0]
		for i := 0; i < len(done); i++ {
			if done[i] == todo {
				done = append(done[:i], done[i+1:]...)
			}
		}
		order = order + string(todo)
		for _, nextRequirement := range requirements[todo] {
			nTasks[nextRequirement] = nTasks[nextRequirement] - 1
			if nTasks[nextRequirement] == 0 {
				done = append(done, nextRequirement)
			}
		}
	}
	fmt.Println(order)
}
