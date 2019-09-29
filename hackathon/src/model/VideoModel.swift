import Foundation

struct VideoModel {
    let id: Int
    let videoUrl: String
    let previewUrl: String

    static func model(from json: [String: Any]) -> VideoModel {
        return VideoModel(
            id: json["id"] as! Int,
            videoUrl: json["video_url"] as! String,
            previewUrl: json["preview_url"] as! String
        )
    }
}
