import Foundation

func findInvalidIDsInRangePart1(start: Int, end: Int) -> [Int] {
    var invalidIDs: [Int] = []
    let startDigits = String(start).count
    let endDigits = String(end).count

    for totalDigits in stride(from: (startDigits + 1) / 2 * 2, through: endDigits, by: 2) {
        if totalDigits % 2 != 0 { continue }

        let halfDigits = totalDigits / 2
        let minBase = halfDigits == 1 ? 1 : Int(pow(10.0, Double(halfDigits - 1)))
        let maxBase = Int(pow(10.0, Double(halfDigits))) - 1

        for base in minBase...maxBase {
            let multiplier = Int(pow(10.0, Double(halfDigits))) + 1
            let doubled = base * multiplier
            if doubled >= start && doubled <= end {
                invalidIDs.append(doubled)
            }
        }
    }

    return invalidIDs
}

func findInvalidIDsInRangePart2(start: Int, end: Int) -> Set<Int> {
    // An ID is invalid if it's some base repeated k times (k >= 2)
    // For a number with n digits, check all divisors k of n where k >= 2
    // The base would have n/k digits, repeated k times
    var invalidIDs = Set<Int>()
    let startDigits = String(start).count
    let endDigits = String(end).count

    for totalDigits in startDigits...endDigits {
        guard totalDigits >= 2 else { continue }
        // Find all ways to divide totalDigits into k equal parts (k >= 2)
        for k in 2...totalDigits {
            if totalDigits % k != 0 { continue }
            let baseDigits = totalDigits / k

            // Generate all base patterns with baseDigits digits (no leading zeros)
            let minBase = baseDigits == 1 ? 1 : Int(pow(10.0, Double(baseDigits - 1)))
            let maxBase = Int(pow(10.0, Double(baseDigits))) - 1

            for base in minBase...maxBase {
                // Construct the number by repeating base k times
                // number = base * (10^(baseDigits*(k-1)) + 10^(baseDigits*(k-2)) + ... + 10^0)
                // = base * sum of geometric series
                // = base * (10^(baseDigits*k) - 1) / (10^baseDigits - 1)
                let power = Int(pow(10.0, Double(baseDigits)))
                var repeated = 0
                for _ in 0..<k {
                    repeated = repeated * power + base
                }

                if repeated >= start && repeated <= end {
                    invalidIDs.insert(repeated)
                }
            }
        }
    }

    return invalidIDs
}

func solvePart1(_ input: String) -> Int {
    let ranges = input.trimmingCharacters(in: .whitespacesAndNewlines)
        .split(separator: ",")
        .map { range -> (Int, Int) in
            let parts = range.split(separator: "-")
            return (Int(parts[0])!, Int(parts[1])!)
        }

    var total = 0
    for (start, end) in ranges {
        let invalidIDs = findInvalidIDsInRangePart1(start: start, end: end)
        total += invalidIDs.reduce(0, +)
    }

    return total
}

func solvePart2(_ input: String) -> Int {
    let ranges = input.trimmingCharacters(in: .whitespacesAndNewlines)
        .split(separator: ",")
        .map { range -> (Int, Int) in
            let parts = range.split(separator: "-")
            return (Int(parts[0])!, Int(parts[1])!)
        }

    var total = 0
    for (start, end) in ranges {
        let invalidIDs = findInvalidIDsInRangePart2(start: start, end: end)
        total += invalidIDs.reduce(0, +)
    }

    return total
}

// Test with example
let example = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

print("Example Part 1: \(solvePart1(example))") // Should be 1227775554
print("Example Part 2: \(solvePart2(example))") // Should be 4174379265

// Read actual input
let inputPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "input.txt"
if let input = try? String(contentsOfFile: inputPath, encoding: .utf8) {
    print("Part 1: \(solvePart1(input))")
    print("Part 2: \(solvePart2(input))")
}
