#!/usr/bin/env swift

import Foundation

let exampleInput = """
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
"""

struct Machine {
    let buttons: [[Int]]
    let targets: [Int64]
}

func parseLine(_ line: String) -> Machine? {
    guard let targetStart = line.firstIndex(of: "{"),
          let targetEnd = line.firstIndex(of: "}") else {
        return nil
    }
    let targetContent = line[line.index(after: targetStart)..<targetEnd]
    let targets = targetContent
        .split(separator: ",")
        .compactMap { Int64($0) }

    var buttons: [[Int]] = []
    var index = line.startIndex
    while index < line.endIndex {
        if line[index] == "(" {
            var end = line.index(after: index)
            while end < line.endIndex && line[end] != ")" {
                end = line.index(after: end)
            }
            if end < line.endIndex {
                let content = line[line.index(after: index)..<end]
                let parts = content.split(separator: ",")
                let indices = parts.compactMap { Int($0) }
                buttons.append(indices)
                index = line.index(after: end)
            } else {
                break
            }
        } else {
            index = line.index(after: index)
        }
    }

    return Machine(buttons: buttons, targets: targets)
}

func gcd(_ a: Int64, _ b: Int64) -> Int64 {
    var x = abs(a)
    var y = abs(b)
    while y != 0 {
        let t = x % y
        x = y
        y = t
    }
    return x
}

struct Fraction: Equatable {
    var num: Int64
    var den: Int64

    init(_ num: Int64, _ den: Int64 = 1) {
        var n = num
        var d = den
        if d < 0 {
            n = -n
            d = -d
        }
        let g = gcd(n, d)
        self.num = n / g
        self.den = d / g
    }

    var isZero: Bool { num == 0 }
}

func + (lhs: Fraction, rhs: Fraction) -> Fraction {
    return Fraction(lhs.num * rhs.den + rhs.num * lhs.den, lhs.den * rhs.den)
}

func - (lhs: Fraction, rhs: Fraction) -> Fraction {
    return Fraction(lhs.num * rhs.den - rhs.num * lhs.den, lhs.den * rhs.den)
}

func * (lhs: Fraction, rhs: Fraction) -> Fraction {
    return Fraction(lhs.num * rhs.num, lhs.den * rhs.den)
}

func / (lhs: Fraction, rhs: Fraction) -> Fraction {
    return Fraction(lhs.num * rhs.den, lhs.den * rhs.num)
}

func invertMatrix(_ matrix: [[Fraction]]) -> [[Fraction]]? {
    let n = matrix.count
    if n == 0 { return [] }
    var mat = Array(repeating: Array(repeating: Fraction(0), count: 2 * n), count: n)
    for i in 0..<n {
        for j in 0..<n {
            mat[i][j] = matrix[i][j]
        }
        mat[i][n + i] = Fraction(1)
    }

    for col in 0..<n {
        var pivot: Int? = nil
        for r in col..<n where !mat[r][col].isZero {
            pivot = r
            break
        }
        guard let pivotRow = pivot else { return nil }
        if pivotRow != col {
            mat.swapAt(col, pivotRow)
        }
        let pivotValue = mat[col][col]
        for c in 0..<(2 * n) {
            mat[col][c] = mat[col][c] / pivotValue
        }
        for r in 0..<n where r != col {
            let factor = mat[r][col]
            if !factor.isZero {
                for c in 0..<(2 * n) {
                    mat[r][c] = mat[r][c] - factor * mat[col][c]
                }
            }
        }
    }

    var inv = Array(repeating: Array(repeating: Fraction(0), count: n), count: n)
    for i in 0..<n {
        for j in 0..<n {
            inv[i][j] = mat[i][n + j]
        }
    }
    return inv
}

func solveMachine(_ machine: Machine) -> Int64 {
    let targets = machine.targets
    let m = targets.count
    let b = machine.buttons.count
    if m == 0 || b == 0 { return 0 }

    var A = Array(repeating: Array(repeating: Int64(0), count: b), count: m)
    for (j, button) in machine.buttons.enumerated() {
        for idx in button {
            A[idx][j] = 1
        }
    }

    var mat = Array(repeating: Array(repeating: Fraction(0), count: b + 1), count: m)
    for i in 0..<m {
        for j in 0..<b {
            mat[i][j] = Fraction(A[i][j])
        }
        mat[i][b] = Fraction(targets[i])
    }

    var pivotCols: [Int] = []
    var row = 0
    for col in 0..<b {
        var pivotRow: Int? = nil
        for r in row..<m where !mat[r][col].isZero {
            pivotRow = r
            break
        }
        guard let pivot = pivotRow else { continue }
        if pivot != row {
            mat.swapAt(row, pivot)
        }
        pivotCols.append(col)
        let pivotValue = mat[row][col]
        if !pivotValue.isZero {
            for r in (row + 1)..<m where !mat[r][col].isZero {
                let factor = mat[r][col] / pivotValue
                for c in col...b {
                    mat[r][c] = mat[r][c] - factor * mat[row][c]
                }
            }
        }
        row += 1
        if row == m { break }
    }

    let rank = row
    if rank == 0 {
        return targets.allSatisfy { $0 == 0 } ? 0 : 0
    }

    let freeCols = (0..<b).filter { !pivotCols.contains($0) }
    let r = rank

    var R = Array(repeating: Array(repeating: Fraction(0), count: b), count: r)
    var t = Array(repeating: Fraction(0), count: r)
    for i in 0..<r {
        for j in 0..<b {
            R[i][j] = mat[i][j]
        }
        t[i] = mat[i][b]
    }

    let Rpivot = (0..<r).map { i in pivotCols.map { R[i][$0] } }
    let Rfree = (0..<r).map { i in freeCols.map { R[i][$0] } }

    guard let invPivot = invertMatrix(Rpivot) else { return 0 }

    var bounds: [Int64] = []
    for col in freeCols {
        var minBound: Int64? = nil
        for i in 0..<m where A[i][col] == 1 {
            minBound = minBound == nil ? targets[i] : min(minBound!, targets[i])
        }
        bounds.append(minBound ?? 0)
    }

    var best: Int64? = nil
    let freeCount = freeCols.count

    func dfs(_ idx: Int, _ counts: inout [Int64], _ contribution: inout [Int64], _ sumFree: Int64) {
        if let bestValue = best, sumFree >= bestValue { return }

        if idx == freeCount {
            let remainingMax = contribution.enumerated().map { targets[$0.offset] - $0.element }.max() ?? 0
            if let bestValue = best, sumFree + remainingMax >= bestValue { return }

            var rhs = t
            for i in 0..<r {
                var subtotal = Fraction(0)
                for j in 0..<freeCount {
                    let coeff = Rfree[i][j]
                    if !coeff.isZero && counts[j] > 0 {
                        subtotal = subtotal + coeff * Fraction(counts[j])
                    }
                }
                rhs[i] = rhs[i] - subtotal
            }

            var pivotValues: [Int64] = []
            for i in 0..<r {
                var value = Fraction(0)
                for j in 0..<r {
                    value = value + invPivot[i][j] * rhs[j]
                }
                if value.den != 1 || value.num < 0 { return }
                pivotValues.append(value.num)
            }

            var x = Array(repeating: Int64(0), count: b)
            for (idx, col) in freeCols.enumerated() { x[col] = counts[idx] }
            for (idx, col) in pivotCols.enumerated() { x[col] = pivotValues[idx] }

            for i in 0..<m {
                var sum: Int64 = 0
                for j in 0..<b {
                    sum += A[i][j] * x[j]
                }
                if sum != targets[i] { return }
            }

            let total = x.reduce(0, +)
            if best == nil || total < best! {
                best = total
            }
            return
        }

        let maxCount = bounds[idx]
        if maxCount == 0 {
            counts[idx] = 0
            dfs(idx + 1, &counts, &contribution, sumFree)
            return
        }

        for c in 0...maxCount {
            var ok = true
            if c > 0 {
                for i in 0..<m where A[i][freeCols[idx]] == 1 {
                    contribution[i] += c
                    if contribution[i] > targets[i] { ok = false }
                }
            }

            if ok {
                counts[idx] = c
                dfs(idx + 1, &counts, &contribution, sumFree + c)
            }

            if c > 0 {
                for i in 0..<m where A[i][freeCols[idx]] == 1 {
                    contribution[i] -= c
                }
            }

            if !ok { break }
        }
    }

    var counts = Array(repeating: Int64(0), count: freeCount)
    var contribution = Array(repeating: Int64(0), count: m)
    dfs(0, &counts, &contribution, 0)

    return best ?? 0
}

let lines = exampleInput.split(whereSeparator: \.isNewline).map(String.init)
var totalPresses: Int64 = 0

for line in lines {
    if let machine = parseLine(line) {
        totalPresses += solveMachine(machine)
    }
}

print("Expected: 33, Got: \(totalPresses)")
