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

    var name: String {
        switch self {
        case .corner_kick: return "Угловой"
        case .free_kick: return "Штрафной"
        case .goal_kick: return "Удар от ворот"
        case .offside: return "Вне игры"
        case .penalty_awarded: return "Заработанный пенальти"
        case .possible_video_assistant_referee: return "Возможный момент для VAR"
        case .red_card: return "Красная карточка"
        case .score_change: return "Гол"
        case .shot_off_target: return "Удар мимо"
        case .shot_on_target: return "Удар в створ"
        case .yellow_card: return "Желтая карточка"
        default: return ""
        }
    }
}


struct EventModel {
    let id: Int
    let type: EventType
    let realTime: Date
    let matchTime: Int
    let videoTime: Int?
    let player: PlayerModel?

    static func model(from json: [String: Any]) -> EventModel {
        return EventModel(
            id: json["id"] as! Int, 
            type: EventType(rawValue: json["type"] as! String) ?? .none,
            realTime: EventModel.timeFormatter.date(from: json["real_time"] as! String)!,
            matchTime: json["match_time"] as! Int,
            videoTime: json["video_time"] as? Int,
            player: PlayerModel.model(from: json["player"] as? [String: Any])
        )
    }

    static let timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
        dateFormatter.locale = Locale(identifier:"es_ES")
        return dateFormatter
    }()
}
