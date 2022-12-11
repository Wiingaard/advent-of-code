@main
public struct MonkeyInTheMiddle {
    
    public static func main() {
        let monkeysPart1 = MonkeyGroup(relief: 3)
        monkeysPart1.runRounds(20)
        monkeysPart1.checkBusiness()
        
        let monkeysPart2 = MonkeyGroup(relief: 1)
        monkeysPart2.runRounds(10000)
        monkeysPart2.checkBusiness()
    }
}


class MonkeyGroup {
    
    private let monkeys: Dictionary<Int, Monkey> = [
        0: _monkey0(),
        1: _monkey1(),
        2: _monkey2(),
        3: _monkey3(),
        4: _monkey4(),
        5: _monkey5(),
        6: _monkey6(),
        7: _monkey7()
    ]
    
    private let relief: Double
    private let commonDivisor: Double
    
    init(relief: Double) {
        self.relief = relief
        self.commonDivisor = monkeys.values.reduce(1) { $0 * $1.testDivisible }

        monkeys.values.forEach { monkey in
            monkey.monkeyBusiness = self
        }
    }
    
    func runRounds(_ rounds: Int) {
        for _ in 1...rounds {
            monkeys
                .sorted { $0.key < $1.key }
                .forEach { $1.inspectAll(relief: relief, commonDivisor: commonDivisor) }
        }
    }
    
    func checkBusiness() {
        let mostBusiness = monkeys
            .map { $1.inspections }
            .sorted { $0 > $1 }
            
        let totalMonkeyBusiness = mostBusiness[0] * mostBusiness[1]
        print("Total amount of Monkey business:", totalMonkeyBusiness)
    }
}

extension MonkeyGroup: MonkeyBusiness {
    func throwItem(_ item: Double, to monkey: Int) {
        monkeys[monkey]?.items.append(item)
    }
}

class Monkey {
    
    var items: [Double]
    let operation: (Double) -> (Double)
    let testDivisible: Double
    let testSuccessPassToMoney: Int
    let testFailurePassToMoney: Int
    
    weak var monkeyBusiness: MonkeyBusiness? = nil
    
    var inspections = 0
    
    init(items: [Double], testDivisible: Double, testSuccessPassToMoney: Int, testFailurePassToMoney: Int, operation: @escaping (Double) -> Double) {
        self.items = items
        self.operation = operation
        self.testDivisible = testDivisible
        self.testSuccessPassToMoney = testSuccessPassToMoney
        self.testFailurePassToMoney = testFailurePassToMoney
    }
    
    func inspectAll(relief: Double, commonDivisor: Double) {
        for item in items {
            if let (newItem, monkey) = inspect(item, relief, commonDivisor) {
                self.monkeyBusiness?.throwItem(newItem, to: monkey)
            }
        }
    }
    
    private func inspect(_ item: Double, _ relief: Double, _ commonDivisor: Double) -> (item: Double, monkey: Int)? {
        inspections += 1
        let item = items.removeFirst()
        let worryLevel = operation(item)
        
        let postRelief: Double
        if relief == 1 {
            
            postRelief = worryLevel.truncatingRemainder(dividingBy: commonDivisor)
        } else {
            postRelief = worryLevel / relief
        }
        
        let remainder = postRelief.truncatingRemainder(dividingBy: testDivisible)
        if remainder == 0 {
            return (item: postRelief, monkey: testSuccessPassToMoney)
        } else {
            return (item: postRelief, monkey: testFailurePassToMoney)
        }
    }
}

protocol MonkeyBusiness: AnyObject {
    func throwItem(_ item: Double, to monkey: Int)
}

typealias M = () -> Monkey

// I didn't parse this programatically from the input. Just to save time.
// Structured as functions returning Monkey classes, because part 2 needs fresh monkeys.
let _monkey0: M = { Monkey(items: [61], testDivisible: 5, testSuccessPassToMoney: 7, testFailurePassToMoney: 4, operation: { $0 * 11 }) }
let _monkey1: M = { Monkey(items: [76, 92, 53, 93, 79, 86, 81], testDivisible: 2, testSuccessPassToMoney: 2, testFailurePassToMoney: 6, operation: { $0 + 4 }) }
let _monkey2: M = { Monkey(items: [91, 99], testDivisible: 13, testSuccessPassToMoney: 5, testFailurePassToMoney: 0, operation: { $0 * 19 }) }
let _monkey3: M = { Monkey(items: [58, 67, 66], testDivisible: 7, testSuccessPassToMoney: 6, testFailurePassToMoney: 1, operation: { $0 * $0 }) }
let _monkey4: M = { Monkey(items: [94, 54, 62, 73], testDivisible: 19, testSuccessPassToMoney: 3, testFailurePassToMoney: 7, operation: { $0 + 1 }) }
let _monkey5: M = { Monkey(items: [59, 95, 51, 58, 58], testDivisible: 11, testSuccessPassToMoney: 0, testFailurePassToMoney: 4, operation: { $0 + 3 }) }
let _monkey6: M = { Monkey(items: [87, 69, 92, 56, 91, 93, 88, 73], testDivisible: 3, testSuccessPassToMoney: 5, testFailurePassToMoney: 2, operation: { $0 + 8 }) }
let _monkey7: M = { Monkey(items: [71, 57, 86, 67, 96, 95], testDivisible: 17, testSuccessPassToMoney: 3, testFailurePassToMoney: 1, operation: { $0 + 7}) }
