#!/usr/bin/env swift

import Foundation

// Test data from the puzzle description
let testBanks = [
    "987654321111111",
    "811111111111119",
    "234234234234278",
    "818181911112111"
]

let expectedResults: [Int] = [987654321111, 811111111119, 434234234278, 888911112111]
let expectedTotal: Int = 3121910778619

// Function to find maximum joltage from a bank by selecting exactly 12 batteries (Part 2)
func maxJoltage12(bank: String) -> Int {
    let digits = Array(bank).compactMap { $0.wholeNumberValue }
    let n = digits.count
    let k = 12  // Number of batteries to select
    
    guard n >= k else { return 0 }
    
    var result: [Int] = []
    var start = 0
    
    for i in 0..<k {
        let remainingPicks = k - i - 1
        let end = n - remainingPicks
        
        var maxDigit = -1
        var maxPos = start
        for j in start..<end {
            if digits[j] > maxDigit {
                maxDigit = digits[j]
                maxPos = j
            }
        }
        
        result.append(maxDigit)
        start = maxPos + 1
    }
    
    var number = 0
    for digit in result {
        number = number * 10 + digit
    }
    
    return number
}

// Run tests
var allPassed = true
var total = 0

print("Testing Part 2:")
for (i, bank) in testBanks.enumerated() {
    let result = maxJoltage12(bank: bank)
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
