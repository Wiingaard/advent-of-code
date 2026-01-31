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

// Function to find maximum joltage from a bank
// We need to select exactly two batteries at positions i < j
// The joltage is digit[i] * 10 + digit[j]
func maxJoltage(bank: String) -> Int {
    let digits = Array(bank).compactMap { $0.wholeNumberValue }
    guard digits.count >= 2 else { return 0 }
    
    // Precompute suffix maximum: for each position i, what's the max digit from i+1 to end
    var suffixMax = Array(repeating: 0, count: digits.count)
    suffixMax[digits.count - 1] = digits[digits.count - 1]
    for i in stride(from: digits.count - 2, through: 0, by: -1) {
        suffixMax[i] = max(digits[i], suffixMax[i + 1])
    }
    
    // For each position i (first battery), the best second battery is the max after i
    var maxJolt = 0
    for i in 0..<(digits.count - 1) {
        let firstDigit = digits[i]
        let secondDigit = suffixMax[i + 1]
        let joltage = firstDigit * 10 + secondDigit
        maxJolt = max(maxJolt, joltage)
    }
    
    return maxJolt
}

// Calculate total joltage
var totalJoltage = 0
for bank in banks {
    totalJoltage += maxJoltage(bank: bank)
}

print("Answer: \(totalJoltage)")
