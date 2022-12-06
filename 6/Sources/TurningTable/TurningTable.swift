@main
public struct TurningTable {
    
    public static func main() {
        // Part 1
        scanForUniqueLength(4)
        
        // Part 2
        scanForUniqueLength(14)
    }
    
    static func scanForUniqueLength(_ length: Int) {
        var predecessors = ""
        
        func log(_ position: Int, result: String) {
            print("Checking position: \(position) predecessors:\t\(predecessors) result: \(result)")
        }
        
        for (index, character) in input.enumerated() {
            let position = index + 1
            
            if (predecessors.contains { $0 == character }) {
                // log(position, result: "Reset")
                predecessors = "\(character)"
            } else {
                if predecessors.count == length - 1 {
                    log(position, result: "DONE!")
                    break
                } else {
                    // log(position, result: "Add")
                    predecessors += "\(character)"
                }
            }
        }
    }
}
