#!/usr/bin/env swift

import Foundation

let example = """
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
"""

let lines = example
    .split(whereSeparator: \.isNewline)
    .map { String($0) }
    .filter { !$0.isEmpty }

let rows = lines.count
let cols = lines.first?.count ?? 0
let grid = lines.map { Array($0) }

var startRow = 0
var startCol = 0
for r in 0..<rows {
    if let c = grid[r].firstIndex(of: "S") {
        startRow = r
        startCol = c
        break
    }
}

var active = Set<Int>()
active.insert(startCol)

var splitCount = 0
if startRow + 1 < rows {
    for r in (startRow + 1)..<rows {
        var queue = Array(active)
        var processed = Set<Int>()
        var nextActive = Set<Int>()

        while let col = queue.popLast() {
            if col < 0 || col >= cols { continue }
            if processed.contains(col) { continue }
            processed.insert(col)

            if grid[r][col] == "^" {
                splitCount += 1
                queue.append(col - 1)
                queue.append(col + 1)
            } else {
                nextActive.insert(col)
            }
        }

        active = nextActive
        if active.isEmpty { break }
    }
}

print("Expected: 21, Got: \(splitCount)")
