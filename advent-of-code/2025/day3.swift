import Foundation

func maxJoltage(_ bank: String, k: Int) -> Int {
    let digits = Array(bank).map { Int(String($0))! }
    let n = digits.count

    // Greedy: pick k digits to form the largest number
    // For each position in result, pick the largest digit available
    // such that enough digits remain for the rest
    var result = 0
    var startIdx = 0

    for remaining in stride(from: k, to: 0, by: -1) {
        // Need to pick 'remaining' more digits
        // Can pick from startIdx to n - remaining (inclusive)
        let endIdx = n - remaining
        var bestDigit = -1
        var bestPos = startIdx

        for i in startIdx...endIdx {
            if digits[i] > bestDigit {
                bestDigit = digits[i]
                bestPos = i
            }
        }

        result = result * 10 + bestDigit
        startIdx = bestPos + 1
    }

    return result
}

func solvePart1(_ input: String) -> Int {
    let lines = input.split(separator: "\n").map(String.init)
    return lines.reduce(0) { $0 + maxJoltage($1, k: 2) }
}

func solvePart2(_ input: String) -> Int {
    let lines = input.split(separator: "\n").map(String.init)
    return lines.reduce(0) { $0 + maxJoltage($1, k: 12) }
}

// Test with example
let example = """
987654321111111
811111111111119
234234234234278
818181911112111
"""

print("Example Part 1: \(solvePart1(example))") // Should be 357
print("Example Part 2: \(solvePart2(example))") // Should be 3121910778619

// Read actual input
let inputPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "input.txt"
if let input = try? String(contentsOfFile: inputPath, encoding: .utf8) {
    print("Part 1: \(solvePart1(input))")
    print("Part 2: \(solvePart2(input))")
}
