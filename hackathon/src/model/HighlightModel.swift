import Foundation

struct HighlightModel {
    let id: Int
    let videoUrl: String
    let previewUrl: String
    let match: MatchModel
    let fragments: [FragmentModel]
    let events: [EventModel]

    static func models(from json: [String: Any]) -> [HighlightModel] {
        var models = [HighlightModel]()

        (json["highlights"] as? [[String: Any]])?.forEach { modelJson in
            models.append(HighlightModel.model(from: modelJson))
        }

        return models
    }

    static func model(from json: [String: Any]) -> HighlightModel {
        return HighlightModel(
            id: json["id"] as! Int, 
            videoUrl: json["video_url"] as! String,
            previewUrl: json["preview_url"] as! String, 
            match: MatchModel.model(from: json["match"] as! [String: Any]),
            fragments: [], //TODO
            events: (json["events"] as? [[String: Any]])?.map { EventModel.model(from: $0) } ?? []
        )
    }
}
