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
    
    // Apply rotation
    if direction == "L" {
        // Left: subtract distance (with wrapping)
        dialPosition = (dialPosition - distance + 100) % 100
    } else if direction == "R" {
        // Right: add distance (with wrapping)
        dialPosition = (dialPosition + distance) % 100
    } else {
        print("Error: Invalid direction: \(direction)")
        continue
    }
    
    // Check if dial is at 0
    if dialPosition == 0 {
        countAtZero += 1
    }
}

print("Answer: \(countAtZero)")
