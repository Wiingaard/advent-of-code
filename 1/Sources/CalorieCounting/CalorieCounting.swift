@main
public struct CalorieCounting {
    
    static func sumOfElf(_ elf: String) -> Int {
        elf.components(separatedBy: "\n")
            .map { Int($0)! }
            .reduce(0, +)
    }
    
    public static func main() {
        let calariesSorted = input
            .components(separatedBy: "\n\n")
            .map(sumOfElf)
            .sorted()
        
        print("Elf with most caleries has \(calariesSorted.last!) calaries")
        
        let top3 = calariesSorted.suffix(3).reduce(0, +)
        
        print("The top 3 Elfs carry a total of \(top3) calaries")
    }
}
