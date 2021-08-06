public enum InvalidRange: Error {
    case sheetMismatch(String)
}

public struct Range: CustomDebugStringConvertible {
    public let first: Address
    public let last: Address
    
    public init(first: Address, last: Address) throws {
        guard first.sheet == last.sheet else {
            throw InvalidRange.sheetMismatch("Given cell addresses do not belong to the same sheet")
        }
        self.first = first
        self.last = last
    }

    public var sheet: String? {
        first.sheet
    }

    public var debugDescription: String {
        return "\(sheet == nil ? "" : ("'" + sheet! + "'" + "!"))\(first):\(last)"
    }
}
