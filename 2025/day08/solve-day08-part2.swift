#!/usr/bin/env swift

import Foundation

let inputFile = "day08.txt"
guard let content = try? String(contentsOfFile: inputFile, encoding: .utf8) else {
    print("Error: Could not read \(inputFile)")
    exit(1)
}

struct Point {
    let x: Int64
    let y: Int64
    let z: Int64
}

let points: [Point] = content
    .split(whereSeparator: \.isNewline)
    .map { line in
        let parts = line.split(separator: ",")
        return Point(
            x: Int64(parts[0]) ?? 0,
            y: Int64(parts[1]) ?? 0,
            z: Int64(parts[2]) ?? 0
        )
    }

let n = points.count
if n == 0 {
    print("Answer: 0")
    exit(0)
}

struct Edge {
    let dist: Int64
    let a: Int
    let b: Int
}

var edges: [Edge] = []
edges.reserveCapacity(n * (n - 1) / 2)

for i in 0..<n {
    let p1 = points[i]
    for j in (i + 1)..<n {
        let p2 = points[j]
        let dx = p1.x - p2.x
        let dy = p1.y - p2.y
        let dz = p1.z - p2.z
        let dist = dx * dx + dy * dy + dz * dz
        edges.append(Edge(dist: dist, a: i, b: j))
    }
}

edges.sort {
    if $0.dist != $1.dist { return $0.dist < $1.dist }
    if $0.a != $1.a { return $0.a < $1.a }
    return $0.b < $1.b
}

struct UnionFind {
    var parent: [Int]
    var size: [Int]
    var components: Int

    init(_ n: Int) {
        parent = Array(0..<n)
        size = Array(repeating: 1, count: n)
        components = n
    }

    mutating func find(_ x: Int) -> Int {
        var node = x
        while parent[node] != node {
            parent[node] = parent[parent[node]]
            node = parent[node]
        }
        return node
    }

    mutating func union(_ a: Int, _ b: Int) -> Bool {
        let rootA = find(a)
        let rootB = find(b)
        if rootA == rootB { return false }
        if size[rootA] < size[rootB] {
            parent[rootA] = rootB
            size[rootB] += size[rootA]
        } else {
            parent[rootB] = rootA
            size[rootA] += size[rootB]
        }
        components -= 1
        return true
    }
}

var uf = UnionFind(n)
var lastEdge: Edge? = nil

for edge in edges {
    if uf.union(edge.a, edge.b) {
        lastEdge = edge
        if uf.components == 1 {
            break
        }
    }
}

guard let finalEdge = lastEdge else {
    print("Answer: 0")
    exit(0)
}

let result = points[finalEdge.a].x * points[finalEdge.b].x
print("Answer: \(result)")
