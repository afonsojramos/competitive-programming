import Foundation

func countAdjacent(_ grid: [[Character]], _ r: Int, _ c: Int) -> Int {
    let rows = grid.count
    let cols = grid[0].count
    var adjacent = 0
    for dr in -1...1 {
        for dc in -1...1 {
            if dr == 0 && dc == 0 { continue }
            let nr = r + dr
            let nc = c + dc
            if nr >= 0 && nr < rows && nc >= 0 && nc < cols && grid[nr][nc] == "@" {
                adjacent += 1
            }
        }
    }
    return adjacent
}

func solvePart1(_ input: String) -> Int {
    let grid = input.split(separator: "\n").map { Array($0) }
    let rows = grid.count
    let cols = grid[0].count

    var count = 0

    for r in 0..<rows {
        for c in 0..<cols {
            guard grid[r][c] == "@" else { continue }
            if countAdjacent(grid, r, c) < 4 {
                count += 1
            }
        }
    }

    return count
}

func solvePart2(_ input: String) -> Int {
    var grid = input.split(separator: "\n").map { Array($0) }
    let rows = grid.count
    let cols = grid[0].count

    var totalRemoved = 0

    while true {
        // Find all accessible rolls
        var toRemove: [(Int, Int)] = []

        for r in 0..<rows {
            for c in 0..<cols {
                guard grid[r][c] == "@" else { continue }
                if countAdjacent(grid, r, c) < 4 {
                    toRemove.append((r, c))
                }
            }
        }

        if toRemove.isEmpty { break }

        // Remove all accessible rolls
        for (r, c) in toRemove {
            grid[r][c] = "."
        }
        totalRemoved += toRemove.count
    }

    return totalRemoved
}

// Test with example
let example = """
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
"""

print("Example Part 1: \(solvePart1(example))") // Should be 13
print("Example Part 2: \(solvePart2(example))") // Should be 43

// Read actual input
let inputPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "input.txt"
if let input = try? String(contentsOfFile: inputPath, encoding: .utf8) {
    print("Part 1: \(solvePart1(input))")
    print("Part 2: \(solvePart2(input))")
}
