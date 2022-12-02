@main
public struct RockPaperScissors {
        
    public static func main() {
        
        let scorePart1 = input.components(separatedBy: "\n")
            .map(Game_1.init)
            .map { game in
                let outcomeScore = game.play().score
                let handScore = game.right.score
                return outcomeScore + handScore
            }.reduce(0, +)
        
        print("Score part 1: \(scorePart1)")
        
        let scorePart2 = input.components(separatedBy: "\n")
            .map(Game_2.init)
            .map { game in
                let outcoreScore = game.outcome.score
                let handScore = game.determineHand().score
                return outcoreScore + handScore
            }
            .reduce(0, +)
            
        print("Score part 2: \(scorePart2)")
    }
}

struct Game_1 {
    let left: Hand
    let right: Hand
    
    init(_ input: String) {
        let sides = input.components(separatedBy: " ")
        left = Hand(sides[0])
        right = Hand(sides[1])
    }
    
    /// Determine the outcome of the game when playing as right side
    func play() -> GameOutcome {
        switch (left, right) {
        case (.rock, .rock), (.paper, .paper), (.scissor, .scissor): return .draw
        case (.rock, .scissor), (.paper, .rock), (.scissor, .paper): return .lost
        case (.rock, .paper), (.paper, .scissor), (.scissor, .rock): return .win
        }
    }
}

struct Game_2 {
    let left: Hand
    let outcome: GameOutcome
    
    init(_ input: String) {
        let sides = input.components(separatedBy: " ")
        left = Hand(sides[0])
        outcome = GameOutcome(sides[1])
    }
    
    /// Determin the right hand needed to satisfy outcome
    func determineHand() -> Hand {
        switch (left, outcome) {
        case (.rock, .draw), (.paper, .lost), (.scissor, .win): return .rock
        case (.rock, .win), (.paper, .draw), (.scissor, .lost): return .paper
        case (.rock, .lost), (.paper, .win), (.scissor, .draw): return .scissor
        }
    }
}

enum Hand {
    case rock
    case paper
    case scissor
    
    init(_ input: String) {
        switch input {
        case "A", "X": self = .rock
        case "B", "Y": self = .paper
        case "C", "Z": self = .scissor
        default: fatalError()
        }
    }
    
    var score: Int {
        switch self {
        case .rock: return 1
        case .paper: return 2
        case .scissor: return 3
        }
    }
}

enum GameOutcome {
    case win
    case lost
    case draw
    
    var score: Int {
        switch self {
        case .win: return 6
        case .lost: return 0
        case .draw: return 3
        }
    }
    
    init(_ input: String) {
        switch input {
        case "X": self = .lost
        case "Y": self = .draw
        case "Z": self = .win
        default: fatalError()
        }
    }
}

enum Side {
    case left
    case right
}
