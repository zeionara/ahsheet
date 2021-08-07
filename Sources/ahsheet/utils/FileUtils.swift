import Foundation

func readJSON(_ path: String) -> Data? {
    // let path = Bundle.main.path(forResource: "main", ofType: "swift")
    // let path = FileManager.default.url()
    // let path = URL(fileURLWithPath: path)
    // print(path)
    // print(Bundle.main.path(forResource: "/home/zeio/creds/google-drive-api.json", ofType: "json"))
    // if let path = Bundle.main.path(forResource: "/home/zeio/creds/google-drive-api", ofType: "json") {
    print("Reading")
    do {
        return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

        // let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        // if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
        //     print(jsonResult)
        // }
    } catch {
        return nil
        // handle error
    }
    // }
}

func readCredentials(_ path: String) throws -> StoredCredentials {
    try JSONDecoder().decode(StoredCredentials.self, from: readJSON(path)!)
}
