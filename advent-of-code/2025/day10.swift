import Foundation

struct Machine {
    let target: [Int]
    let buttons: [[Int]]
    let numLights: Int
    let joltage: [Int]
}

func parseMachine(_ line: String) -> Machine {
    var remaining = line

    guard let startBracket = remaining.firstIndex(of: "["),
          let endBracket = remaining.firstIndex(of: "]") else {
        fatalError("Invalid format: \(line)")
    }

    let patternStr = String(remaining[remaining.index(after: startBracket)..<endBracket])
    let numLights = patternStr.count
    var target: [Int] = []
    for (i, ch) in patternStr.enumerated() {
        if ch == "#" {
            target.append(i)
        }
    }

    remaining = String(remaining[remaining.index(after: endBracket)...])

    var buttons: [[Int]] = []
    while let parenStart = remaining.firstIndex(of: "("),
          let parenEnd = remaining.firstIndex(of: ")"),
          (remaining.firstIndex(of: "{") == nil || parenStart < remaining.firstIndex(of: "{")!) {
        let buttonStr = String(remaining[remaining.index(after: parenStart)..<parenEnd])
        let indices = buttonStr.split(separator: ",").compactMap { Int($0) }
        buttons.append(indices)
        remaining = String(remaining[remaining.index(after: parenEnd)...])
    }

    var joltage: [Int] = []
    if let braceStart = remaining.firstIndex(of: "{"),
       let braceEnd = remaining.firstIndex(of: "}") {
        let joltageStr = String(remaining[remaining.index(after: braceStart)..<braceEnd])
        joltage = joltageStr.split(separator: ",").compactMap { Int($0) }
    }

    return Machine(target: target, buttons: buttons, numLights: numLights, joltage: joltage)
}

func minPressesPart1(_ machine: Machine) -> Int {
    let numButtons = machine.buttons.count
    let numLights = machine.numLights

    var matrix = [[Int]](repeating: [Int](repeating: 0, count: numButtons + 1), count: numLights)

    for (j, button) in machine.buttons.enumerated() {
        for lightIdx in button {
            if lightIdx < numLights {
                matrix[lightIdx][j] = 1
            }
        }
    }

    for lightIdx in machine.target {
        matrix[lightIdx][numButtons] = 1
    }

    var pivotRow = 0
    var pivotCols: [Int] = []

    for col in 0..<numButtons {
        var foundPivot = -1
        for row in pivotRow..<numLights {
            if matrix[row][col] == 1 {
                foundPivot = row
                break
            }
        }

        if foundPivot == -1 { continue }

        if foundPivot != pivotRow {
            let temp = matrix[pivotRow]
            matrix[pivotRow] = matrix[foundPivot]
            matrix[foundPivot] = temp
        }

        pivotCols.append(col)

        for row in 0..<numLights {
            if row != pivotRow && matrix[row][col] == 1 {
                for c in 0...numButtons {
                    matrix[row][c] ^= matrix[pivotRow][c]
                }
            }
        }

        pivotRow += 1
    }

    for row in pivotRow..<numLights {
        if matrix[row][numButtons] == 1 {
            return Int.max
        }
    }

    let pivotColSet = Set(pivotCols)
    var freeVars: [Int] = []
    for col in 0..<numButtons {
        if !pivotColSet.contains(col) {
            freeVars.append(col)
        }
    }

    let numFree = freeVars.count
    let maxMask = min(1 << numFree, 1 << 20)

    var minSum = Int.max

    for mask in 0..<maxMask {
        var solution = [Int](repeating: 0, count: numButtons)

        for (i, freeCol) in freeVars.enumerated() {
            if i < 20 {
                solution[freeCol] = (mask >> i) & 1
            }
        }

        for (rowIdx, pivotCol) in pivotCols.enumerated().reversed() {
            var val = matrix[rowIdx][numButtons]
            for col in (pivotCol + 1)..<numButtons {
                val ^= matrix[rowIdx][col] * solution[col]
            }
            solution[pivotCol] = val
        }

        let sum = solution.reduce(0, +)
        minSum = min(minSum, sum)
    }

    return minSum
}

// Part 2: Solve using integer linear programming with Gaussian elimination
// System: A * x = b where x >= 0, minimize sum(x)

func gcd(_ a: Int, _ b: Int) -> Int {
    var a = a
    var b = b
    while b != 0 {
        let temp = b
        b = a % b
        a = temp
    }
    return a
}

// Helper to compute solution for given free variable values
func computeSolution(
    freeVals: [Int],
    freeVars: [Int],
    pivotCols: [Int],
    matrix: [[Int]],
    numButtons: Int
) -> [Int]? {
    var solution = [Int](repeating: 0, count: numButtons)

    // Set free variables
    for (i, freeCol) in freeVars.enumerated() {
        solution[freeCol] = freeVals[i]
    }

    // Compute pivot variables (in reverse order)
    for (rowIdx, pivotCol) in pivotCols.enumerated().reversed() {
        let pivotVal = matrix[rowIdx][pivotCol]
        var val = matrix[rowIdx][numButtons]

        for col in (pivotCol + 1)..<numButtons {
            val -= matrix[rowIdx][col] * solution[col]
        }

        // val must be divisible by pivotVal
        if val % pivotVal != 0 {
            return nil
        }

        let result = val / pivotVal
        if result < 0 {
            return nil
        }
        solution[pivotCol] = result
    }

    // Verify all non-negative
    for x in solution {
        if x < 0 { return nil }
    }

    return solution
}

func minPressesPart2(_ machine: Machine) -> Int {
    let numButtons = machine.buttons.count
    let numCounters = machine.joltage.count
    let targets = machine.joltage

    if numCounters == 0 { return 0 }

    // Build coefficient matrix [A | b] using integers
    var matrix = [[Int]](repeating: [Int](repeating: 0, count: numButtons + 1), count: numCounters)
    for (j, button) in machine.buttons.enumerated() {
        for counterIdx in button {
            if counterIdx < numCounters {
                matrix[counterIdx][j] = 1
            }
        }
    }
    for i in 0..<numCounters {
        matrix[i][numButtons] = targets[i]
    }

    // Gaussian elimination over integers
    var pivotRow = 0
    var pivotCols: [Int] = []

    for col in 0..<numButtons {
        var maxRow = -1
        for row in pivotRow..<numCounters {
            if matrix[row][col] != 0 {
                maxRow = row
                break
            }
        }

        if maxRow == -1 { continue }

        if maxRow != pivotRow {
            let temp = matrix[pivotRow]
            matrix[pivotRow] = matrix[maxRow]
            matrix[maxRow] = temp
        }

        pivotCols.append(col)

        let pivotVal = matrix[pivotRow][col]
        for row in 0..<numCounters {
            if row != pivotRow && matrix[row][col] != 0 {
                let rowVal = matrix[row][col]
                let g = gcd(abs(pivotVal), abs(rowVal))
                let pivotMult = rowVal / g
                let rowMult = pivotVal / g
                for c in 0...(numButtons) {
                    matrix[row][c] = rowMult * matrix[row][c] - pivotMult * matrix[pivotRow][c]
                }
            }
        }

        pivotRow += 1
    }

    // Check for inconsistency
    for row in pivotRow..<numCounters {
        if matrix[row][numButtons] != 0 {
            return Int.max
        }
    }

    // Find free variables
    let pivotColSet = Set(pivotCols)
    var freeVars: [Int] = []
    for col in 0..<numButtons {
        if !pivotColSet.contains(col) {
            freeVars.append(col)
        }
    }

    // Bound free variables by max target value
    // (simpler and more robust than deriving bounds from constraints)
    let maxTarget = targets.max() ?? 0
    let freeBounds = [Int](repeating: maxTarget, count: freeVars.count)

    var minSum = Int.max

    // Calculate total search space
    var totalCombinations: Int = 1
    for bound in freeBounds {
        if bound == Int.max || totalCombinations > 50_000_000 {
            totalCombinations = Int.max
            break
        }
        totalCombinations *= (bound + 1)
    }

    if freeVars.count == 0 {
        if let sol = computeSolution(freeVals: [], freeVars: freeVars, pivotCols: pivotCols, matrix: matrix, numButtons: numButtons) {
            minSum = sol.reduce(0, +)
        }
    } else if totalCombinations <= 50_000_000 {
        // Enumerate all combinations iteratively
        var freeVals = [Int](repeating: 0, count: freeVars.count)
        while true {
            if let sol = computeSolution(freeVals: freeVals, freeVars: freeVars, pivotCols: pivotCols, matrix: matrix, numButtons: numButtons) {
                minSum = min(minSum, sol.reduce(0, +))
            }

            // Increment
            var carry = true
            for i in 0..<freeVars.count {
                if carry {
                    freeVals[i] += 1
                    if freeVals[i] > freeBounds[i] {
                        freeVals[i] = 0
                    } else {
                        carry = false
                    }
                }
            }
            if carry { break }
        }
    } else {
        // Try all zeros first
        if let sol = computeSolution(freeVals: [Int](repeating: 0, count: freeVars.count), freeVars: freeVars, pivotCols: pivotCols, matrix: matrix, numButtons: numButtons) {
            minSum = min(minSum, sol.reduce(0, +))
        }

        // Try random sampling with bounded ranges
        for _ in 0..<1000000 {
            var freeVals = [Int]()
            for i in 0..<freeVars.count {
                freeVals.append(freeBounds[i] == Int.max ? Int.random(in: 0...maxTarget) : Int.random(in: 0...freeBounds[i]))
            }
            if let sol = computeSolution(freeVals: freeVals, freeVars: freeVars, pivotCols: pivotCols, matrix: matrix, numButtons: numButtons) {
                minSum = min(minSum, sol.reduce(0, +))
            }
        }
    }

    return minSum
}

func solvePart1(_ input: String) -> Int {
    let lines = input.split(separator: "\n").map { String($0) }
    var total = 0
    for line in lines {
        guard !line.isEmpty else { continue }
        let machine = parseMachine(line)
        total += minPressesPart1(machine)
    }
    return total
}

func solvePart2(_ input: String) -> Int {
    let lines = input.split(separator: "\n").map { String($0) }
    var total = 0
    for (idx, line) in lines.enumerated() {
        guard !line.isEmpty else { continue }
        let machine = parseMachine(line)
        let result = minPressesPart2(machine)
        total += result
        if idx % 10 == 0 {
            print("Progress: \(idx)/\(lines.count), subtotal: \(total)")
        }
    }
    return total
}

// Test
let example1 = "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}"
let example2 = "[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}"
let example3 = "[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}"

print("Example 1 Part 2: \(minPressesPart2(parseMachine(example1)))") // Should be 10
print("Example 2 Part 2: \(minPressesPart2(parseMachine(example2)))") // Should be 12
print("Example 3 Part 2: \(minPressesPart2(parseMachine(example3)))") // Should be 11

let examples = "\(example1)\n\(example2)\n\(example3)"
print("Examples Part 2: \(solvePart2(examples))") // Should be 33

let inputPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "day-10.txt"
if let input = try? String(contentsOfFile: inputPath, encoding: .utf8) {
    print("Part 1: \(solvePart1(input))")
    print("Part 2: \(solvePart2(input))")
}
