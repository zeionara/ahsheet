public struct SheetData: Codable {
    public let range: String
    public let values: [[String]] // The first dimension corresponds to rows, the second - to columns 

    public init(range: String, values: [[String]]) {
        self.range = range
        self.values = values
    }
}