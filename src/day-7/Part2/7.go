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

	ElfsTasks := []rune{'.', '.', '.', '.', '.'}
	ElfsTaskTimeLeft := []int{0, 0, 0, 0, 0}
	order := ""
	t := 0
	workingElfs := 1

	for ; workingElfs > 0; t++ {
		workingElfs = 0

		for n := range ElfsTaskTimeLeft {
			if ElfsTaskTimeLeft[n] != 0 {
				ElfsTaskTimeLeft[n] = ElfsTaskTimeLeft[n] - 1
				workingElfs = workingElfs + 1
			} else {
				if ElfsTasks[n] != '.' {
					finishedTask := ElfsTasks[n]
					ElfsTasks[n] = '.'

					for _, v := range requirements[finishedTask] {
						nTasks[v] = nTasks[v] - 1
						if nTasks[v] == 0 {
							done = append(done, v)
						}
					}
				}
			}
		}
		for len(done) > 0 && workingElfs < len(ElfsTaskTimeLeft) {
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
			for n := range ElfsTaskTimeLeft {
				if ElfsTasks[n] == '.' {
					ElfsTasks[n] = todo
					fmt.Println(int(todo)-5, string(todo))
					ElfsTaskTimeLeft[n] = int(todo) - 5
					workingElfs = workingElfs + 1
					break
				}
			}
		}
	}
	fmt.Println(order, t-1)
}
