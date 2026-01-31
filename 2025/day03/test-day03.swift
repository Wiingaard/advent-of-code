#!/usr/bin/env swift

import Foundation

// Test data from the puzzle description
let testBanks = [
    "987654321111111",
    "811111111111119",
    "234234234234278",
    "818181911112111"
]

let expectedResults = [98, 89, 78, 92]
let expectedTotal = 357

// Function to find maximum joltage from a bank (Part 1)
func maxJoltage(bank: String) -> Int {
    let digits = Array(bank).compactMap { $0.wholeNumberValue }
    guard digits.count >= 2 else { return 0 }
    
    // Precompute suffix maximum
    var suffixMax = Array(repeating: 0, count: digits.count)
    suffixMax[digits.count - 1] = digits[digits.count - 1]
    for i in stride(from: digits.count - 2, through: 0, by: -1) {
        suffixMax[i] = max(digits[i], suffixMax[i + 1])
    }
    
    // For each position i, find best joltage
    var maxJolt = 0
    for i in 0..<(digits.count - 1) {
        let firstDigit = digits[i]
        let secondDigit = suffixMax[i + 1]
        let joltage = firstDigit * 10 + secondDigit
        maxJolt = max(maxJolt, joltage)
    }
    
    return maxJolt
}

// Run tests
var allPassed = true
var total = 0

print("Testing Part 1:")
for (i, bank) in testBanks.enumerated() {
    let result = maxJoltage(bank: bank)
    total += result
    let passed = result == expectedResults[i]
    let status = passed ? "PASS" : "FAIL"
    print("  Bank \(i + 1): \(bank) -> \(result) (expected \(expectedResults[i])) [\(status)]")
    if !passed { allPassed = false }
}

let totalPassed = total == expectedTotal
let totalStatus = totalPassed ? "PASS" : "FAIL"
print("  Total: \(total) (expected \(expectedTotal)) [\(totalStatus)]")
if !totalPassed { allPassed = false }

print("")
if allPassed {
    print("All tests passed!")
} else {
    print("Some tests failed!")
    exit(1)
}
