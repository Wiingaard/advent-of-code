#!/usr/bin/env swift

import Foundation

let exampleRanges = """
3-5
10-14
16-20
12-18
"""

let rangeLines = exampleRanges
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .split(whereSeparator: \.isNewline)
    .map(String.init)

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

var totalFresh = 0
for (start, end) in merged {
    totalFresh += (end - start + 1)
}

print("Expected: 14, Got: \(totalFresh)")
