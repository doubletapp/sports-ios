import Foundation

enum EventType: String {
    case none
    case corner_kick
    case free_kick
    case goal_kick
    case offside
    case penalty_awarded
    case possible_video_assistant_referee
    case red_card
    case score_change
    case shot_off_target
    case shot_on_target
    case yellow_card
}


struct EventModel {
    let id: Int
    let type: EventType
    let realTime: Date
    let matchTime: Int
    let videoTime: Int?

    static func model(from json: [String: Any]) -> EventModel {
        return EventModel(
            id: json["id"] as! Int, 
            type: EventType(rawValue: json["type"] as! String) ?? .none,
            realTime: EventModel.timeFormatter.date(from: json["real_time"] as! String)!,
            matchTime: json["match_time"] as! Int,
            videoTime: json["video_time"] as? Int
        )
    }

    static let timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
        dateFormatter.locale = Locale(identifier:"es_ES")
        return dateFormatter
    }()
}
