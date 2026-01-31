#!/usr/bin/env swift

import Foundation

// Test with the example from the puzzle
let exampleRanges = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

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
print("Expected: 1227775554, Got: \(sum)")
