#!/usr/bin/env swift

import Foundation

let exampleInput = """
svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out
"""

var graph: [String: [String]] = [:]
for line in exampleInput.split(whereSeparator: \.isNewline) {
    let parts = line.split(separator: ":", maxSplits: 1)
    guard parts.count == 2 else { continue }
    let node = parts[0].trimmingCharacters(in: .whitespaces)
    let outputs = parts[1].split(whereSeparator: \.isWhitespace).map(String.init)
    graph[node] = outputs
}

let specialMask: [String: Int] = ["dac": 1, "fft": 2]

var memo: [String: Int64] = [:]
func key(_ node: String, _ mask: Int) -> String { "\(node)|\(mask)" }

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
let result = countPaths(from: "svr", mask: 0, visiting: &visiting)
print("Expected: 2, Got: \(result)")
