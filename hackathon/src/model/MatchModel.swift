import Foundation

enum MatchStatus: String {
    case notStarted // запланировал
    case live // идет прямо сейчас
    case postponed // отложен
    case delayed // задержано
    case start_delayed // начало матча временно задержано
    case canceled // отменен и не будет сыгран
    case ended // завершен
    case abandoned //
}


struct MatchModel {
    let id: Int
    let startDateTime: Date
    let homeTeam: TeamModel
    let awayTeam: TeamModel
    let status: MatchStatus
    let minute: String
    let events: [EventModel]

    static func models(from json: [String: Any]) -> [MatchModel] {
        var models = [MatchModel]()

        (json["matches"] as? [[String: Any]])?.forEach { modelJson in
            models.append(MatchModel.model(from: modelJson))
        }

        return models
    }

    static func model(from json: [String: Any]) -> MatchModel {
        return MatchModel(
            id: json["id"] as! Int,
            startDateTime: MatchModel.startDatetimeFormatter.date(from: json["start_datetime"] as! String)!,
            homeTeam: TeamModel.model(from: json["home_team"] as! [String: Any]),
            awayTeam: TeamModel.model(from: json["away_team"] as! [String: Any]),
            status: MatchStatus(rawValue: json["status"] as! String) ?? .notStarted,
            minute: json["minute"] as! String,
            events: (json["events"] as? [[String: Any]])?.map { EventModel.model(from: $0) } ?? []
        )
    }

    static let startDatetimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
        dateFormatter.locale = Locale(identifier:"es_ES")
        return dateFormatter
    }()
}
