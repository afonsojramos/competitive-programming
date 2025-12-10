import Foundation

func solvePart1(_ input: String) -> Int {
    let lines = input.split(separator: "\n", omittingEmptySubsequences: false).map { String($0) }

    // Find the operator line (contains only +, *, and spaces)
    var opLineIdx = 0
    for (i, line) in lines.enumerated() {
        let trimmed = line.replacingOccurrences(of: " ", with: "")
        if !trimmed.isEmpty && trimmed.allSatisfy({ $0 == "+" || $0 == "*" }) {
            opLineIdx = i
            break
        }
    }

    let opLine = lines[opLineIdx]
    let numLines = Array(lines[0..<opLineIdx])

    // Find column positions where problems are separated (full column of spaces)
    let maxLen = max(opLine.count, numLines.map { $0.count }.max() ?? 0)

    // Pad all lines to same length
    let paddedNumLines = numLines.map { $0.padding(toLength: maxLen, withPad: " ", startingAt: 0) }
    let paddedOpLine = opLine.padding(toLength: maxLen, withPad: " ", startingAt: 0)

    // Find separator columns (all spaces in that column across all lines including op line)
    var separators: [Int] = [-1] // Start with -1 to mark beginning
    for col in 0..<maxLen {
        var allSpaces = true
        for line in paddedNumLines {
            let idx = line.index(line.startIndex, offsetBy: col)
            if line[idx] != " " {
                allSpaces = false
                break
            }
        }
        if allSpaces {
            let opIdx = paddedOpLine.index(paddedOpLine.startIndex, offsetBy: col)
            if paddedOpLine[opIdx] == " " {
                separators.append(col)
            }
        }
    }
    separators.append(maxLen)

    // Extract problems between separators
    var grandTotal = 0

    var problemStart = 0
    for col in 0..<maxLen {
        // Check if this column is a separator
        var isSep = true
        for line in paddedNumLines {
            let idx = line.index(line.startIndex, offsetBy: col)
            if line[idx] != " " {
                isSep = false
                break
            }
        }
        if isSep {
            let opIdx = paddedOpLine.index(paddedOpLine.startIndex, offsetBy: col)
            if paddedOpLine[opIdx] != " " {
                isSep = false
            }
        }

        if isSep && col > problemStart {
            // Extract problem from problemStart to col-1
            var numbers: [Int] = []
            var op: Character = "+"

            for line in paddedNumLines {
                let startIdx = line.index(line.startIndex, offsetBy: problemStart)
                let endIdx = line.index(line.startIndex, offsetBy: col)
                let slice = String(line[startIdx..<endIdx]).trimmingCharacters(in: .whitespaces)
                if let num = Int(slice) {
                    numbers.append(num)
                }
            }

            let opStartIdx = paddedOpLine.index(paddedOpLine.startIndex, offsetBy: problemStart)
            let opEndIdx = paddedOpLine.index(paddedOpLine.startIndex, offsetBy: col)
            let opSlice = String(paddedOpLine[opStartIdx..<opEndIdx]).trimmingCharacters(in: .whitespaces)
            if let opChar = opSlice.first {
                op = opChar
            }

            if !numbers.isEmpty {
                var result: Int
                if op == "*" {
                    result = numbers.reduce(1, *)
                } else {
                    result = numbers.reduce(0, +)
                }
                grandTotal += result
            }

            problemStart = col + 1
        }
    }

    // Handle last problem
    if problemStart < maxLen {
        var numbers: [Int] = []
        var op: Character = "+"

        for line in paddedNumLines {
            if problemStart < line.count {
                let startIdx = line.index(line.startIndex, offsetBy: problemStart)
                let slice = String(line[startIdx...]).trimmingCharacters(in: .whitespaces)
                if let num = Int(slice) {
                    numbers.append(num)
                }
            }
        }

        if problemStart < paddedOpLine.count {
            let opStartIdx = paddedOpLine.index(paddedOpLine.startIndex, offsetBy: problemStart)
            let opSlice = String(paddedOpLine[opStartIdx...]).trimmingCharacters(in: .whitespaces)
            if let opChar = opSlice.first {
                op = opChar
            }
        }

        if !numbers.isEmpty {
            var result: Int
            if op == "*" {
                result = numbers.reduce(1, *)
            } else {
                result = numbers.reduce(0, +)
            }
            grandTotal += result
        }
    }

    return grandTotal
}

func solvePart2(_ input: String) -> Int {
    let lines = input.split(separator: "\n", omittingEmptySubsequences: false).map { String($0) }

    // Find the operator line (contains only +, *, and spaces)
    var opLineIdx = 0
    for (i, line) in lines.enumerated() {
        let trimmed = line.replacingOccurrences(of: " ", with: "")
        if !trimmed.isEmpty && trimmed.allSatisfy({ $0 == "+" || $0 == "*" }) {
            opLineIdx = i
            break
        }
    }

    let opLine = lines[opLineIdx]
    let numLines = Array(lines[0..<opLineIdx])

    let maxLen = max(opLine.count, numLines.map { $0.count }.max() ?? 0)

    // Pad all lines to same length
    let paddedNumLines = numLines.map { $0.padding(toLength: maxLen, withPad: " ", startingAt: 0) }
    let paddedOpLine = opLine.padding(toLength: maxLen, withPad: " ", startingAt: 0)

    // Convert to character arrays for easier column access
    let numGrids = paddedNumLines.map { Array($0) }
    let opGrid = Array(paddedOpLine)

    // Extract problems between separators (same logic as Part 1 to find problem boundaries)
    var grandTotal = 0
    var problemStart = 0

    for col in 0..<maxLen {
        var isSep = true
        for row in numGrids {
            if row[col] != " " {
                isSep = false
                break
            }
        }
        if isSep && opGrid[col] != " " {
            isSep = false
        }

        if isSep && col > problemStart {
            // Extract problem from problemStart to col-1 using column-wise reading
            // Each column in the problem forms one number (read top-to-bottom as digits)
            var numbers: [Int] = []
            var op: Character = "+"

            // Read columns right-to-left within this problem
            for c in stride(from: col - 1, through: problemStart, by: -1) {
                var digitStr = ""
                for row in numGrids {
                    let ch = row[c]
                    if ch != " " {
                        digitStr.append(ch)
                    }
                }
                if !digitStr.isEmpty, let num = Int(digitStr) {
                    numbers.append(num)
                }

                // Get operator from this column
                if opGrid[c] != " " {
                    op = opGrid[c]
                }
            }

            if !numbers.isEmpty {
                var result: Int
                if op == "*" {
                    result = numbers.reduce(1, *)
                } else {
                    result = numbers.reduce(0, +)
                }
                grandTotal += result
            }

            problemStart = col + 1
        }
    }

    // Handle last problem
    if problemStart < maxLen {
        var numbers: [Int] = []
        var op: Character = "+"

        for c in stride(from: maxLen - 1, through: problemStart, by: -1) {
            var digitStr = ""
            for row in numGrids {
                if c < row.count {
                    let ch = row[c]
                    if ch != " " {
                        digitStr.append(ch)
                    }
                }
            }
            if !digitStr.isEmpty, let num = Int(digitStr) {
                numbers.append(num)
            }

            if c < opGrid.count && opGrid[c] != " " {
                op = opGrid[c]
            }
        }

        if !numbers.isEmpty {
            var result: Int
            if op == "*" {
                result = numbers.reduce(1, *)
            } else {
                result = numbers.reduce(0, +)
            }
            grandTotal += result
        }
    }

    return grandTotal
}

// Test with example
let example = """
123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +
"""

print("Example Part 1: \(solvePart1(example))") // Should be 4277556
print("Example Part 2: \(solvePart2(example))") // Should be 3263827

// Read actual input
let inputPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "input.txt"
if let input = try? String(contentsOfFile: inputPath, encoding: .utf8) {
    print("Part 1: \(solvePart1(input))")
    print("Part 2: \(solvePart2(input))")
}
