#!/usr/bin/env swift

import Foundation

let inputFile = "day06.txt"
guard let content = try? String(contentsOfFile: inputFile, encoding: .utf8) else {
    print("Error: Could not read \(inputFile)")
    exit(1)
}

var lines = content.components(separatedBy: .newlines)
while let last = lines.last, last.isEmpty {
    lines.removeLast()
}

guard lines.count >= 2 else {
    print("Answer: 0")
    exit(0)
}

let maxLen = lines.map { $0.count }.max() ?? 0
var grid: [[Character]] = []
grid.reserveCapacity(lines.count)

for line in lines {
    var chars = Array(line)
    if chars.count < maxLen {
        chars += Array(repeating: " ", count: maxLen - chars.count)
    }
    grid.append(chars)
}

let rowCount = grid.count
let opRow = rowCount - 1

var isSeparator = Array(repeating: true, count: maxLen)
for col in 0..<maxLen {
    for row in 0..<rowCount {
        if grid[row][col] != " " {
            isSeparator[col] = false
            break
        }
    }
}

var ranges: [(Int, Int)] = []
var start: Int? = nil
for col in 0..<maxLen {
    if !isSeparator[col] {
        if start == nil { start = col }
    } else if let s = start {
        ranges.append((s, col - 1))
        start = nil
    }
}
if let s = start {
    ranges.append((s, maxLen - 1))
}

var total: Int64 = 0

for (startCol, endCol) in ranges {
    var numbers: [Int64] = []
    for row in 0..<opRow {
        let slice = String(grid[row][startCol...endCol])
            .trimmingCharacters(in: .whitespaces)
        if let value = Int64(slice), !slice.isEmpty {
            numbers.append(value)
        }
    }

    var op: Character? = nil
    for col in startCol...endCol {
        let ch = grid[opRow][col]
        if ch == "+" || ch == "*" {
            op = ch
            break
        }
    }

    guard let operation = op else { continue }

    var result: Int64 = (operation == "+") ? 0 : 1
    if operation == "+" {
        for value in numbers { result += value }
    } else {
        for value in numbers { result *= value }
    }

    total += result
}

print("Answer: \(total)")
