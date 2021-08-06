import Foundation

func getData(_ makePath: (String, String) -> String) throws -> Data? {
    if let api_key = ProcessInfo.processInfo.environment["AH_SHEET_API_KEY"], let spreadsheet_id = ProcessInfo.processInfo.environment["AH_SHEET_ID"] {
        return try String(
            contentsOf: makePath(spreadsheet_id, api_key).asUrl
        ).data(
            using: .utf8
        )
    } else {
        print("Missing env variables. Cannot run query, returning nil...")
        return nil
    }
}

public func getSphreadsheetMeta() throws -> SpreadsheetMeta {
    // if let api_key = ProcessInfo.processInfo.environment["AH_SHEET_API_KEY"], let spreadsheet_id = ProcessInfo.processInfo.environment["AH_SHEET_ID"] {
    //     let spreadsheetInfo = try String(
    //         contentsOf: "https://content-sheets.googleapis.com/v4/spreadsheets/\(spreadsheet_id)?key=\(api_key)&fields=sheets.properties.title,sheets.properties.sheetId".asUrl
    //     ).data(
    //         using: .utf8
    //     )!
    //     return try JSONDecoder().decode(SpreadsheetMeta.self, from: spreadsheetInfo)
    // } else {
    //     print("Missing env variables")
    // }
    return try JSONDecoder().decode(
        SpreadsheetMeta.self,
        from: getData { spreadsheet_id, api_key in
            "https://content-sheets.googleapis.com/v4/spreadsheets/\(spreadsheet_id)?key=\(api_key)&fields=sheets.properties.title,sheets.properties.sheetId"
        }!
    )
}
