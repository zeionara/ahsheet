private struct ErrorProperties: Codable {
    let code: Int
    let message: String
    let status: String
}

public struct HttpError: Codable, Error {

    let code: Int
    let message: String
    let status: String

    enum IntermediateCodingKeys: String, CodingKey {
        case error
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: IntermediateCodingKeys.self)
        let properties = try values.decode(ErrorProperties.self, forKey: .error)
        
        code = properties.code
        message = properties.message
        status = properties.status
    }
}

