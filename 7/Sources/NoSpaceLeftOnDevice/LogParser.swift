import Parsing
import Foundation

/**
 A line can be either a:
 - command:
 - output:
 
 A command always starts with $ and can be either:
 - cd: takes a parameter of either:
 - `dirname`:  the dir to jump into
 - `..` navigate one folder back
 - ls: doesn't take parameters, but produces an output
 
 An output can be either:
 - dir: with a parameter of the `dirname`
 - size: with a parameret of the `filename`
 */
struct Log {
    
    static let parser = Many {
        Line.parser
    } separator: {
        "\n"
    }
    
    enum Line {
        case command(Command)
        case output(Output)
        
        static let parser = OneOf {
            Command.parser.map { Line.command($0) }
            Output.parser.map { Line.output($0) }
        }
    }
    
    enum Command {
        case cd(CD)
        case ls
        
        static let parser = OneOf {
            CD.parser.map { Command.cd($0) }
            "$ ls".map { Command.ls }
        }
    }
    
    enum CD {
        case into(dirname: String)
        case back
                
        static let parser = Parse {
            "$ cd "
            OneOf {
                "..".map { CD.back }
                PrefixUpTo("\n").map { CD.into(dirname: String($0)) }
            }
        }
    }
    
    enum Output {
        case dir(dirname: String)
        case file(filename: String, size: Int)
        
        static let parser = Parse {
            OneOf {
                dirParser
                fileParser
            }
        }
        
        private static let dirParser = Parse {
            "dir "
            PrefixUpTo("\n").map { Output.dir(dirname: String($0)) }
        }
        
        private static let fileParser = Parse {
            Int.parser()
            " "
            PrefixUpTo("\n")
        }.map { Output.file(filename: String($1), size: $0) }
    }
}
