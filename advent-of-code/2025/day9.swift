import Foundation

func parseInput(_ input: String) -> [(Int, Int)] {
    var points: [(Int, Int)] = []
    let lines = input.split(separator: "\n")

    for line in lines {
        let lineStr = String(line).trimmingCharacters(in: .whitespaces)
        guard !lineStr.isEmpty else { continue }

        var coordPart = lineStr
        if let arrowRange = lineStr.range(of: "→") {
            coordPart = String(lineStr[arrowRange.upperBound...])
        }
        let coords = coordPart.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        if coords.count >= 2 {
            points.append((coords[0], coords[1]))
        }
    }

    return points
}

func solvePart1(_ input: String) -> Int {
    let points = parseInput(input)
    var maxArea = 0
    let n = points.count

    for i in 0..<n {
        for j in (i+1)..<n {
            let dx = abs(points[i].0 - points[j].0) + 1
            let dy = abs(points[i].1 - points[j].1) + 1
            let area = dx * dy
            maxArea = max(maxArea, area)
        }
    }

    return maxArea
}

// For a given y, find the x-intervals that are inside or on the boundary
func getIntervalsAtY(_ y: Int, redTiles: [(Int, Int)]) -> [(Int, Int)] {
    let n = redTiles.count

    // For scanline at y, we count crossings properly
    // A vertical edge contributes to crossing count if it spans across y (not just touches)
    // A horizontal edge at y adds its interval to the result

    var xCrossings: [Int] = []
    var horizontalIntervals: [(Int, Int)] = []

    for i in 0..<n {
        let j = (i + 1) % n
        let (x1, y1) = redTiles[i]
        let (x2, y2) = redTiles[j]

        if x1 == x2 {
            // Vertical edge
            let minY = min(y1, y2)
            let maxY = max(y1, y2)

            // Count as crossing if y is strictly between endpoints
            // OR count as crossing if y equals one endpoint (use lower endpoint rule)
            if y > minY && y <= maxY {
                xCrossings.append(x1)
            }
        } else if y1 == y2 && y1 == y {
            // Horizontal edge at exactly this y
            horizontalIntervals.append((min(x1, x2), max(x1, x2)))
        }
    }

    // Sort crossings
    xCrossings.sort()

    // Pair up crossings for interior (even-odd rule)
    var intervals: [(Int, Int)] = []
    var i = 0
    while i + 1 < xCrossings.count {
        intervals.append((xCrossings[i], xCrossings[i+1]))
        i += 2
    }

    // Add horizontal intervals
    intervals.append(contentsOf: horizontalIntervals)

    // Merge overlapping intervals
    intervals.sort { $0.0 < $1.0 }
    var merged: [(Int, Int)] = []
    for interval in intervals {
        if merged.isEmpty {
            merged.append(interval)
        } else {
            let last = merged[merged.count - 1]
            if interval.0 <= last.1 + 1 {
                merged[merged.count - 1] = (last.0, max(last.1, interval.1))
            } else {
                merged.append(interval)
            }
        }
    }

    return merged
}

// Check if interval [x1, x2] is fully contained in any of the given intervals
func intervalContained(_ x1: Int, _ x2: Int, in intervals: [(Int, Int)]) -> Bool {
    for (a, b) in intervals {
        if x1 >= a && x2 <= b {
            return true
        }
    }
    return false
}

func solvePart2(_ input: String) -> Int {
    let redTiles = parseInput(input)
    let n = redTiles.count

    // Get all unique y values
    var allY = Set<Int>()
    for i in 0..<n {
        let j = (i + 1) % n
        let y1 = redTiles[i].1
        let y2 = redTiles[j].1

        let minY = min(y1, y2)
        let maxY = max(y1, y2)
        for y in minY...maxY {
            allY.insert(y)
        }
    }

    // Precompute intervals for all y values
    var yIntervals: [Int: [(Int, Int)]] = [:]
    for y in allY {
        yIntervals[y] = getIntervalsAtY(y, redTiles: redTiles)
    }

    var maxArea = 0

    for i in 0..<n {
        for j in (i+1)..<n {
            let (x1, y1) = redTiles[i]
            let (x2, y2) = redTiles[j]

            let xMin = min(x1, x2)
            let xMax = max(x1, x2)
            let yMin = min(y1, y2)
            let yMax = max(y1, y2)

            // Check if rectangle is valid at all y levels
            var valid = true
            for y in allY where y >= yMin && y <= yMax {
                if let intervals = yIntervals[y] {
                    if !intervalContained(xMin, xMax, in: intervals) {
                        valid = false
                        break
                    }
                } else {
                    valid = false
                    break
                }
            }

            if valid {
                let area = (xMax - xMin + 1) * (yMax - yMin + 1)
                maxArea = max(maxArea, area)
            }
        }
    }

    return maxArea
}

// Test with example
let example = """
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
"""

print("Example Part 1: \(solvePart1(example))") // Should be 50
print("Example Part 2: \(solvePart2(example))") // Should be 24

// Read actual input
let inputPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "day-09.txt"
if let input = try? String(contentsOfFile: inputPath, encoding: .utf8) {
    print("Part 1: \(solvePart1(input))")
    print("Part 2: \(solvePart2(input))")
}
