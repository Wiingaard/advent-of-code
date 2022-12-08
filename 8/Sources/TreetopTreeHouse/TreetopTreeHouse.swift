@main
public struct TreetopTreeHouse {
    
    enum Direction {
        case up, down, right, left
    }
    
    public static func main() {
        
        let treeField = input
            .components(separatedBy: "\n")
            .map { $0.map { Int(String($0))! } }
        
        var visibleTrees = 0
        var highestViewScore = 0
        
        func getDirection(_ direction: Direction, h: Int, v: Int) -> [Int] {
            switch direction {
            case .left:
                let row = treeField[v]
                return row.first(to: h).reversed()
            case .right:
                let row = treeField[v]
                return row.last(from: h)
            case .up:
                let col = treeField.map { $0[h] }
                return col.first(to: v).reversed()
            case .down:
                let col = treeField.map { $0[h] }
                return col.last(from: v)
            }
        }
        
        treeField.enumerated().forEach { (v, row) in
            row.enumerated().forEach { (h, tree) in
                func debug(_ message: String) {
                    print("Tree (\(v),\(h) is: '\(message)'")
                }
                
                // Part 1
                let leftTrees = getDirection(.left, h: h, v: v)
                let rightTrees = getDirection(.right, h: h, v: v)
                let upTrees = getDirection(.up, h: h, v: v)
                let downTrees = getDirection(.down, h: h, v: v)
                
                let leftBlocked = leftTrees.contains { $0 >= tree }
                let rightBlocked = rightTrees.contains { $0 >= tree }
                let upBlocked = upTrees.contains { $0 >= tree }
                let downBlocked = downTrees.contains { $0 >= tree }
                
                if !leftBlocked || !rightBlocked || !upBlocked || !downBlocked {
                    visibleTrees += 1
                }
                
                // Part 2
                let leftView = leftTrees.viewDirection(height: tree)
                let rightView = rightTrees.viewDirection(height: tree)
                let upView = upTrees.viewDirection(height: tree)
                let downView = downTrees.viewDirection(height: tree)
                
                let viewScore = (leftView * rightView * upView * downView)
                
                if viewScore > highestViewScore {
                    highestViewScore = viewScore
                }
            }
        }
        
        print("Total Trees:", visibleTrees) // COrrect answer: 1698
        print("Highest View Score:", highestViewScore) // Correct answer: 672280
    }
}

extension Array where Element == Int {
    
    func last(from index: Int) -> [Int] {
        let array = self.suffix(from: index)
        return Array(array.dropFirst())
    }
    
    func first(to index: Int) -> [Int] {
        guard index < self.count else { return self }
        return Array(self.prefix(upTo: index))
    }
    
    func viewDirection(height: Int) -> Int {
        guard !isEmpty else { return 0 }
        
        guard let index = (firstIndex { $0 >= height }) else {
            return count
        }
        
        return distance(from: startIndex, to: index) + 1
    }
}
