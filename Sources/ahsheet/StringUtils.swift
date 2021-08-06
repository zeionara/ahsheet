import Foundation

public extension String {
    var asUrl: URL {
        URL(string: self)!
    }
}
