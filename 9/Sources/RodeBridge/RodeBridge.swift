@main
public struct RodeBridge {

    public static func main() {
        let shortRope = Rope(length: 2)
        let longRope = Rope(length: 10)
        
        input
            .components(separatedBy: "\n")
            .map(Movement.init)
            .forEach { movement in
                shortRope.move(movement)
                longRope.move(movement)
            }
        
        print("Tail visited locations:")
        print("Short rope (Part 1): \(shortRope.tailPositionLog.count)") // 6256
        print("Long rope (Part 2): \(longRope.tailPositionLog.count)") // 2665
    }
}

class Rope {
    
    private let length: Int
    private var positions: [Position]
    
    init(length: Int) {
        self.length = length
        self.positions = Array(repeating: .init(x: 0, y: 0), count: length)
    }
    
    var tailPositionLog: Set<Position> = []
    
    func move(_ movement: Movement) {
        for _ in 1...movement.distance {
            updateMove(movement.direction)
        }
    }
    
    private func updateMove(_ direction: Direction) {
        positions[0] = positions[0].move(direction)
        
        for index in 1...(length-1) {
            let inFront = positions[index-1]
            let current = positions[index]
            if inFront.distance(to: current) > 1 {
                let moves = current.directions(to: inFront)
                positions[index] = current.diagonal(moves)
            }
        }
        
        tailPositionLog.insert(positions.last!)
    }
}

struct Position: Hashable {
    let x: Int
    let y: Int
    
    func move(_ direction: Direction) -> Position {
        switch direction {
        case .up: return .init(x: x, y: y+1)
        case .down: return .init(x: x, y: y-1)
        case .left: return .init(x: x-1, y: y)
        case .right: return .init(x: x+1, y: y)
        }
    }
    
    func diagonal(_ moves: [Direction]) -> Position {
        return moves.reduce(self) { $0.move($1) }
    }
    
    func distance(to other: Position) -> Int {
        let xDistance = abs(x - other.x)
        let yDistance = abs(y - other.y)
        return max(xDistance, yDistance)
    }
    
    func directions(to other: Position) -> [Direction] {
        var positions: [Direction] = []
        if other.y > y { positions.append(.up) }
        if other.y < y { positions.append(.down) }
        if other.x < x { positions.append(.left) }
        if other.x > x { positions.append(.right) }
        return positions
    }
}

enum Direction: String {
    case up = "U"
    case down = "D"
    case left = "L"
    case right = "R"
}

struct Movement {
    let direction: Direction
    let distance: Int
    
    init(_ input: String) {
        let c = input.components(separatedBy: " ")
        direction = Direction(rawValue: c[0])!
        distance = Int(c[1])!
    }
}
