#!/usr/bin/env swift

import Foundation

let exampleInput = """
aaa: you hhh
you: bbb ccc
bbb: ddd eee
ccc: ddd eee fff
ddd: ggg
eee: out
fff: out
ggg: out
hhh: ccc fff iii
iii: out
"""

var graph: [String: [String]] = [:]
for line in exampleInput.split(whereSeparator: \.isNewline) {
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
let result = countPaths(from: "you", visiting: &visiting)
print("Expected: 5, Got: \(result)")
