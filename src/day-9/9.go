package main

import "fmt"

const nPlayers = 448
const lastMarble = 71628 * 100

type marble struct {
	number int
	prev   *marble // Counter-Clockwise
	next   *marble // Clockwise
}

func removeMarble(mar *marble) *marble {
	mar.next.prev = mar.prev
	mar.prev.next = mar.next
	return mar
}

func insertAfter(mar *marble, number int) *marble {
	newMarble := &marble{number, mar, mar.next}
	mar.next.prev = newMarble
	mar.next = newMarble
	return newMarble
}

func main() {
	scores := make([]int, nPlayers)
	curr := &marble{0, nil, nil}
	curr.next = curr
	curr.prev = curr

	mar := 1
	for mar <= lastMarble {
		for nPlayer := 0; nPlayer < nPlayers && mar <= lastMarble; nPlayer++ {
			if mar%23 == 0 {
				scores[nPlayer] += mar                                           // MOD23 Case -> keeps marble & adds to score
				removed := removeMarble(curr.prev.prev.prev.prev.prev.prev.prev) // 7 marbles counter-clockwise removed
				scores[nPlayer] += removed.number                                // Adds removed marble to score
				curr = removed.next
			} else {
				curr = insertAfter(curr.next, mar)
			}
			mar++
		}
	}

	maxScore := 0
	for _, score := range scores {
		if score > maxScore {
			maxScore = score
		}
	}
	fmt.Println(maxScore)
}
