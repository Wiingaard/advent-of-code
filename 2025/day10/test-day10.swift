#!/usr/bin/env swift

import Foundation

let exampleInput = """
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
"""

struct Machine {
    let diagram: String
    let buttons: [[Int]]
}

func parseLine(_ line: String) -> Machine? {
    guard let diagramStart = line.firstIndex(of: "["),
          let diagramEnd = line.firstIndex(of: "]") else {
        return nil
    }
    let diagram = String(line[line.index(after: diagramStart)..<diagramEnd])

    var buttons: [[Int]] = []
    var index = line.startIndex
    while index < line.endIndex {
        if line[index] == "(" {
            var end = line.index(after: index)
            while end < line.endIndex && line[end] != ")" {
                end = line.index(after: end)
            }
            if end < line.endIndex {
                let content = line[line.index(after: index)..<end]
                let parts = content.split(separator: ",")
                let indices = parts.compactMap { Int($0) }
                buttons.append(indices)
                index = line.index(after: end)
            } else {
                break
            }
        } else {
            index = line.index(after: index)
        }
    }

    return Machine(diagram: diagram, buttons: buttons)
}

let lines = exampleInput.split(whereSeparator: \.isNewline).map(String.init)

var totalPresses = 0

for line in lines {
    guard let machine = parseLine(line) else { continue }
    let lights = Array(machine.diagram)
    let lightCount = lights.count
    if lightCount == 0 { continue }

    var target = 0
    for (i, ch) in lights.enumerated() where ch == "#" {
        target |= (1 << i)
    }

    var buttonMasks: [Int] = []
    for button in machine.buttons {
        var mask = 0
        for idx in button {
            mask |= (1 << idx)
        }
        buttonMasks.append(mask)
    }

    let stateCount = 1 << lightCount
    var dist = Array(repeating: -1, count: stateCount)
    var queue: [Int] = [0]
    dist[0] = 0
    var head = 0

    while head < queue.count {
        let state = queue[head]
        head += 1
        if state == target { break }
        for mask in buttonMasks {
            let next = state ^ mask
            if dist[next] == -1 {
                dist[next] = dist[state] + 1
                queue.append(next)
            }
        }
    }

    if dist[target] >= 0 {
        totalPresses += dist[target]
    }
}

print("Expected: 7, Got: \(totalPresses)")
