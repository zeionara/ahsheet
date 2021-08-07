// public struct ahsheet {
//     public private(set) var text = "Hello, World!"

//     public init() {
//     }
// }


// import FoundationNetworking
import Foundation
import OAuth2

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

// let range = try Range(
//     first: Address(
//         row: 0, column: 0, sheet: "test"
//     ),
//     last: Address(
//         row: 10, column: 1, sheet: "test"
//     )
// )
// print(range)

// let creds = try readCredentials(ProcessInfo.processInfo.environment["AH_SHEET_CREDS_PATH"]!)
// print(creds.clientId)

// class GoogleSession {
//   var connection: Connection
  
//   init(tokenProvider: TokenProvider) {
//     connection = Connection(provider: tokenProvider)
//   }

//   func getPeople() throws {
//     let sem = DispatchSemaphore(value: 0)
    
//     var responseData : Data?
//     let parameters = ["fields": "sheets.properties.title,sheets.properties.sheetId"]

//     let spreadsheet_id = ProcessInfo.processInfo.environment["AH_SHEET_ID"]!
    
//     print("foo")
//     try connection.performRequest(
//       method:"GET",
//       urlString:"https://content-sheets.googleapis.com/v4/spreadsheets/\(spreadsheet_id)",
//       parameters: parameters,
//       body:nil
//     ) {(data, response, error) in
//         responseData = data
//         sem.signal()
//     }
//     print("bar")
//     _ = sem.wait(timeout: DispatchTime.distantFuture)
//     print("baz")
//     if let data = responseData {
//       let response = String(data: data, encoding: .utf8)!
//       print(response)
//     }
//   }

//   func getMe() throws {
//     let sem = DispatchSemaphore(value: 0)
    
//     let parameters = ["requestMask.includeField": "person.names,person.photos"]
//     var responseData : Data?
//     try connection.performRequest(
//       method:"GET",
//       urlString:"https://people.googleapis.com/v1/people/me",
//       parameters: parameters,
//       body: nil) {(data, response, error) in
//         responseData = data
//         sem.signal()
//     }
//     _ = sem.wait(timeout: DispatchTime.distantFuture)
//     if let data = responseData {
//       let response = String(data: data, encoding: .utf8)!
//       print(response)
//     }
//   }
  
//   func getPeople() throws {
//     let sem = DispatchSemaphore(value: 0)
//     var responseData : Data?
//     let parameters = ["requestMask.includeField": "person.names,person.photos"]
//     try connection.performRequest(
//       method:"GET",
//       urlString:"https://people.googleapis.com/v1/people/me/connections",
//       parameters: parameters,
//       body:nil) {(data, response, error) in
//         responseData = data
//         sem.signal()
//     }
//     _ = sem.wait(timeout: DispatchTime.distantFuture)
//     if let data = responseData {
//       let response = String(data: data, encoding: .utf8)!
//       print(response)
//     }
//   }
  
//   func getData() throws {
//     let sem = DispatchSemaphore(value: 0)
//     var responseData : Data?
//     let parameters : [String:String] = [:]
//     let postJSON = ["gqlQuery":["queryString":"select *"]]
//     let postData = try JSONSerialization.data(withJSONObject:postJSON)
//     try connection.performRequest(
//       method:"POST",
//       urlString:"https://datastore.googleapis.com/v1/projects/hello-86:runQuery",
//       parameters: parameters,
//       body: postData) {(data, response, error) in
//         responseData = data
//         sem.signal()
//     }
//     _ = sem.wait(timeout: DispatchTime.distantFuture)
//     if let data = responseData {
//       let response = String(data: data, encoding: .utf8)!
//       print(response)
//     }
//     //var request = Google_Datastore_V1_RunQueryRequest()
//     //request.projectId = projectID
//     //var query = Google_Datastore_V1_GqlQuery()
//     //query.queryString = "select *"
//     //request.gqlQuery = query
//     //print("\(request)")
//     //let result = try service.runquery(request)
//   }
  
//   func translate(_ input:String) throws {
//     let sem = DispatchSemaphore(value: 0)
//     var responseData : Data?
//     let parameters : [String:String] = [:]
//     let postJSON = ["q":input, "provider":"en", "target":"es", "format":"text"]
//     let postData = try JSONSerialization.data(withJSONObject:postJSON)
//     try connection.performRequest(
//       method:"POST",
//       urlString:"https://translation.googleapis.com/language/translate/v2",
//       parameters: parameters,
//       body: postData) {(data, response, error) in
//         responseData = data
//         sem.signal()
//     }
//     _ = sem.wait(timeout: DispatchTime.distantFuture)
//     if let data = responseData {
//       let response = String(data: data, encoding: .utf8)!
//       print(response)
//     }
//   }
// }

// try browserTokenProvider.signIn(
//     scopes: [
//         "https://www.googleapis.com/auth/spreadsheets",
//         "https://www.googleapis.com/auth/drive"
//     ]
// )
// try browserTokenProvider.saveToken("token.json")

let wrapper = try GoogleApiSessionWrapper()

for sheet in try wrapper.getSpreadsheetMeta().sheets {
    print(sheet)
}

print(try wrapper.getSheetData("'05.08.2021'!A1:B2").values)

try wrapper.setSheetData(
    SheetData(
        range: "test!A1",
        values: [
            [
                "foo", "bar"
            ]
        ]
    )
)

// try session.getPeople()

// print("Fetched cells:")
// print(try getSheetData("'05.08.2021'!A5:B6").values)
// print(try getSheetData(range).values)
// print(try getSheetData("A5:B6", sheet: "05.08.2021").values)
// print(Address(row: 2, column: 2, sheet: "foo"))
// print(try Address("'foo'!C3").rowIndex)
// print(300.asRowLabel)
// print("KO".asRowIndex)
// print(range)

// try setSheetData(
//     SheetData(
//         range: "'test'!A1",
//         values: [
//             [
//                 "one", "two"
//             ],
//             [
//                 "three", "four"
//             ]
//         ]
//     )
// )

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
