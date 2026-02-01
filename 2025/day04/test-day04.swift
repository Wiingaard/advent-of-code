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
let grid = lines.map { Array($0) }

let directions = [
    (-1, -1), (-1, 0), (-1, 1),
    (0, -1),           (0, 1),
    (1, -1),  (1, 0),  (1, 1)
]

var accessibleCount = 0
for r in 0..<rows {
    for c in 0..<cols {
        if grid[r][c] != "@" { continue }
        var adjacent = 0
        for (dr, dc) in directions {
            let rr = r + dr
            let cc = c + dc
            if rr >= 0 && rr < rows && cc >= 0 && cc < cols {
                if grid[rr][cc] == "@" {
                    adjacent += 1
                }
            }
        }
        if adjacent < 4 {
            accessibleCount += 1
        }
    }
}

print("Expected: 13, Got: \(accessibleCount)")
