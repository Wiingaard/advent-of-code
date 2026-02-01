#!/usr/bin/env swift

import Foundation

let exampleInput = """
3-5
10-14
16-20
12-18

1
5
8
11
17
32
"""

let sections = exampleInput
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy: "\n\n")
    .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

let rangeLines = sections[0].split(whereSeparator: \.isNewline).map(String.init)
let idLines = sections[1].split(whereSeparator: \.isNewline).map(String.init)

var ranges: [(Int, Int)] = []
for line in rangeLines {
    let parts = line.split(separator: "-")
    guard parts.count == 2,
          let start = Int(parts[0]),
          let end = Int(parts[1]) else {
        continue
    }
    ranges.append((start, end))
}

ranges.sort { $0.0 < $1.0 }
var merged: [(Int, Int)] = []
for range in ranges {
    if merged.isEmpty || range.0 > merged[merged.count - 1].1 + 1 {
        merged.append(range)
    } else {
        let lastIndex = merged.count - 1
        merged[lastIndex].1 = max(merged[lastIndex].1, range.1)
    }
}

func isFresh(_ id: Int, in ranges: [(Int, Int)]) -> Bool {
    var low = 0
    var high = ranges.count - 1
    while low <= high {
        let mid = (low + high) / 2
        let (start, end) = ranges[mid]
        if id < start {
            high = mid - 1
        } else if id > end {
            low = mid + 1
        } else {
            return true
        }
    }
    return false
}

var freshCount = 0
for line in idLines {
    if let id = Int(line), isFresh(id, in: merged) {
        freshCount += 1
    }
}

print("Expected: 3, Got: \(freshCount)")
