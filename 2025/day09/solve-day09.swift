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

var maxArea: Int64 = 0
for i in 0..<n {
    let p1 = points[i]
    for j in (i + 1)..<n {
        let p2 = points[j]
        let width = abs(p1.x - p2.x) + 1
        let height = abs(p1.y - p2.y) + 1
        let area = width * height
        if area > maxArea {
            maxArea = area
        }
    }
}

print("Answer: \(maxArea)")
