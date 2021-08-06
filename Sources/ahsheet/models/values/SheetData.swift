public struct SheetData: Codable {
    let range: String
    let values: [[String]] // The first dimension corresponds to rows, the second - to columns 

    public init(range: String, values: [[String]]) {
        self.range = range
        self.values = values
    }
}