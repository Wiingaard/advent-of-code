import Foundation
import Parsing

@main
public struct SupplyStacks {
    
    public static func main() async {
        
        let instructions = try! Many {
            InstructionSet.parser
        } separator: {
            "\n"
        }.parse(instructionsInput)
        
        
        var crane = Crane(model: .part1)
        crane.run(instructions)
        crane.printTopCrates()
        
        crane = Crane(model: .part2)
        crane.run(instructions)
        crane.printTopCrates()
    }
}

class Crane {
    enum Model {
        case part1
        case part2
    }
    
    let model: Model
    
    init(model: Model) {
        self.model = model
    }
    
    var stacks: Dictionary<Int, [Character]> = [
        1: ["D", "Z", "T", "H"].reversed(),
        2: ["S","C","G","T","W","R","Q"].reversed(),
        3: ["H","C","R","N","Q","F","B","P"].reversed(),
        4: ["Z","H","F","N","C","L"].reversed(),
        5: ["S","Q","F","L","G"].reversed(),
        6: ["S","C","R","B","Z","W","P","V"].reversed(),
        7: ["J","F","Z"].reversed(),
        8: ["Q","H","R","Z","V","L","D"].reversed(),
        9: ["D","L","Z","F","N","G","H","B"].reversed()
    ]
    
    func run(_ instructions: [InstructionSet]) {
        for set in instructions {
            switch model {
            case .part1:
                for _ in 1...set.count {
                    self.move(from: set.from, to: set.to)
                }
            case .part2:
                moveMultiple(set)
            }
        }
    }
    
    private func move(from: Int, to: Int) {
        let elementToMove = self.stacks[from]!.popLast()!
        self.stacks[to]?.append(elementToMove)
    }
    
    private func moveMultiple(_ set: InstructionSet) {
        func pop() -> Character {
            return self.stacks[set.from]!.popLast()!
        }
        var _elements: [Character] = []
        for _ in 1...set.count {
            _elements.append(pop())
        }
        
        self.stacks[set.to]!.append(contentsOf: _elements.reversed())
    }
    
    func printTopCrates() {
        let lastElements = stacks
            .sorted { $0.key < $1.key }
            .map { String($1.last ?? "_") }
            .joined()
        print("Crane model from \(model):", lastElements)
    }
}

struct InstructionSet: Hashable {
    let count: Int
    let from: Int
    let to: Int
    
    static let parser = Parse(InstructionSet.init) {
        "move "
        Int.parser()
        " from "
        Int.parser()
        " to "
        Int.parser()
    }
}


typealias Stacks = Dictionary<Int, [Character]>

