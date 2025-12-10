import Foundation

func solvePart1(_ input: String) -> Int {
    let parts = input.components(separatedBy: "\n\n")
    let rangeLines = parts[0].split(separator: "\n")
    let idLines = parts[1].split(separator: "\n")

    // Parse ranges
    var ranges: [(Int, Int)] = []
    for line in rangeLines {
        let nums = line.split(separator: "-")
        let start = Int(nums[0])!
        let end = Int(nums[1])!
        ranges.append((start, end))
    }

    // Check each ingredient ID
    var freshCount = 0
    for line in idLines {
        guard !line.isEmpty else { continue }
        let id = Int(line)!

        // Check if ID is in any range
        for (start, end) in ranges {
            if id >= start && id <= end {
                freshCount += 1
                break
            }
        }
    }

    return freshCount
}

func solvePart2(_ input: String) -> Int {
    let parts = input.components(separatedBy: "\n\n")
    let rangeLines = parts[0].split(separator: "\n")

    // Parse ranges
    var ranges: [(Int, Int)] = []
    for line in rangeLines {
        let nums = line.split(separator: "-")
        let start = Int(nums[0])!
        let end = Int(nums[1])!
        ranges.append((start, end))
    }

    // Sort ranges by start
    ranges.sort { $0.0 < $1.0 }

    // Merge overlapping ranges
    var merged: [(Int, Int)] = []
    for range in ranges {
        if merged.isEmpty {
            merged.append(range)
        } else {
            let last = merged[merged.count - 1]
            // Check if overlapping or adjacent (end >= start - 1)
            if range.0 <= last.1 + 1 {
                merged[merged.count - 1] = (last.0, max(last.1, range.1))
            } else {
                merged.append(range)
            }
        }
    }

    // Sum up all IDs in merged ranges
    var total = 0
    for (start, end) in merged {
        total += end - start + 1
    }

    return total
}

// Test with example
let example = """
3-5
10-14
16-20
12-18

1
5
8
11
17
32
"""

print("Example Part 1: \(solvePart1(example))") // Should be 3
print("Example Part 2: \(solvePart2(example))") // Should be 14

// Read actual input
let inputPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "input.txt"
if let input = try? String(contentsOfFile: inputPath, encoding: .utf8) {
    print("Part 1: \(solvePart1(input))")
    print("Part 2: \(solvePart2(input))")
}
