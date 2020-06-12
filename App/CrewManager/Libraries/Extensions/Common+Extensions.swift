//This is not my code, i took this from git hub link below
//http://git.addrenaline.nl/wouter/alerts-and-pickers/tree/master/Source/Extensions
import Foundation

public func Log<T>(_ object: T?, filename: String = #file, line: Int = #line, funcname: String = #function) {
    #if DEBUG
        guard let object = object else { return }
        print("***** \(Date()) \(filename.components(separatedBy: "/").last ?? "") (line: \(line)) :: \(funcname) :: \(object)")
    #endif
}
