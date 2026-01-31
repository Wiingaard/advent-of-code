#!/usr/bin/env swift

import Foundation

let inputFile = "day05.txt"
guard let content = try? String(contentsOfFile: inputFile, encoding: .utf8) else {
    print("Error: Could not read \(inputFile)")
    exit(1)
}

let sections = content
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy: "\n\n")
    .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

guard sections.count >= 1 else {
    print("Answer: 0")
    exit(0)
}

let rangeLines = sections[0].split(whereSeparator: \.isNewline).map(String.init)

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

print("Answer: \(totalFresh)")
