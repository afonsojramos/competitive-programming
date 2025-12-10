import Foundation

class UnionFind {
    var parent: [Int]
    var rank: [Int]
    var size: [Int]

    init(_ n: Int) {
        parent = Array(0..<n)
        rank = [Int](repeating: 0, count: n)
        size = [Int](repeating: 1, count: n)
    }

    func find(_ x: Int) -> Int {
        if parent[x] != x {
            parent[x] = find(parent[x])
        }
        return parent[x]
    }

    func union(_ x: Int, _ y: Int) -> Bool {
        let px = find(x)
        let py = find(y)
        if px == py { return false }

        if rank[px] < rank[py] {
            parent[px] = py
            size[py] += size[px]
        } else if rank[px] > rank[py] {
            parent[py] = px
            size[px] += size[py]
        } else {
            parent[py] = px
            size[px] += size[py]
            rank[px] += 1
        }
        return true
    }

    func getSize(_ x: Int) -> Int {
        return size[find(x)]
    }
}

func distanceSquared(_ a: (Int, Int, Int), _ b: (Int, Int, Int)) -> Int {
    let dx = a.0 - b.0
    let dy = a.1 - b.1
    let dz = a.2 - b.2
    return dx * dx + dy * dy + dz * dz
}

func solvePart1(_ input: String, connections: Int) -> Int {
    let lines = input.split(separator: "\n")
    var points: [(Int, Int, Int)] = []

    for line in lines {
        let coords = line.split(separator: ",").map { Int($0)! }
        points.append((coords[0], coords[1], coords[2]))
    }

    let n = points.count

    // Generate all pairs with distances
    var pairs: [(Int, Int, Int, Int)] = [] // (distSquared, i, j)
    for i in 0..<n {
        for j in (i + 1)..<n {
            let d = distanceSquared(points[i], points[j])
            pairs.append((d, i, j, 0))
        }
    }

    // Sort by distance
    pairs.sort { $0.0 < $1.0 }

    // Union-Find
    let uf = UnionFind(n)

    var connected = 0
    for (_, i, j, _) in pairs {
        if connected >= connections { break }
        uf.union(i, j)
        connected += 1
    }

    // Get all unique circuit sizes
    var circuitSizes: [Int] = []
    var seen = Set<Int>()
    for i in 0..<n {
        let root = uf.find(i)
        if !seen.contains(root) {
            seen.insert(root)
            circuitSizes.append(uf.getSize(i))
        }
    }

    // Sort descending and multiply top 3
    circuitSizes.sort(by: >)
    let top3 = circuitSizes.prefix(3)
    return top3.reduce(1, *)
}

func solvePart2(_ input: String) -> Int {
    let lines = input.split(separator: "\n")
    var points: [(Int, Int, Int)] = []

    for line in lines {
        let coords = line.split(separator: ",").map { Int($0)! }
        points.append((coords[0], coords[1], coords[2]))
    }

    let n = points.count

    // Generate all pairs with distances
    var pairs: [(Int, Int, Int)] = [] // (distSquared, i, j)
    for i in 0..<n {
        for j in (i + 1)..<n {
            let d = distanceSquared(points[i], points[j])
            pairs.append((d, i, j))
        }
    }

    // Sort by distance
    pairs.sort { $0.0 < $1.0 }

    // Union-Find - keep going until all in one circuit
    let uf = UnionFind(n)

    var numComponents = n
    var lastI = 0
    var lastJ = 0

    for (_, i, j) in pairs {
        if uf.union(i, j) {
            numComponents -= 1
            lastI = i
            lastJ = j
            if numComponents == 1 {
                break
            }
        }
    }

    // Return product of X coordinates
    return points[lastI].0 * points[lastJ].0
}

// Test with example
let example = """
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689
"""

print("Example Part 1 (10 connections): \(solvePart1(example, connections: 10))") // Should be 40
print("Example Part 2: \(solvePart2(example))") // Should be 25272

// Read actual input
let inputPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "input.txt"
if let input = try? String(contentsOfFile: inputPath, encoding: .utf8) {
    print("Part 1: \(solvePart1(input, connections: 1000))")
    print("Part 2: \(solvePart2(input))")
}
