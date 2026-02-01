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

print("Answer: \(splitCount)")
