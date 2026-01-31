#!/usr/bin/env swift

import Foundation

// Read the input file
let inputFile = "day03.txt"
guard let content = try? String(contentsOfFile: inputFile, encoding: .utf8) else {
    print("Error: Could not read \(inputFile)")
    exit(1)
}

// Parse banks (each line is a bank of batteries)
let banks = content.trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy: .newlines)
    .filter { !$0.isEmpty }

// Function to find maximum joltage from a bank by selecting exactly 12 batteries
// Uses greedy algorithm: for each position, pick the largest digit that leaves
// enough remaining digits to complete the selection
func maxJoltage12(bank: String) -> Int {
    let digits = Array(bank).compactMap { $0.wholeNumberValue }
    let n = digits.count
    let k = 12  // Number of batteries to select
    
    guard n >= k else { return 0 }
    
    var result: [Int] = []
    var start = 0
    
    for i in 0..<k {
        let remainingPicks = k - i - 1  // How many more digits we need after this one
        let end = n - remainingPicks    // Last valid position for this pick (exclusive)
        
        // Find the maximum digit in range [start, end)
        var maxDigit = -1
        var maxPos = start
        for j in start..<end {
            if digits[j] > maxDigit {
                maxDigit = digits[j]
                maxPos = j
            }
        }
        
        result.append(maxDigit)
        start = maxPos + 1  // Next pick must be after this position
    }
    
    // Convert to number
    var number = 0
    for digit in result {
        number = number * 10 + digit
    }
    
    return number
}

// Calculate total joltage
var totalJoltage = 0
for bank in banks {
    totalJoltage += maxJoltage12(bank: bank)
}

print("Answer: \(totalJoltage)")
