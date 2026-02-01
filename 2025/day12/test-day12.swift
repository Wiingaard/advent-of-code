#!/usr/bin/env swift

import Foundation

let exampleInput = """
0:
###
##.
##.

1:
###
##.
.##

2:
.##
###
##.

3:
##.
###
##.

4:
###
#..
###

5:
###
.#.
###

4x4: 0 0 0 0 2 0
12x5: 1 0 1 0 2 2
12x5: 1 0 1 0 3 2
"""

let lines = exampleInput.split(whereSeparator: \.isNewline).map(String.init)
var shapeCells: [Int: Int64] = [:]

var i = 0
while i < lines.count {
    let line = lines[i].trimmingCharacters(in: .whitespaces)
    if line.isEmpty {
        i += 1
        continue
    }

    if line.hasSuffix(":"),
       let index = Int(line.dropLast()) {
        i += 1
        var cells: Int64 = 0
        while i < lines.count {
            let row = lines[i].trimmingCharacters(in: .whitespaces)
            if row.isEmpty { break }
            if row.contains("x") && row.contains(":") { break }
            if row.hasSuffix(":") { break }
            cells += Int64(row.filter { $0 == "#" }.count)
            i += 1
        }
        shapeCells[index] = cells
        continue
    }

    if line.contains("x") && line.contains(":") {
        break
    }

    i += 1
}

var fitCount = 0
for line in lines {
    if !line.contains("x") || !line.contains(":") { continue }
    let parts = line.split(separator: ":", maxSplits: 1)
    guard parts.count == 2 else { continue }
    let sizeParts = parts[0].split(separator: "x")
    guard sizeParts.count == 2,
          let width = Int64(sizeParts[0]),
          let height = Int64(sizeParts[1]) else {
        continue
    }
    let counts = parts[1].split(whereSeparator: \.isWhitespace).compactMap { Int64($0) }
    var totalCells: Int64 = 0
    for (idx, count) in counts.enumerated() {
        if let cells = shapeCells[idx] {
            totalCells += cells * count
        }
    }
    let area = width * height
    if totalCells <= area {
        fitCount += 1
    }
}

print("Expected: 2, Got: \(fitCount)")
