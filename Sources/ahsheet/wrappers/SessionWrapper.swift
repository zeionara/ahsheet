import Foundation
import OAuth2

public enum SessionWrapperInitializationException: Error {
    case missingEnvironmentVariables(String)
}

public enum HttpClientError: Error {
    case unauthorized(String)
    case noSpreadsheetId(String)
}

let TOKEN_CACHE_PATH = "assets/token.json"

public class GoogleApiSessionWrapper {
    let connection: Connection
    
    public func refreshToken(_ tokenProvider: BrowserTokenProvider) throws {
        try tokenProvider.signIn(
            scopes: [
                "https://www.googleapis.com/auth/spreadsheets",
                "https://www.googleapis.com/auth/drive"
            ]
        )
        try ensureParentDirectoriesExist(TOKEN_CACHE_PATH)
        try tokenProvider.saveToken(TOKEN_CACHE_PATH)
    }

    public init() throws {
        var tokenProvider: BrowserTokenProvider? = nil

        if let credentialsPath = ProcessInfo.processInfo.environment["AH_SHEET_CREDS_PATH"] {
            guard let browserTokenProvider = BrowserTokenProvider(
                credentials: credentialsPath,
                token: TOKEN_CACHE_PATH
            ) else {
                throw CredentialsReadingError.cannotReadCredentials("Cannot read credentials from given file")
            }
            tokenProvider = browserTokenProvider
        } else {
            throw SessionWrapperInitializationException.missingEnvironmentVariables("Environment variable 'AH_SHEET_CREDS_PATH' is not specified")
        }

        self.connection = Connection(provider: tokenProvider!)

        if tokenProvider!.token == nil { // If token wasn't cached earlier or it doesn't longer work
            try refreshToken(tokenProvider!)
        }
    }
}
