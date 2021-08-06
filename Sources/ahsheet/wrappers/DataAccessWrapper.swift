import Foundation

func getSheetData(_ range: String) throws -> SheetData {
    return try JSONDecoder().decode(
        SheetData.self,
        from: getData { spreadsheet_id, api_key in
            "https://content-sheets.googleapis.com/v4/spreadsheets/\(spreadsheet_id)/values/\(range)?key=\(api_key)&fields=values,range"
        }!
    )
}

func getSheetData(_ range: String, sheet: String) throws -> SheetData {
    try getSheetData("'\(sheet)'!\(range)")
}