@main
public struct RucksackReorganization {
    
    public static func main() {
        
        let rucksacks = input
            .components(separatedBy: "\n")
        
        let part1Solution = rucksacks
            .map(Rucksack.init)
            .map { $0.duplicateItem.score }
            .reduce(0, +)
        
        print("Part 1 solution: \(part1Solution)")
        
        let enumeratedRucksacks = rucksacks
            .enumerated()
            
        let part2Solution = Dictionary(grouping: enumeratedRucksacks) { $0.offset / 3 }
            .map { $0.1.map { $0.element } }
            .map(Group.init)
            .map { $0.badge.score }
            .reduce(0, +)
        
        print("Part 2 solution: \(part2Solution)")
        
    }
}

struct Rucksack {
    let items: String
    var compartmentSize: Int { items.count / 2 }
    
    var duplicateItem: Character {
        let right = Set(items.suffix(compartmentSize))
        let left = Set(items.prefix(compartmentSize))
        return left.intersection(right).first!
    }
}

struct Group {
    let rucksacks: [String]
    
    var badge: Character {
        rucksacks.dropFirst()
            .reduce(Set(rucksacks[0])) {
                $0.intersection(Set($1))
            }.first!
    }
}

extension Character {
    static let lowercaseBaseValue = "a".first!.asciiValue!
    static let uppercaseBaseValue = "A".first!.asciiValue!
    
    var score: Int {
        if isLowercase {
            return Int(asciiValue! - Self.lowercaseBaseValue) + 1
        } else {
            return Int(asciiValue! - Self.uppercaseBaseValue) + 27
        }
    }
}
