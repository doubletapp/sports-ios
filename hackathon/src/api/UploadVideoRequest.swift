import Foundation

class UploadVideoRequest: BaseRequest {

    let uploadData: [UploadData]

    static let datetimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
        dateFormatter.locale = Locale(identifier:"es_ES")
        return dateFormatter
    }()

    init(data: [UploadData], matchId: Int, startRealmTime: Date, duration: Double) {
        uploadData = data

        super.init()

        parameters["start_real_time"] = UploadVideoRequest.datetimeFormatter.string(from: startRealmTime)
        parameters["duration"] = String(Int(duration))
        parameters["match"] = String(matchId)

        path = "/videos/"
    }

    override func request(_ callback: @escaping (Any?, Error?) -> Void) {
        var dataForUpload: [String: UploadData] = [:]
        uploadData.forEach { data in
            dataForUpload[data.key] = data
        }
        super.uploadRequest(data: dataForUpload, with: callback)
    }
}
