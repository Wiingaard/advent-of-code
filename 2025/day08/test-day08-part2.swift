#!/usr/bin/env swift

import Foundation

let exampleInput = """
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689
"""

struct Point {
    let x: Int64
    let y: Int64
    let z: Int64
}

let points: [Point] = exampleInput
    .split(whereSeparator: \.isNewline)
    .map { line in
        let parts = line.split(separator: ",")
        return Point(
            x: Int64(parts[0]) ?? 0,
            y: Int64(parts[1]) ?? 0,
            z: Int64(parts[2]) ?? 0
        )
    }

struct Edge {
    let dist: Int64
    let a: Int
    let b: Int
}

let n = points.count
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
        if uf.components == 1 { break }
    }
}

if let edge = lastEdge {
    let result = points[edge.a].x * points[edge.b].x
    print("Expected: 25272, Got: \(result)")
} else {
    print("Expected: 25272, Got: 0")
}
