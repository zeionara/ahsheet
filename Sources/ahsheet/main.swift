import FoundationNetworking
import Foundation

print("Hello, world!")


if let api_key = ProcessInfo.processInfo.environment["AH_SHEET_API_KEY"], let spreadsheet_id = ProcessInfo.processInfo.environment["AH_SHEET_ID"] {
    let spreadsheetInfo = try String(
        contentsOf: "https://content-sheets.googleapis.com/v4/spreadsheets/\(spreadsheet_id)?key=\(api_key)".asUrl,
        encoding: .utf8
    )
    print(spreadsheetInfo)
} else {
    print("Missing env variables")
}
