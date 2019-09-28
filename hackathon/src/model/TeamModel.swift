import Foundation

struct TeamModel {
    let id: Int
    let logo: String
    let name: String
    let score: Int

    static func model(from json: [String: Any]) -> TeamModel {
        return TeamModel(
            id: json["id"] as! Int, 
            logo: json["logo"] as! String, 
            name: json["name"] as! String, 
            score: json["score"] as! Int
        )
    }
}
