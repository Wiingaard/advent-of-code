@main
public struct TreetopTreeHouse {
    
    enum Direction {
        case up, down, right, left
    }
    
    
    public static func main() {
        
        let treeField = input
            .components(separatedBy: "\n")
            .map { line in
                return line.map { Int(String($0))! }
            }
            
        let hLength = treeField[0].count
        let vLength = treeField.count
        
        var visibleTrees = 0
        var highestViewScore = 0
        
        func isOnEdge(h: Int, v: Int) -> Bool {
            h == 0 || v == 0 || h == hLength || v == vLength
        }
        
        func getDirection(_ direction: Direction, h: Int, v: Int) -> [Int] {
            switch direction {
            case .left:
                let row = treeField[v]
                return row.first(to: h)
            case .right:
                let row = treeField[v]
                return row.last(from: h)
            case .up:
                let col = treeField.map { $0[h] }
                return col.first(to: v)
            case .down:
                let col = treeField.map { $0[h] }
                return col.last(from: v)
            }
        }
        
        func viewDistance(_ direction: Direction, h: Int, v: Int, height: Int) -> Int {
            switch direction {
            case .left:
                let row = treeField[v]
                return row.first(to: h).reversed().viewDirection(height: height)
            case .right:
                let row = treeField[v]
                return row.last(from: h).viewDirection(height: height)
            case .up:
                let col = treeField.map { $0[h] }
                return col.first(to: v).reversed().viewDirection(height: height)
            case .down:
                let col = treeField.map { $0[h] }
                return col.last(from: v).viewDirection(height: height)
            }
        }
        
        treeField.enumerated().forEach { (v, row) in
            
            row.enumerated().forEach { (h, tree) in
                func debug(_ message: String) {
                    print("Tree (\(v),\(h) is: '\(message)'")
                }
                
                /* Uncomment for part 1
                guard !isOnEdge(h: h, v: v) else {
                    visibleTrees += 1
                    debug("Visible from edge")
                    return
                }
                 */
                
                let leftBlocked = getDirection(.left, h: h, v: v).contains { $0 >= tree }
                let rightBlocked = getDirection(.right, h: h, v: v).contains { $0 >= tree }
                let upBlocked = getDirection(.up, h: h, v: v).contains { $0 >= tree }
                let downBlocked = getDirection(.down, h: h, v: v).contains { $0 >= tree }
                
                let visible = !leftBlocked || !rightBlocked || !upBlocked || !downBlocked
                
                if visible {
                    // debug("From center: left \(!leftBlocked) right \(!rightBlocked) up \(!upBlocked) down \(!downBlocked)")
                    visibleTrees += 1
                } else {
                    // debug("Not visible")
                }
                
                let leftView = viewDistance(.left, h: h, v: v, height: tree)
                let rightView = viewDistance(.right, h: h, v: v, height: tree)
                let upView = viewDistance(.up, h: h, v: v, height: tree)
                let downView = viewDistance(.down, h: h, v: v, height: tree)
                
                let viewScore = (leftView * rightView * upView * downView)
                
                if (v == 0 && h == 2) {
                    print("Tree:", tree)
                    print("break")
                }
                
                if viewScore > highestViewScore {
                    debug("New high score \(viewScore)! leftView: \(leftView) rightView: \(rightView) upView: \(upView) downView: \(downView)")
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

