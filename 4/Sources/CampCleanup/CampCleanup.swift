import Parsing

@main
public struct CampCleanup {
    
    public static func main() {
        
        let pairs = try! Many {
            Pair.parser
        } separator: {
            "\n"
        }.parse(input)
        
        let part1Solution = pairs
            .filter { $0.isOneRangeFullyCovered }
            .count
        
        print("Part 1 solution: \(part1Solution)")
        
        let part2Solution = pairs
            .filter { $0.isRangesOverlapping }
            .count
        
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
    
    static let parser = Parse(Pair.init) {
        SectionRange.parser
        ","
        SectionRange.parser
    }
}

struct SectionRange {
    let beginIndex: Int
    let endIndex: Int
    
    var range: Set<Int> {
        Set(beginIndex...endIndex)
    }
    
    static let parser = Parse(SectionRange.init) {
        Int.parser()
        "-"
        Int.parser()
    }
}
