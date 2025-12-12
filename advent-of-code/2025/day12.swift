import Foundation

let input = try! String(contentsOfFile: "advent-of-code/2025/day-12.txt", encoding: .utf8)
    .trimmingCharacters(in: .whitespacesAndNewlines)

// Parse shapes - each shape is a list of (row, col) offsets
struct Shape {
    let cells: [(Int, Int)]  // (row, col) offsets from top-left
    let width: Int
    let height: Int
}

func parseShape(_ lines: [String]) -> Shape {
    var cells: [(Int, Int)] = []
    for (r, line) in lines.enumerated() {
        for (c, ch) in line.enumerated() {
            if ch == "#" {
                cells.append((r, c))
            }
        }
    }
    let height = lines.count
    let width = lines.map { $0.count }.max() ?? 0
    return Shape(cells: cells, width: width, height: height)
}

// Generate all rotations and flips of a shape
func allOrientations(of shape: Shape) -> [[(Int, Int)]] {
    var orientations: Set<String> = []
    var result: [[(Int, Int)]] = []

    var cells = shape.cells

    for _ in 0..<4 {  // 4 rotations
        for flip in 0..<2 {  // original and flipped
            var current = cells
            if flip == 1 {
                // Flip horizontally
                current = current.map { (-$0.0, $0.1) }
            }

            // Normalize: shift to have minimum at (0, 0)
            let minR = current.map { $0.0 }.min()!
            let minC = current.map { $0.1 }.min()!
            current = current.map { ($0.0 - minR, $0.1 - minC) }
            current.sort { $0.0 == $1.0 ? $0.1 < $1.1 : $0.0 < $1.0 }

            let key = current.map { "\($0.0),\($0.1)" }.joined(separator: ";")
            if !orientations.contains(key) {
                orientations.insert(key)
                result.append(current)
            }
        }
        // Rotate 90 degrees clockwise: (r, c) -> (c, -r)
        cells = cells.map { ($0.1, -$0.0) }
    }

    return result
}

// Parse input
let lines = input.split(separator: "\n", omittingEmptySubsequences: false).map { String($0) }

var shapes: [Shape] = []
var shapeOrientations: [[[(Int, Int)]]] = []

// Parse shapes (6 shapes, each is "N:" followed by 3 lines)
var lineIdx = 0
for _ in 0..<6 {
    // Skip the "N:" line
    lineIdx += 1
    // Read 3 lines of shape
    let shapeLines = [lines[lineIdx], lines[lineIdx + 1], lines[lineIdx + 2]]
    lineIdx += 3
    // Skip empty line
    lineIdx += 1

    let shape = parseShape(shapeLines)
    shapes.append(shape)
    shapeOrientations.append(allOrientations(of: shape))
}

// Parse regions (remaining lines)
struct Region {
    let width: Int
    let height: Int
    let counts: [Int]  // count of each shape needed
}

var regions: [Region] = []
while lineIdx < lines.count {
    let line = lines[lineIdx].trimmingCharacters(in: .whitespaces)
    lineIdx += 1
    if line.isEmpty { continue }

    // Format: "37x43: 28 31 34 28 24 23"
    let parts = line.split(separator: ":")
    let dims = parts[0].split(separator: "x")
    let width = Int(dims[0])!
    let height = Int(dims[1])!
    let counts = parts[1].trimmingCharacters(in: .whitespaces).split(separator: " ").map { Int($0)! }
    regions.append(Region(width: width, height: height, counts: counts))
}

// Part 1: Count regions where total shape cells fit within region area
var part1 = 0
for region in regions {
    var totalCells = 0
    for (i, count) in region.counts.enumerated() {
        totalCells += count * shapes[i].cells.count
    }
    if totalCells <= region.width * region.height {
        part1 += 1
    }
}

print("Part 1: \(part1)")
