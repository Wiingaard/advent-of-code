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

let specialMask: [String: Int] = ["dac": 1, "fft": 2]

var memo: [String: Int64] = [:]

func key(_ node: String, _ mask: Int) -> String {
    return "\(node)|\(mask)"
}

func countPaths(from node: String, mask: Int, visiting: inout Set<String>) -> Int64 {
    if node == "out" { return mask == 3 ? 1 : 0 }
    if visiting.contains(node) { return 0 }

    let cacheKey = key(node, mask)
    if let cached = memo[cacheKey] { return cached }

    visiting.insert(node)
    let newMask = mask | (specialMask[node] ?? 0)
    var total: Int64 = 0
    for next in graph[node] ?? [] {
        total += countPaths(from: next, mask: newMask, visiting: &visiting)
    }
    visiting.remove(node)

    memo[cacheKey] = total
    return total
}

var visiting = Set<String>()
let answer = countPaths(from: "svr", mask: 0, visiting: &visiting)
print("Answer: \(answer)")
