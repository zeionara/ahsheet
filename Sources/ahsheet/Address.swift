import Foundation

public enum InvalidAddress: Error {
    case redundantSheetName(String)
}

public extension Int {
    var asColumnLabel: String {
        var currentIndex = self
        var currentLabel = ""
        while currentIndex >= 0 {
            let (quotient, remainder) = currentIndex.quotientAndRemainder(dividingBy: 26)
            currentLabel.append(Character(UnicodeScalar(65 + remainder)!))
            currentIndex = quotient - 1
        }
        return String(currentLabel.reversed())
    }

    var asRowNumber: String {
        return "\(self + 1)"
    }
}

public extension String {
    var asColumnIndex: Int {
        var currentIndex = 0
        var currentComponentMultiplicationBase = 1
        for character in self.reversed() {
            currentIndex += (Int(character.unicodeScalars.first!.value) - (currentComponentMultiplicationBase == 1 ? 65 : 64)) * currentComponentMultiplicationBase
            currentComponentMultiplicationBase *= 26
        }
        return currentIndex
    }

    var asRowIndex: Int {
        return Int(self)! - 1
    }
}

let stringAddressRegex = try! NSRegularExpression(pattern: "(?:'([^']+)'!)?([A-Z]+)([0-9]+)")

private let SHEET_INDEX = 1
private let COLUMN_LABEL_INDEX = 2
private let ROW_NUMBER_INDEX = 3

public struct Address: CustomStringConvertible {
    public let rowIndex: Int
    public let columnIndex: Int
    public let sheet: String?
    private let asString: String

    public init(row rowIndex: Int, column columnIndex: Int, sheet: String? = nil) {
        self.rowIndex = rowIndex
        self.columnIndex = columnIndex
        asString = "\(columnIndex.asColumnLabel)\(rowIndex.asRowNumber)" // Columns in the google sheets are enumerated from one, not from zero
        self.sheet = sheet
    }

    public init(_ string: String, sheet: String? = nil) throws {
        // let match = stringAddressRegex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.length))
        // let string = "DD22"
        let match = stringAddressRegex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.length))!
        // for i in 1..<match.numberOfRanges {
        //     print(string.substring(with: match.range(at: i)))
        // }
        let embeddedSheet = string.substring(with: match.range(at: SHEET_INDEX))
        guard !(embeddedSheet != "" && sheet != nil) else {
            throw InvalidAddress.redundantSheetName("Sheet name was given twice - once in the stringified address of the cell and once in the method params")
        }
        
        let columnLabel = string.substring(with: match.range(at: COLUMN_LABEL_INDEX))
        let rowNumber = string.substring(with: match.range(at: ROW_NUMBER_INDEX))

        columnIndex = columnLabel.asColumnIndex
        rowIndex = rowNumber.asRowIndex
        self.sheet = sheet ?? embeddedSheet
        asString = "\(columnLabel)\(rowNumber)"
    }

    public var description: String {
        asString
    }
}
