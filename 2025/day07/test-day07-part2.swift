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

var splittersByCol = Array(repeating: [Int](), count: cols)
for r in 0..<rows {
    for c in 0..<cols where grid[r][c] == "^" {
        splittersByCol[c].append(r)
    }
}

func nextSplitterRow(col: Int, startRow: Int) -> Int? {
    let list = splittersByCol[col]
    var low = 0
    var high = list.count
    while low < high {
        let mid = (low + high) / 2
        if list[mid] < startRow {
            low = mid + 1
        } else {
            high = mid
        }
    }
    return low < list.count ? list[low] : nil
}

struct State: Hashable {
    let col: Int
    let row: Int
}

var memo: [State: Int64] = [:]

func countTimelines(col: Int, startRow: Int) -> Int64 {
    if col < 0 || col >= cols || startRow >= rows {
        return 1
    }

    let state = State(col: col, row: startRow)
    if let cached = memo[state] {
        return cached
    }

    guard let splitterRow = nextSplitterRow(col: col, startRow: startRow) else {
        memo[state] = 1
        return 1
    }

    let total = countTimelines(col: col - 1, startRow: splitterRow)
        + countTimelines(col: col + 1, startRow: splitterRow)
    memo[state] = total
    return total
}

let totalTimelines = countTimelines(col: startCol, startRow: startRow + 1)
print("Expected: 40, Got: \(totalTimelines)")
