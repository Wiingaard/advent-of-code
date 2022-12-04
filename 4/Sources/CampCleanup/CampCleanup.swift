@main
public struct CampCleanup {
    
    public static func main() {
        let pairs = input
            .components(separatedBy: "\n")
            .map(Pair.init)
        
        let part1Solution = pairs.filter { $0.isOneRangeFullyCovered }.count
        
        print("Part 1 solution: \(part1Solution)")
        
        let part2Solution = pairs.filter { $0.isRangesOverlapping }.count
        
        print("Part 2 solution: \(part2Solution)")
        
    }
}

struct Pair {
    let left: SectionRange
    let right: SectionRange
    
    var isOneRangeFullyCovered: Bool {
        left.range.isSubset(of: right.range) || right.range.isSubset(of: left.range)
    }
    
    var isRangesOverlapping: Bool {
        !left.range.isDisjoint(with: right.range)
    }
    
    init(_ input: String) {
        let parts = input.components(separatedBy: ",")
        left = SectionRange(parts[0])
        right = SectionRange(parts[1])
    }
}

struct SectionRange {
    let beginIndex: Int
    let endIndex: Int
    
    var range: Set<Int> {
        Set(beginIndex...endIndex)
    }
    
    init(_ input: String) {
        let parts = input.components(separatedBy: "-")
        beginIndex = Int(parts[0])!
        endIndex = Int(parts[1])!
    }
}
