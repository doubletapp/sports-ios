import Foundation

struct PlayerModel {
    let lastName: String
    let avatar: String?

    static func model(from json: [String: Any]?) -> PlayerModel? {
        guard let json = json else { return nil }

        return PlayerModel(
            lastName: json["last_name"] as? String ?? "", 
            avatar: json["avatar"] as? String
        )
    }
}
