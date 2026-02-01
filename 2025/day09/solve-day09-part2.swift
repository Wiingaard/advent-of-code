#!/usr/bin/env swift

import Foundation

let inputFile = "day09.txt"
guard let content = try? String(contentsOfFile: inputFile, encoding: .utf8) else {
    print("Error: Could not read \(inputFile)")
    exit(1)
}

struct Point {
    let x: Int64
    let y: Int64
}

let points: [Point] = content
    .split(whereSeparator: \.isNewline)
    .map { line in
        let parts = line.split(separator: ",")
        return Point(
            x: Int64(parts[0]) ?? 0,
            y: Int64(parts[1]) ?? 0
        )
    }

let n = points.count
if n < 2 {
    print("Answer: 0")
    exit(0)
}

var minX = points[0].x
var maxX = points[0].x
var minY = points[0].y
var maxY = points[0].y

var xSet = Set<Int64>()
var ySet = Set<Int64>()

for p in points {
    minX = min(minX, p.x)
    maxX = max(maxX, p.x)
    minY = min(minY, p.y)
    maxY = max(maxY, p.y)
    xSet.insert(p.x)
    xSet.insert(p.x + 1)
    ySet.insert(p.y)
    ySet.insert(p.y + 1)
}

xSet.insert(minX - 1)
xSet.insert(maxX + 2)
ySet.insert(minY - 1)
ySet.insert(maxY + 2)

let xs = xSet.sorted()
let ys = ySet.sorted()

var xIndex: [Int64: Int] = [:]
for (i, x) in xs.enumerated() { xIndex[x] = i }
var yIndex: [Int64: Int] = [:]
for (i, y) in ys.enumerated() { yIndex[y] = i }

let width = xs.count - 1
let height = ys.count - 1

var boundary = Array(
    repeating: Array(repeating: false, count: width),
    count: height
)

func markHorizontal(x1: Int64, x2: Int64, y: Int64) {
    let minX = min(x1, x2)
    let maxX = max(x1, x2)
    guard let yi = yIndex[y],
          let xi1 = xIndex[minX],
          let xi2 = xIndex[maxX] else { return }
    if xi1 <= xi2 {
        for xi in xi1...xi2 {
            boundary[yi][xi] = true
        }
    }
}

func markVertical(x: Int64, y1: Int64, y2: Int64) {
    let minY = min(y1, y2)
    let maxY = max(y1, y2)
    guard let xi = xIndex[x],
          let yi1 = yIndex[minY],
          let yi2 = yIndex[maxY] else { return }
    if yi1 <= yi2 {
        for yi in yi1...yi2 {
            boundary[yi][xi] = true
        }
    }
}

for i in 0..<n {
    let p1 = points[i]
    let p2 = points[(i + 1) % n]
    if p1.x == p2.x {
        markVertical(x: p1.x, y1: p1.y, y2: p2.y)
    } else {
        markHorizontal(x1: p1.x, x2: p2.x, y: p1.y)
    }
}

var outside = Array(
    repeating: Array(repeating: false, count: width),
    count: height
)

var queue: [(Int, Int)] = [(0, 0)]
outside[0][0] = true

let directions = [(1, 0), (-1, 0), (0, 1), (0, -1)]
var head = 0

while head < queue.count {
    let (y, x) = queue[head]
    head += 1
    for (dy, dx) in directions {
        let ny = y + dy
        let nx = x + dx
        if ny >= 0 && ny < height && nx >= 0 && nx < width {
            if !outside[ny][nx] && !boundary[ny][nx] {
                outside[ny][nx] = true
                queue.append((ny, nx))
            }
        }
    }
}

var prefix = Array(
    repeating: Array(repeating: Int64(0), count: width + 1),
    count: height + 1
)

for y in 0..<height {
    var rowSum: Int64 = 0
    for x in 0..<width {
        let weight: Int64
        if !outside[y][x] {
            let w = xs[x + 1] - xs[x]
            let h = ys[y + 1] - ys[y]
            weight = w * h
        } else {
            weight = 0
        }
        rowSum += weight
        prefix[y + 1][x + 1] = prefix[y][x + 1] + rowSum
    }
}

func rectangleSum(minX: Int64, maxX: Int64, minY: Int64, maxY: Int64) -> Int64 {
    guard let xi1 = xIndex[minX],
          let xi2 = xIndex[maxX],
          let yi1 = yIndex[minY],
          let yi2 = yIndex[maxY] else { return 0 }
    return prefix[yi2 + 1][xi2 + 1]
        - prefix[yi1][xi2 + 1]
        - prefix[yi2 + 1][xi1]
        + prefix[yi1][xi1]
}

var maxArea: Int64 = 0
for i in 0..<n {
    let p1 = points[i]
    for j in (i + 1)..<n {
        let p2 = points[j]
        let minX = min(p1.x, p2.x)
        let maxX = max(p1.x, p2.x)
        let minY = min(p1.y, p2.y)
        let maxY = max(p1.y, p2.y)
        let area = (maxX - minX + 1) * (maxY - minY + 1)
        if area <= maxArea { continue }
        if rectangleSum(minX: minX, maxX: maxX, minY: minY, maxY: maxY) == area {
            maxArea = area
        }
    }
}

print("Answer: \(maxArea)")
