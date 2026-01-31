#!/usr/bin/env swift

import Foundation

// Read the input file
let inputFile = "day02.txt"
guard let content = try? String(contentsOfFile: inputFile, encoding: .utf8) else {
    print("Error: Could not read \(inputFile)")
    exit(1)
}

// Parse ranges (remove newlines and split by comma)
let rangesString = content.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\n", with: "")
let rangeStrings = rangesString.components(separatedBy: ",").filter { !$0.isEmpty }

// Function to check if a number is invalid (made of a sequence repeated twice)
func isInvalidID(_ id: Int) -> Bool {
    let digits = String(id)
    let length = digits.count
    
    // Must have even number of digits
    guard length % 2 == 0 else { return false }
    
    // Split into two halves
    let halfLength = length / 2
    let firstHalf = String(digits.prefix(halfLength))
    let secondHalf = String(digits.suffix(halfLength))
    
    // Check if first half equals second half
    return firstHalf == secondHalf
}

// Process all ranges and collect invalid IDs
var invalidIDs: [Int] = []

for rangeString in rangeStrings {
    let parts = rangeString.components(separatedBy: "-")
    guard parts.count == 2,
          let start = Int(parts[0]),
          let end = Int(parts[1]) else {
        print("Error: Invalid range format: \(rangeString)")
        continue
    }
    
    // Check each ID in the range
    for id in start...end {
        if isInvalidID(id) {
            invalidIDs.append(id)
        }
    }
}

// Sum all invalid IDs
let sum = invalidIDs.reduce(0, +)
print("Answer: \(sum)")
