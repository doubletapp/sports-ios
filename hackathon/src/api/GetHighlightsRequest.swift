import Foundation

class GetHighlightsRequest: BaseRequest {

    override init() {
        super.init()

        path = "/highlights/"
    }

    override func request(_ callback: @escaping (Any?, Error?) -> Void) {
        super.getRequest(callback)
    }
}
