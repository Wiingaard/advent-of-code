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
    
    if direction == "L" {
        dialPosition = (dialPosition - distance + 100) % 100
    } else if direction == "R" {
        dialPosition = (dialPosition + distance) % 100
    }
    
    print("After \(rotation): dial at \(dialPosition)")
    
    if dialPosition == 0 {
        countAtZero += 1
        print("  -> At zero! (count: \(countAtZero))")
    }
}

print("\nExpected: 3, Got: \(countAtZero)")
