import Foundation
import OAuth2

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

public func getSpreadsheetMeta() throws -> SpreadsheetMeta {
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

public extension GoogleApiSessionWrapper {
    private func fetchSpreadsheetMeta() throws -> SpreadsheetMeta {
        guard let spreadsheet_id = ProcessInfo.processInfo.environment["AH_SHEET_ID"] else {
            throw HttpClientError.noSpreadsheetId("Target spreadsheet id is undefined (environment variable 'AH_SHEET_ID' is not set)")
        }
        
        let sem = DispatchSemaphore(value: 0)
        
        var responseData : Data?
        let parameters = ["fields": "sheets.properties.title,sheets.properties.sheetId"]
        
        try connection.performRequest(
            method:"GET",
            urlString:"https://content-sheets.googleapis.com/v4/spreadsheets/\(spreadsheet_id)",
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
                SpreadsheetMeta.self,
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

    func getSpreadsheetMeta(callback: BrowserTokenProvider.SignInCallback? = nil) throws -> SpreadsheetMeta {
        do {
            return try fetchSpreadsheetMeta()
        } catch HttpClientError.unauthorized {
            try refreshToken(connection.provider as! BrowserTokenProvider, callback: callback)
            return try fetchSpreadsheetMeta()
        }
    }
}
