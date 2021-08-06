import FoundationNetworking
import Foundation

print("Hello, world!")


if let api_key = ProcessInfo.processInfo.environment["AH_SHEET_API_KEY"], let spreadsheet_id = ProcessInfo.processInfo.environment["AH_SHEET_ID"] {
    let spreadsheetInfo = try String(
        contentsOf: "https://content-sheets.googleapis.com/v4/spreadsheets/\(spreadsheet_id)?key=\(api_key)&fields=sheets.properties.title,sheets.properties.sheetId".asUrl
    ).data(
        using: .utf8
    )!
    print(spreadsheetInfo)
    let spreadsheetInfoString = try String(
        contentsOf: "https://content-sheets.googleapis.com/v4/spreadsheets/\(spreadsheet_id)?key=\(api_key)&fields=sheets.properties.title,sheets.properties.sheetId".asUrl,
        encoding: .utf8
    )
    print(spreadsheetInfoString)
    let decodedData = try JSONDecoder().decode(SpreadsheetMeta.self, from: spreadsheetInfo)
    for sheet in decodedData.sheets {
        print(sheet)
    }
    // print(spreadsheetInfo)
} else {
    print("Missing env variables")
}
