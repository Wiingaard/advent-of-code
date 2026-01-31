#!/usr/bin/env swift

import Foundation

// Test with the example from the puzzle
let exampleRotations = """
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
"""

var dialPosition = 50
var countAtZero = 0

let rotations = exampleRotations.trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy: .newlines)
    .filter { !$0.isEmpty }

for rotation in rotations {
    guard rotation.count >= 2,
          let direction = rotation.first,
          let distance = Int(String(rotation.dropFirst())) else {
        continue
    }
    
    var zerosInThisRotation = 0
    
    if direction == "L" {
        for step in 1..<distance {
            let position = (dialPosition - step + 100) % 100
            if position == 0 {
                zerosInThisRotation += 1
                countAtZero += 1
            }
        }
        dialPosition = (dialPosition - distance + 100) % 100
        if dialPosition == 0 {
            zerosInThisRotation += 1
            countAtZero += 1
        }
    } else if direction == "R" {
        for step in 1..<distance {
            let position = (dialPosition + step) % 100
            if position == 0 {
                zerosInThisRotation += 1
                countAtZero += 1
            }
        }
        dialPosition = (dialPosition + distance) % 100
        if dialPosition == 0 {
            zerosInThisRotation += 1
            countAtZero += 1
        }
    }
    
    print("After \(rotation): dial at \(dialPosition), zeros during rotation: \(zerosInThisRotation), total: \(countAtZero)")
}

print("\nExpected: 6, Got: \(countAtZero)")
