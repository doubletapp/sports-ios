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
}
