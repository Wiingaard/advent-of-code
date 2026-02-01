#!/usr/bin/env swift

import Foundation

let exampleInput = """
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
"""

struct Point {
    let x: Int64
    let y: Int64
}

let points: [Point] = exampleInput
    .split(whereSeparator: \.isNewline)
    .map { line in
        let parts = line.split(separator: ",")
        return Point(
            x: Int64(parts[0]) ?? 0,
            y: Int64(parts[1]) ?? 0
        )
    }

var maxArea: Int64 = 0
for i in 0..<points.count {
    let p1 = points[i]
    for j in (i + 1)..<points.count {
        let p2 = points[j]
        let width = abs(p1.x - p2.x) + 1
        let height = abs(p1.y - p2.y) + 1
        let area = width * height
        if area > maxArea {
            maxArea = area
        }
    }
}

print("Expected: 50, Got: \(maxArea)")
