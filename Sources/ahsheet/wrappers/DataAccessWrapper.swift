import Foundation
import FoundationNetworking

extension Data: CustomStringConvertible {
    var description: String {
        String(decoding: self, as: UTF8.self)
    }
}

public func putData(_ body: Data?, _ makePath: (String, String) -> String) throws -> Data? {
    if let api_key = ProcessInfo.processInfo.environment["AH_SHEET_WRITE_API_KEY"],
       let spreadsheet_id = ProcessInfo.processInfo.environment["AH_SHEET_ID"],
       let token = ProcessInfo.processInfo.environment["AH_SHEET_TOKEN"] {
        var request = URLRequest(url: makePath(spreadsheet_id, api_key).asUrl)
        request.httpMethod = "PUT"
        request.httpBody = body
        request.setValue(token, forHTTPHeaderField: "authorization")
        request.setValue("https://explorer.apis.google.com", forHTTPHeaderField: "x-referer")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let sem = DispatchSemaphore.init(value: 0)
        var httpResponse: Data?

        print("Starting task...")
        URLSession.shared.dataTask(with: request) { data, response, error in
            defer { sem.signal() }
            print("ok")
            guard let data = data else {
                return
            }
            print(String(decoding: data, as: UTF8.self))
            httpResponse = data
        }.resume()
        print("Started task")
        
        sem.wait()
        return httpResponse
    } else {
        print("Missing env variables. Cannot run query, returning nil...")
        return nil
    }
}

public func getSheetData(_ range: String) throws -> SheetData {
    return try JSONDecoder().decode(
        SheetData.self,
        from: getData { spreadsheet_id, api_key in
            "https://content-sheets.googleapis.com/v4/spreadsheets/\(spreadsheet_id)/values/\(range)?key=\(api_key)&fields=values,range"
        }!
    )
}

public func getSheetData(_ range: String, sheet: String) throws -> SheetData {
    try getSheetData("'\(sheet)'!\(range)")
}

public func getSheetData(_ range: Range) throws -> SheetData {
    try getSheetData(range.debugDescription)
}

public func setSheetData(_ data: SheetData) throws {
    try putData(
        try? JSONEncoder().encode(data)
    ) { spreadsheet_id, api_key in
        "https://content-sheets.googleapis.com/v4/spreadsheets/\(spreadsheet_id)/values/\(data.range)?valueInputOption=USER_ENTERED&alt=json&key=\(api_key)"
    }
    return
}