import Foundation
import FoundationNetworking
import OAuth2

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

        URLSession.shared.dataTask(with: request) { data, response, error in
            defer { sem.signal() }
            guard let data = data else {
                return
            }
            print(String(decoding: data, as: UTF8.self))
            httpResponse = data
        }.resume()

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

public extension GoogleApiSessionWrapper {
    private func fetchSheetData(_ range: String) throws -> SheetData {
        guard let spreadsheet_id = ProcessInfo.processInfo.environment["AH_SHEET_ID"] else {
            throw HttpClientError.noSpreadsheetId("Target spreadsheet id is undefined (environment variable 'AH_SHEET_ID' is not set)")
        }

        let sem = DispatchSemaphore(value: 0)

        var responseData : Data?
        let parameters = ["fields": "values,range"]

        try connection.performRequest(
            method: "GET",
            urlString: "https://content-sheets.googleapis.com/v4/spreadsheets/\(spreadsheet_id)/values/\(range)",
            parameters: parameters,
            body:nil
        ) { (data, response, error) in
            // print(String(decoding: data!, as: UTF8.self))
            responseData = data
            sem.signal()
        }

        _ = sem.wait(timeout: DispatchTime.distantFuture)

        do {
            return try JSONDecoder().decode(
                SheetData.self,
                from: responseData!
            )
        } catch {
            let httpError = try JSONDecoder().decode(
                HttpError.self,
                from: responseData!
            )

            if httpError.code == 401 {
                throw HttpClientError.unauthorized("Incorrect authorization key or no authentication key at all")
            }
            throw error
        }
    }

    private func pushSheetData(_ sheetData: SheetData) throws {
        guard let spreadsheet_id = ProcessInfo.processInfo.environment["AH_SHEET_ID"] else {
            throw HttpClientError.noSpreadsheetId("Target spreadsheet id is undefined (environment variable 'AH_SHEET_ID' is not set)")
        }

        let sem = DispatchSemaphore(value: 0)

        var responseData : Data?
        let parameters = ["valueInputOption": "USER_ENTERED"]

        try connection.performRequest(
            method: "PUT",
            urlString: "https://content-sheets.googleapis.com/v4/spreadsheets/\(spreadsheet_id)/values/\(sheetData.range)",
            parameters: parameters,
            body: try? JSONEncoder().encode(sheetData)
        ) { (data, response, error) in
            // print(String(decoding: data!, as: UTF8.self))
            responseData = data
            sem.signal()
        }

        _ = sem.wait(timeout: DispatchTime.distantFuture)

        if let httpError = try? JSONDecoder().decode(
            HttpError.self,
            from: responseData!
        ) {
            if httpError.code == 401 {
                throw HttpClientError.unauthorized("Incorrect authorization key or no authentication key at all")
            }
        }
    }

    private func runBatchUpdate(_ requests: Data) throws -> Data? {
        guard let spreadsheet_id = ProcessInfo.processInfo.environment["AH_SHEET_ID"] else {
            throw HttpClientError.noSpreadsheetId("Target spreadsheet id is undefined (environment variable 'AH_SHEET_ID' is not set)")
        }

        let sem = DispatchSemaphore(value: 0)

        var responseData : Data?
        var httpError: HttpError

        try connection.performRequest(
            method: "POST",
            urlString: "https://content-sheets.googleapis.com/v4/spreadsheets/\(spreadsheet_id):batchUpdate?alt=json",
            parameters: [:],
            body: requests
            ) { (data, response, error) in
               // print(String(decoding: data!, as: UTF8.self))
               responseData = data
               sem.signal()
          }

          _ = sem.wait(timeout: DispatchTime.distantFuture)

          do {
              httpError = try JSONDecoder().decode(
                  HttpError.self,
                  from: responseData!
              )
          } catch {
              return responseData 
          }

          if httpError.code == 401 {
              throw HttpClientError.unauthorized("Incorrect authorization key or no authentication key at all")
          }
          throw httpError
    }

    private func runBatchUpdate(_ requests: [[String: [String: [String: String]]]]) throws -> Data? {
        return try runBatchUpdate(JSONEncoder().encode(["requests": requests]))
    }

    func getSheetData(_ range: String) throws -> SheetData {
        do {
            return try fetchSheetData(range)
        } catch HttpClientError.unauthorized {
            try refreshToken(connection.provider as! BrowserTokenProvider)
            return try fetchSheetData(range)
        }
    }

    func setSheetData(_ data: SheetData) throws {
        do {
            return try pushSheetData(data)
        } catch HttpClientError.unauthorized {
            try refreshToken(connection.provider as! BrowserTokenProvider)
            return try pushSheetData(data)
        }
    }

    func batchUpdate(_ data: Data) throws -> Data? {
        do {
            print("Running batchUpdate...")
            return try runBatchUpdate(data)
        } catch HttpClientError.unauthorized {
            print("Batch update failed")
            try refreshToken(connection.provider as! BrowserTokenProvider)
            return try runBatchUpdate(data)
        }
    }
}

