import Foundation
import OAuth2

public enum SessionWrapperInitializationException: Error {
    case missingEnvironmentVariables(String)
}

public enum HttpClientError: Error {
    case unauthorized(String)
    case noSpreadsheetId(String)
}

let TOKEN_CACHE_PATH = "Assets/Credentials/token.json"

public enum TokenSource {
    case browser, refresh
}

public class GoogleApiSessionWrapper {
    let connection: Connection
    
    public func refreshToken(_ tokenProvider: BrowserTokenProvider, callback: BrowserTokenProvider.SignInCallback? = nil) throws {
        try tokenProvider.signIn(
            scopes: [
                "https://www.googleapis.com/auth/spreadsheets",
                "https://www.googleapis.com/auth/drive"
            ],
            callback: callback
        )
        try ensureParentDirectoriesExist(TOKEN_CACHE_PATH)
        try tokenProvider.saveToken(TOKEN_CACHE_PATH)
    }

    // public init(callback: BrowserTokenProvider.SignInCallback? = nil, tokenSource: TokenSource = .browser) throws {
    //     switch tokenSource {
    //         case .browser: 
    //             var tokenProvider: BrowserTokenProvider? = nil

    //             if let credentialsPath = ProcessInfo.processInfo.environment["AH_SHEET_CREDS_PATH"] {
    //                 guard let browserTokenProvider = BrowserTokenProvider(
    //                     credentials: credentialsPath,
    //                     token: TOKEN_CACHE_PATH
    //                 ) else {
    //                     throw CredentialsReadingError.cannotReadCredentials("Cannot read credentials from given file")
    //                 }
    //                 tokenProvider = browserTokenProvider
    //             } else {
    //                 throw SessionWrapperInitializationException.missingEnvironmentVariables("Environment variable 'AH_SHEET_CREDS_PATH' is not specified")
    //             }

    //             self.connection = Connection(provider: tokenProvider!)

    //             if tokenProvider!.token == nil { // If token wasn't cached earlier or it doesn't longer work
    //                 try refreshToken(tokenProvider!, callback: callback)
    //             }
    //         case .refresh:
    //             var tokenProvider: GoogleRefreshTokenProvider? = nil

    //             if let credentialsPath = ProcessInfo.processInfo.environment["AH_SHEET_CREDS_PATH"] {
    //                 guard let refreshTokenProvider = GoogleRefreshTokenProvider(
    //                     credentials: TOKEN_CACHE_PATH
    //                 ) else {
    //                     throw CredentialsReadingError.cannotReadCredentials("Cannot read credentials from given file")
    //                 }
    //                 tokenProvider = refreshTokenProvider
    //             } else {
    //                 throw SessionWrapperInitializationException.missingEnvironmentVariables("Environment variable 'AH_SHEET_CREDS_PATH' is not specified")
    //             }

    //             self.connection = Connection(provider: tokenProvider!)

    //             if tokenProvider!.token == nil { // If token wasn't cached earlier or it doesn't longer work
    //                 throw AuthError.missingToken("Token source \(tokenSource) did not provide a token")
    //             }
    //     }
    // }

    public init(callback: BrowserTokenProvider.SignInCallback? = nil) throws {
        if doesFileExist(TOKEN_CACHE_PATH) {
            var tokenProvider: GoogleRefreshTokenProvider? = nil

            guard let refreshTokenProvider = GoogleRefreshTokenProvider(
                credentials: TOKEN_CACHE_PATH
            ) else {
                throw CredentialsReadingError.cannotReadCredentials("Cannot read credentials from given file")
            }
            tokenProvider = refreshTokenProvider

            self.connection = Connection(provider: tokenProvider!)

            if tokenProvider!.token == nil { // If token wasn't cached earlier or it doesn't longer work
                throw AuthError.missingToken("Token provider did not provide a token")
            }
        } else {
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
                try refreshToken(tokenProvider!, callback: callback)
            }
        }
    }
}
