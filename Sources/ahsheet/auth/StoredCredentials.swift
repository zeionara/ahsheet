enum CredentialsReadingError: Error {
    case cannotReadCredentials(String)
}

private struct Installed: Codable {

    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case authURI = "auth_uri"
        case tokenURI = "token_uri"
    }

    let clientId: String
    let authURI: String
    let tokenURI: String
}


struct StoredCredentials: Codable {

    let clientId: String
    let authURI: String
    let tokenURI: String
    
    enum IntermediateCodingKeys: String, CodingKey {
        case installed
    }

    enum OtherCodingKeys: String, CodingKey {
        case clientId = "client_id"
        case authURI = "auth_uri"
        case tokenURI = "token_uri"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: IntermediateCodingKeys.self)
        let properties = try values.decode(Installed.self, forKey: .installed)
        
        clientId = properties.clientId
        authURI = properties.authURI
        tokenURI = properties.tokenURI

        // id = try properties.decode(Int.self, forKey: .id)
        // title = try properties.decode(String.self, forKey: .title)
        
        // let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
        // elevation = try additionalInfo.decode(Double.self, forKey: .elevation)
    }
}