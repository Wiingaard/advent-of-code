import Foundation
import Parsing

@main
public struct SupplyStacks {
    
    /**
     NOTICE
     I ended up not solving this pussle!
     There's some raceissue in the way the crane is popping and pushing elements.
     The final outcome is not deterministic.
     If I had more time, I would have re-write it into not using a `var stacks`, but instead
     reduce into an immutable stacks object. Also, not use an Dictionary, but two-dimentional array instead.
     I also tried with a dispatch quere instead of BlockOperation.
     
     Edit: I forgot to sorte the final dictionary before printing it 🤦‍♂️
     */
    public static func main() async {
        
        let instructions = try! Many {
            InstructionSet.parser
        } separator: {
            "\n"
        }.parse(instructionsInput)
        
        
        let crane = Crane()
        
        crane.run(instructions)
        
        print("Done:", crane.stacks)
        
        let lastElements = crane.stacks
            .sorted { $0.key < $1.key }
            .map { String($1.last ?? "_") }
            .joined()
        
        print("Last elements:", lastElements) // RFFFWBPNS -> RFFFWBPNS
    }
}

class Crane {
    
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
            moveMultiple(set)
        }
    }
    
    private func move(from: Int, to: Int) {
        guard let elementToMove = self.stacks[from]?.popLast() else {
            fatalError("No element found")
        }
        print("Move: ", elementToMove, "to:", to)
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

