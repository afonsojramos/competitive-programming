import Foundation

func solvePart1(_ input: String) -> Int {
    let lines = input.split(separator: "\n").map(String.init)
    var position = 50
    var zeroCount = 0

    for line in lines {
        guard !line.isEmpty else { continue }

        let direction = line.first!
        let distance = Int(line.dropFirst())!

        if direction == "L" {
            position = (position - distance) % 100
            if position < 0 {
                position += 100
            }
        } else {
            position = (position + distance) % 100
        }

        if position == 0 {
            zeroCount += 1
        }
    }

    return zeroCount
}

func solvePart2(_ input: String) -> Int {
    let lines = input.split(separator: "\n").map(String.init)
    var position = 50
    var zeroCount = 0

    for line in lines {
        guard !line.isEmpty else { continue }

        let direction = line.first!
        let distance = Int(line.dropFirst())!

        // Count times we land on 0 during the rotation
        // We land on 0 at step k if (position ± k) mod 100 == 0

        if direction == "L" {
            // Moving left: we hit 0 when (position - k) mod 100 == 0
            // i.e., k mod 100 == position
            // For k in [1, distance]: k = position, position+100, position+200, ...
            if position == 0 {
                // k must be multiple of 100: k = 100, 200, ...
                zeroCount += distance / 100
            } else if position <= distance {
                // First hit at k=position, then every 100 steps
                zeroCount += (distance - position) / 100 + 1
            }
            // Update position
            position = ((position - distance) % 100 + 100) % 100
        } else {
            // Moving right: we hit 0 when (position + k) mod 100 == 0
            // i.e., k mod 100 == (100 - position) mod 100
            // For position > 0: first hit at k = 100 - position, then every 100 steps
            // For position == 0: first hit at k = 100, then every 100 steps
            let firstHit = (100 - position) % 100
            if firstHit == 0 {
                // position == 0, first hit at k=100
                zeroCount += distance / 100
            } else if firstHit <= distance {
                zeroCount += (distance - firstHit) / 100 + 1
            }
            // Update position
            position = (position + distance) % 100
        }
    }

    return zeroCount
}

// Test with example
let example = """
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
"""

print("Example Part 1: \(solvePart1(example))") // Should be 3
print("Example Part 2: \(solvePart2(example))") // Should be 6

// Read actual input
let inputPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "input.txt"
if let input = try? String(contentsOfFile: inputPath, encoding: .utf8) {
    print("Part 1: \(solvePart1(input))")
    print("Part 2: \(solvePart2(input))")
}
