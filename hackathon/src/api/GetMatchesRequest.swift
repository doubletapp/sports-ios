import Foundation

class GetMatchesRequest: BaseRequest {

    override init() {
        super.init()
        
        path = "/matches/"
    }

    override func request(_ callback: @escaping (Any?, Error?) -> Void) {
        super.getRequest(callback)
    }
}
