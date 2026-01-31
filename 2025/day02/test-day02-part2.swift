#!/usr/bin/env swift

import Foundation

// Test with the example from the puzzle
let exampleRanges = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

// Function to check if a number is invalid (made of a sequence repeated at least twice)
func isInvalidID(_ id: Int) -> Bool {
    let digits = String(id)
    let length = digits.count
    
    // Try all possible segment lengths from 1 to length/2
    for segmentLength in 1...(length / 2) {
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

let rangeStrings = exampleRanges.components(separatedBy: ",")
var invalidIDs: [Int] = []

for rangeString in rangeStrings {
    let parts = rangeString.components(separatedBy: "-")
    guard parts.count == 2,
          let start = Int(parts[0]),
          let end = Int(parts[1]) else {
        continue
    }
    
    var rangeInvalidIDs: [Int] = []
    for id in start...end {
        if isInvalidID(id) {
            rangeInvalidIDs.append(id)
            invalidIDs.append(id)
        }
    }
    
    if !rangeInvalidIDs.isEmpty {
        print("Range \(rangeString): invalid IDs = \(rangeInvalidIDs)")
    }
}

let sum = invalidIDs.reduce(0, +)
print("\nSum: \(sum)")
print("Expected: 4174379265, Got: \(sum)")
