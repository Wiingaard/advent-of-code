@main
public struct NoSpaceLeftOnDevice {
    
    
    
    public static func main() throws {
        var _log = logList[...]
        let lines = try Log.parser.parse(&_log)
        
        let fileSystem = FileSystem()
        fileSystem.load(log: lines)
        fileSystem.storage.dump()
        
        // Part 1: Find all of the directories with a total size of at most 100000.
        // What is the sum of the total sizes of those directories?
        let part1 = fileSystem.storage.subdirs()
            .map { $0.size() }
            .filter { $0 <= 100000 }
            .reduce(0, +)
        
        print("Part 1 solution: \(part1)")
        
        // Part 2: Find the smallest directory that, if deleted, would free up enough space
        // on the filesystem to run the update. What is the total size of that directory?
        let totalFilesystemSize = 70000000
        let updateRequireSize = 30000000
        let maxAllowSize = totalFilesystemSize - updateRequireSize
        let currentUsedSize = fileSystem.storage.size()
        let neededDeleteSize = currentUsedSize - maxAllowSize
        
        let part2 = fileSystem.storage.subdirs()
            .map { $0.size() }
            .sorted { $0 < $1 }
            .first { $0 > neededDeleteSize }
        
        print("Part 2 solution: \(part2?.description ?? "'No solution'")")
        
    }
}

class FileSystem {
    
    var storage = Dir()
    var cursor = Cursor()
    
    func currentDir() -> Dir {
        var dir = storage
        for dirName in cursor.path() {
            dir = dir[dirName].dir
        }
        return dir
    }
    
    func add(_ node: Node) {
        let dir = currentDir()
        dir[node.name] = node
    }
    
    func load(log: [Log.Line]) {
        log.forEach { line in
            switch line {
            case .command(let command):
                switch command {
                case .ls:
                    break
                case .cd(let cd):
                    switch cd {
                    case .into(let dirname):
                        if dirname == "/" {
                            cursor.goToRoot()
                        } else {
                            cursor.into(dirname)
                        }
                    case .back:
                        cursor.back()
                    }
                }
            case .output(let output):
                switch output {
                case .file(let name, let size):
                    add(.file(name: name, size: size))
                case .dir(let name):
                    add(.dir(name: name, content: Dir()))
                }
            }
        }
    }
}

class Dir {
    private var storage: Dictionary<String, Node> = [:]
    
    subscript(_ name: String) -> Node {
        get {
            storage[name]!
        }
        set(node) {
            storage[name] = node
        }
    }
    
    func size() -> Int {
        return storage.map { $1.size() }.reduce(0, +)
    }
    
    func elements() -> [Node] {
        storage.map { $1 }
    }
    
    func subfiles() -> [Node] {
        elements().flatMap { node -> [Node] in
            switch node {
            case .file:
                return [node]
            case .dir(_, let content):
                return content.subfiles()
            }
        }
    }
    
    func subdirs() -> [Node] {
        elements().flatMap { node -> [Node] in
            switch node {
            case .dir(_, let content):
                return [node] + content.subdirs()
            case .file:
                return []
            }
        }
    }
    
    func dump(_ indentation: Int = 0) {
        func put(_ message: String) {
            let indent = String(repeating: "  ", count: indentation)
            print("\(indent) - \(message)")
        }
        
        elements()
            .sorted { $0.isDir == $1.isDir }
            .forEach { node in
                switch node {
                case .file(let name, let size):
                    put("\(name) (size: \(size))")
                case .dir(let name, let content):
                    put("\(name)/ (size: \(content.size()))")
                    content.dump(indentation + 1)
                }
            }
    }
}

enum Node {
    case file(name: String, size: Int)
    case dir(name: String, content: Dir)
    
    var name: String {
        switch self {
        case .dir(let name, _), .file(let name, _):
            return name
        }
    }
    
    var dir: Dir {
        switch self {
        case .dir(_ , let content):
            return content
        case .file:
            fatalError("Node '\(self.name)' is not a dir")
        }
    }
    
    func size() -> Int {
        switch self {
        case .file(_, let size): return size
        case .dir(_, let content): return content.size()
        }
    }
    
    var isDir: Bool {
        switch self {
        case .dir: return true
        case .file: return false
        }
    }
}

class Cursor {
    private var cursor: [String] = []
    
    func into(_ dirName: String) {
        cursor.append(dirName)
    }
    
    func back() {
        _ = cursor.popLast()
    }
    
    func goToRoot() {
        cursor = []
    }
    
    func path() -> [String] {
        cursor
    }
}
