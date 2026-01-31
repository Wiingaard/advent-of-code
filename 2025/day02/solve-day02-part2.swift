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

// Function to check if a number is invalid (made of a sequence repeated at least twice)
func isInvalidID(_ id: Int) -> Bool {
    let digits = String(id)
    let length = digits.count
    
    // Need at least 2 digits to be invalid
    guard length >= 2 else { return false }
    
    // Try all possible segment lengths from 1 to length/2
    let maxSegmentLength = length / 2
    guard maxSegmentLength >= 1 else { return false }
    
    for segmentLength in 1...maxSegmentLength {
        // Check if length is divisible by segment length
        guard length % segmentLength == 0 else { continue }
        
        let numSegments = length / segmentLength
        guard numSegments >= 2 else { continue }
        
        // Extract the first segment
        let firstSegment = String(digits.prefix(segmentLength))
        
        // Check if all segments match
        var allMatch = true
        for i in 1..<numSegments {
            let startIndex = digits.index(digits.startIndex, offsetBy: i * segmentLength)
            let endIndex = digits.index(startIndex, offsetBy: segmentLength)
            let segment = String(digits[startIndex..<endIndex])
            
            if segment != firstSegment {
                allMatch = false
                break
            }
        }
        
        if allMatch {
            return true
        }
    }
    
    return false
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
