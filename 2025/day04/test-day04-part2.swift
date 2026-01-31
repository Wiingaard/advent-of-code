#!/usr/bin/env swift

import Foundation

let exampleGrid = """
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
"""

let lines = exampleGrid.split(whereSeparator: \.isNewline).map { String($0) }
let rows = lines.count
let cols = lines.first?.count ?? 0

let directions = [
    (-1, -1), (-1, 0), (-1, 1),
    (0, -1),           (0, 1),
    (1, -1),  (1, 0),  (1, 1)
]

let totalCells = rows * cols
var hasRoll = Array(repeating: false, count: totalCells)

func index(_ r: Int, _ c: Int) -> Int {
    return r * cols + c
}

for r in 0..<rows {
    let rowChars = Array(lines[r])
    for c in 0..<cols {
        if rowChars[c] == "@" {
            hasRoll[index(r, c)] = true
        }
    }
}

var degree = Array(repeating: 0, count: totalCells)
for r in 0..<rows {
    for c in 0..<cols {
        let idx = index(r, c)
        if !hasRoll[idx] { continue }
        var count = 0
        for (dr, dc) in directions {
            let rr = r + dr
            let cc = c + dc
            if rr >= 0 && rr < rows && cc >= 0 && cc < cols {
                if hasRoll[index(rr, cc)] {
                    count += 1
                }
            }
        }
        degree[idx] = count
    }
}

var queue: [Int] = []
queue.reserveCapacity(totalCells)
for idx in 0..<totalCells {
    if hasRoll[idx] && degree[idx] < 4 {
        queue.append(idx)
    }
}

var removed = 0
var head = 0

while head < queue.count {
    let idx = queue[head]
    head += 1

    if !hasRoll[idx] { continue }
    hasRoll[idx] = false
    removed += 1

    let r = idx / cols
    let c = idx % cols
    for (dr, dc) in directions {
        let rr = r + dr
        let cc = c + dc
        if rr >= 0 && rr < rows && cc >= 0 && cc < cols {
            let nidx = index(rr, cc)
            if hasRoll[nidx] {
                degree[nidx] -= 1
                if degree[nidx] == 3 {
                    queue.append(nidx)
                }
            }
        }
    }
}

print("Expected: 43, Got: \(removed)")
