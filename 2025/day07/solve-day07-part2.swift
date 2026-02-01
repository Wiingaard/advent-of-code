#!/usr/bin/env swift

import Foundation

let inputFile = "day07.txt"
guard let content = try? String(contentsOfFile: inputFile, encoding: .utf8) else {
    print("Error: Could not read \(inputFile)")
    exit(1)
}

let lines = content
    .split(whereSeparator: \.isNewline)
    .map { String($0) }
    .filter { !$0.isEmpty }

let rows = lines.count
let cols = lines.first?.count ?? 0

guard rows > 0, cols > 0 else {
    print("Answer: 0")
    exit(0)
}

var grid: [[Character]] = lines.map { Array($0) }

var startRow = 0
var startCol = 0
var foundStart = false
for r in 0..<rows where !foundStart {
    if let c = grid[r].firstIndex(of: "S") {
        startRow = r
        startCol = c
        foundStart = true
    }
}

guard foundStart else {
    print("Answer: 0")
    exit(0)
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

    let leftCount = countTimelines(col: col - 1, startRow: splitterRow)
    let rightCount = countTimelines(col: col + 1, startRow: splitterRow)
    let total = leftCount + rightCount
    memo[state] = total
    return total
}

let totalTimelines = countTimelines(col: startCol, startRow: startRow + 1)
print("Answer: \(totalTimelines)")
