import Foundation

func solvePart1(_ input: String) -> Int {
    let lines = input.split(separator: "\n").map { Array($0) }
    let rows = lines.count
    let cols = lines[0].count

    // Find S position
    var startCol = 0
    for (_, row) in lines.enumerated() {
        for (c, ch) in row.enumerated() {
            if ch == "S" {
                startCol = c
                break
            }
        }
    }

    // Track active beam columns (beams merge when at same position)
    var beamCols = Set<Int>([startCol])

    var splitCount = 0

    // Process row by row
    for r in 1..<rows {
        var newBeamCols = Set<Int>()

        for c in beamCols {
            if lines[r][c] == "^" {
                // Splitter: beam stops, emit left and right
                splitCount += 1
                if c > 0 {
                    newBeamCols.insert(c - 1)
                }
                if c < cols - 1 {
                    newBeamCols.insert(c + 1)
                }
            } else {
                // Continue downward
                newBeamCols.insert(c)
            }
        }

        beamCols = newBeamCols
    }

    return splitCount
}

func solvePart2(_ input: String) -> Int {
    let lines = input.split(separator: "\n").map { Array($0) }
    let rows = lines.count
    let cols = lines[0].count

    // Find S position
    var startCol = 0
    for (_, row) in lines.enumerated() {
        for (c, ch) in row.enumerated() {
            if ch == "S" {
                startCol = c
                break
            }
        }
    }

    // Track number of timelines at each column
    // timelines[col] = number of distinct timelines with particle at that column
    var timelines = [Int: Int]()
    timelines[startCol] = 1

    // Process row by row
    for r in 1..<rows {
        var newTimelines = [Int: Int]()

        for (c, count) in timelines {
            if lines[r][c] == "^" {
                // Splitter: timeline splits into two
                // count timelines each split into left and right
                if c > 0 {
                    newTimelines[c - 1, default: 0] += count
                }
                if c < cols - 1 {
                    newTimelines[c + 1, default: 0] += count
                }
            } else {
                // Continue downward
                newTimelines[c, default: 0] += count
            }
        }

        timelines = newTimelines
    }

    // Total timelines = sum of all timeline counts
    return timelines.values.reduce(0, +)
}

// Test with example
let example = """
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
"""

print("Example Part 1: \(solvePart1(example))") // Should be 21
print("Example Part 2: \(solvePart2(example))") // Should be 40

// Read actual input
let inputPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "input.txt"
if let input = try? String(contentsOfFile: inputPath, encoding: .utf8) {
    print("Part 1: \(solvePart1(input))")
    print("Part 2: \(solvePart2(input))")
}
