@main
public struct NoSpaceLeftOnDevice {
    
    
    
    public static func main() throws {
        var _log = logList[...]
        let lines = try Log.parser.parse(&_log)
        
        let fileSystem = FileSystem()
        fileSystem.load(log: lines)
        print("Done")
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
}

class FileSystem {
    
    private var storage = Dir()
    private var cursor = Cursor()
    
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
