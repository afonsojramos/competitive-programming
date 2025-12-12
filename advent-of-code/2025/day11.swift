import Foundation

let input = try! String(contentsOfFile: "advent-of-code/2025/day-11.txt", encoding: .utf8)
    .trimmingCharacters(in: .whitespacesAndNewlines)

// Parse the graph
var graph: [String: [String]] = [:]

for line in input.split(separator: "\n") {
    let parts = line.split(separator: ":")
    let source = String(parts[0])
    let destinations = parts[1].split(separator: " ").map { String($0) }
    graph[source] = destinations
}

// Part 1: Count all paths from "you" to "out"
// Use memoization with DFS
var memo: [String: Int] = [:]

func countPaths(from node: String) -> Int {
    if node == "out" {
        return 1
    }

    if let cached = memo[node] {
        return cached
    }

    guard let neighbors = graph[node] else {
        return 0
    }

    var total = 0
    for next in neighbors {
        total += countPaths(from: next)
    }

    memo[node] = total
    return total
}

let part1 = countPaths(from: "you")
print("Part 1: \(part1)")

// Part 2: Count paths from "svr" to "out" that pass through BOTH "dac" and "fft"
// State: (node, visitedDac, visitedFft) - 4 combinations per node
var memo2: [String: [Int]] = [:]  // node -> [neither, onlyDac, onlyFft, both]

func countPathsWithRequired(from node: String) -> [Int] {
    if node == "out" {
        // At "out", only the path counts if we're in the final state
        // Return [1,1,1,1] - meaning: 1 way to reach out in each state
        return [1, 1, 1, 1]
    }

    if let cached = memo2[node] {
        return cached
    }

    guard let neighbors = graph[node] else {
        return [0, 0, 0, 0]
    }

    // Aggregate from all neighbors
    var totals = [0, 0, 0, 0]  // [neither, onlyDac, onlyFft, both]
    for next in neighbors {
        let childCounts = countPathsWithRequired(from: next)
        for i in 0..<4 {
            totals[i] += childCounts[i]
        }
    }

    memo2[node] = totals
    return totals
}

// Start from "svr" in state "neither" (0)
// When we hit "dac", transition: neither->onlyDac, onlyFft->both
// When we hit "fft", transition: neither->onlyFft, onlyDac->both

// Actually, we need to account for transitions at dac and fft nodes themselves
// Let me reconsider: memoize (node, state) where state = {visitedDac, visitedFft}

var memo3: [[String]: Int] = [:]

func countPathsPart2(from node: String, hasDac: Bool, hasFft: Bool) -> Int {
    var hasDac = hasDac
    var hasFft = hasFft

    // Update state if we're at dac or fft
    if node == "dac" { hasDac = true }
    if node == "fft" { hasFft = true }

    if node == "out" {
        return (hasDac && hasFft) ? 1 : 0
    }

    let key = [node, hasDac ? "1" : "0", hasFft ? "1" : "0"]
    if let cached = memo3[key] {
        return cached
    }

    guard let neighbors = graph[node] else {
        memo3[key] = 0
        return 0
    }

    var total = 0
    for next in neighbors {
        total += countPathsPart2(from: next, hasDac: hasDac, hasFft: hasFft)
    }

    memo3[key] = total
    return total
}

let part2 = countPathsPart2(from: "svr", hasDac: false, hasFft: false)
print("Part 2: \(part2)")
