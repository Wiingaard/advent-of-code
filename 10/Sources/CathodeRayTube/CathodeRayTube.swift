@main
public struct CathodeRayTube {
    
    public static func main() {
        let instructions = input
            .components(separatedBy: "\n")
            .map(Instruction.init)
            
        let cpu = CPU(instructions: instructions)
        
        // Part 1
        cpu.run()
        print("Sum of signal strength:", cpu.totalSignalStrength) // Correct answer: 15020
        
        // Part 2
        cpu.crt.dump() // Correct answer: EFUGLPAP
    }
}

class CPU {
    
    private let instructions: [Instruction]
    init(instructions: [Instruction]) {
        self.instructions = instructions
    }
    
    let crt = CRT()
    var totalSignalStrength = 0
    
    func run() {
        var register = 1
        var cycle = 1
        var meassureCycles = [20, 60, 100, 140, 180, 220]
        
        instructions
            .flatMap { instruction -> [Instruction] in
                switch instruction {
                case .noop:
                    return [instruction]
                case .add:
                    return [.noop, instruction]
                }
            }.forEach { instruction in
                if meassureCycles.contains(cycle) {
                    let signalStrength = register * cycle
                    totalSignalStrength += signalStrength
                }
                
                crt.run(cycle: cycle, sprintPosition: register)
                
                cycle += 1
                
                if case .add(let value) = instruction {
                    register += value
                }
            }
    }
}

class CRT {
    static let emptyRow = [Bool].init(repeating: false, count: 40)
    static let emptyDisplay = [[Bool]].init(repeating: emptyRow, count: 6)
    private var pixels: [[Bool]] = emptyDisplay
    
    func run(cycle: Int, sprintPosition: Int) {
        let pixelPosition = (cycle-1) % 40
        let row = (cycle-1) / 40
        let hitSprite = (sprintPosition-1...sprintPosition+1).contains(pixelPosition)
        pixels[row][pixelPosition] = hitSprite
    }
    
    func dump() {
        pixels.forEach { line in
            print(line.map { $0 ? "#": "." }.joined())
        }
    }
    
}

enum Instruction {
    case noop
    case add(value: Int)
    
    init(_ input: String) {
        if input == "noop" {
            self = .noop
        } else {
            let value = Int(input.components(separatedBy: " ")[1])!
            self = .add(value: value)
        }
    }
}
