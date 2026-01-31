#!/usr/bin/env swift

import Foundation

// Read the input file
let inputFile = "day01.txt"
guard let content = try? String(contentsOfFile: inputFile, encoding: .utf8) else {
    print("Error: Could not read \(inputFile)")
    exit(1)
}

// Parse rotations
let rotations = content.trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy: .newlines)
    .filter { !$0.isEmpty }

// Initialize dial position and counter
var dialPosition = 50
var countAtZero = 0

// Process each rotation
for rotation in rotations {
    // Parse direction and distance
    guard rotation.count >= 2,
          let direction = rotation.first,
          let distance = Int(String(rotation.dropFirst())) else {
        print("Error: Invalid rotation format: \(rotation)")
        continue
    }
    
    // Count zeros during the rotation (check every click, excluding starting position)
    if direction == "L" {
        // Left: check intermediate positions (steps 1 to distance-1) and final position
        for step in 1..<distance {
            let position = (dialPosition - step + 100) % 100
            if position == 0 {
                countAtZero += 1
            }
        }
        // Update final position and check it
        dialPosition = (dialPosition - distance + 100) % 100
        if dialPosition == 0 {
            countAtZero += 1
        }
    } else if direction == "R" {
        // Right: check intermediate positions (steps 1 to distance-1) and final position
        for step in 1..<distance {
            let position = (dialPosition + step) % 100
            if position == 0 {
                countAtZero += 1
            }
        }
        // Update final position and check it
        dialPosition = (dialPosition + distance) % 100
        if dialPosition == 0 {
            countAtZero += 1
        }
    } else {
        print("Error: Invalid direction: \(direction)")
        continue
    }
}

print("Answer: \(countAtZero)")
