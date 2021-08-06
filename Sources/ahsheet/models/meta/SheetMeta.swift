private struct Properties: Codable {

    enum CodingKeys: String, CodingKey {
        case id = "sheetId"
        case title
    }

    let id: Int
    let title: String
}

public struct SheetMeta: Codable, CustomStringConvertible {

    let id: Int
    let title: String

    enum IntermediateCodingKeys: String, CodingKey {
        case properties
    }


    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: IntermediateCodingKeys.self)
        let properties = try values.decode(Properties.self, forKey: .properties)
        id = properties.id
        title = properties.title
        // id = try properties.decode(Int.self, forKey: .id)
        // title = try properties.decode(String.self, forKey: .title)
        
        // let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
        // elevation = try additionalInfo.decode(Double.self, forKey: .elevation)
    }

    public var description: String {
        "\(title) aka \(id)"
    }

    // enum CodingKeys: String, CodingKey {
    //     case id = "sheetId"
    // }
}
