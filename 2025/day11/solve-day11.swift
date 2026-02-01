#!/usr/bin/env swift

import Foundation

let inputFile = "day11.txt"
guard let content = try? String(contentsOfFile: inputFile, encoding: .utf8) else {
    print("Error: Could not read \(inputFile)")
    exit(1)
}

var graph: [String: [String]] = [:]

for line in content.split(whereSeparator: \.isNewline) {
    let parts = line.split(separator: ":", maxSplits: 1)
    guard parts.count == 2 else { continue }
    let node = parts[0].trimmingCharacters(in: .whitespaces)
    let outputs = parts[1].split(whereSeparator: \.isWhitespace).map(String.init)
    graph[node] = outputs
}

var memo: [String: Int64] = [:]

func countPaths(from node: String, visiting: inout Set<String>) -> Int64 {
    if node == "out" { return 1 }
    if visiting.contains(node) { return 0 }
    if let cached = memo[node] { return cached }

    visiting.insert(node)
    var total: Int64 = 0
    for next in graph[node] ?? [] {
        total += countPaths(from: next, visiting: &visiting)
    }
    visiting.remove(node)

    memo[node] = total
    return total
}

var visiting = Set<String>()
let answer = countPaths(from: "you", visiting: &visiting)
print("Answer: \(answer)")
