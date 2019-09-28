import Foundation

struct HighlightModel {
    let id: Int
    let videoUrl: String
    let previewUrl: String
    let match: MatchModel
    let fragments: [FragmentModel]
    let events: [EventModel]
}
