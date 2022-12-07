@main
public struct NoSpaceLeftOnDevice {
    
    public static func main() throws {
        
        var _log = log[...]
        
        let lines = try Log.parser.parse(&_log)
        
        print(_log)
        print(lines)
        
    }
    
}


