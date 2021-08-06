import FoundationNetworking
import Foundation

// print("Hello, world!")

//
// Data access
//


// if let api_key = ProcessInfo.processInfo.environment["AH_SHEET_API_KEY"], let spreadsheet_id = ProcessInfo.processInfo.environment["AH_SHEET_ID"] {
//     let info = try String(
//         contentsOf: "https://content-sheets.googleapis.com/v4/spreadsheets/\(spreadsheet_id)/values/'05.08.2021'!A5:B6?key=\(api_key)&fields=values,range".asUrl
//     ).data(
//         using: .utf8
//     )!
//     // print(spreadsheetInfo)
//     // let spreadsheetInfoString = try String(
//     //     contentsOf: "https://content-sheets.googleapis.com/v4/spreadsheets/\(spreadsheet_id)/values/'05.08.2021'!A5:B6?key=\(api_key)&fields=values,range".asUrl,
//     //     // "https://content-sheets.googleapis.com/v4/spreadsheets/\(spreadsheet_id)?key=\(api_key)&fields=sheets.properties.title,sheets.properties.sheetId".asUrl,
//     //     encoding: .utf8
//     // )
//     // print(spreadsheetInfoString)
//     let decodedData = try JSONDecoder().decode(SheetData.self, from: info)
//     print(decodedData.values)
//     // for sheet in decodedData.sheets {
//         // print(sheet)
//     // }
//     // print(spreadsheetInfo)
// } else {
//     print("Missing env variables")
// }

print("Cells:")
// print(try getSheetData("'05.08.2021'!A5:B6").values)
print(try getSheetData("A5:B6", sheet: "05.08.2021").values)


//
// Metadata access
//

// if let api_key = ProcessInfo.processInfo.environment["AH_SHEET_API_KEY"], let spreadsheet_id = ProcessInfo.processInfo.environment["AH_SHEET_ID"] {
//     let spreadsheetInfo = try String(
//         contentsOf: "https://content-sheets.googleapis.com/v4/spreadsheets/\(spreadsheet_id)?key=\(api_key)&fields=sheets.properties.title,sheets.properties.sheetId".asUrl
//     ).data(
//         using: .utf8
//     )!
//     print(spreadsheetInfo)
//     let spreadsheetInfoString = try String(
//         contentsOf: "https://content-sheets.googleapis.com/v4/spreadsheets/\(spreadsheet_id)?key=\(api_key)&fields=sheets.properties.title,sheets.properties.sheetId".asUrl,
//         encoding: .utf8
//     )
//     print(spreadsheetInfoString)
//     let decodedData = try JSONDecoder().decode(SpreadsheetMeta.self, from: spreadsheetInfo)
//     for sheet in decodedData.sheets {
//         print(sheet)
//     }
//     // print(spreadsheetInfo)
// } else {
//     print("Missing env variables")
// }

// print("Sheets:")
// for sheet in try getSphreadsheetMeta().sheets {
//     print(sheet)
// }
