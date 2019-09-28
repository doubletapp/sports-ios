import Foundation
import Alamofire

protocol IBaseRequest {
    func request(_ callback: @escaping (Any?, Error?) -> Void)
}

struct UploadData {
    let data: Data
    let filename: String
}

class BaseRequest: IBaseRequest {

    var host = "http://sports.doubletapp.ru/api"

    lazy var headers: [String: String] = {

        var innerHeaders: [String: String] = [:]

        return innerHeaders
    }()

    var parameters: [String: Any] = [String: Any]()

    var path = ""

    var encoding: ParameterEncoding = JSONEncoding.default

    func request(_ callback: @escaping (Any?, Error?) -> Void) {
        getRequest(callback)
    }

    func deleteRequest(_ callback: @escaping (Any?, Error?) -> Void) {
        innerRequest(.delete, callback: callback)
    }

    func postRequest(_ callback: @escaping (Any?, Error?) -> Void) {
        innerRequest(.post, callback: callback)
    }

    func getRequest(_ callback: @escaping (Any?, Error?) -> Void) {
        innerRequest(.get, callback: callback)
    }

    func putRequest(_ callback: @escaping (Any?, Error?) -> Void) {
        innerRequest(.put, callback: callback)
    }

    func innerRequest(_ method: Alamofire.HTTPMethod, callback: @escaping (Any?, Error?) -> Void) {

        let requestEncoding = method == .get ? URLEncoding.default : encoding

        Alamofire.request(host + path, method: method, parameters: parameters, encoding: requestEncoding, headers: headers)
            .responseJSON { response in

                switch response.result {
                case .success:
                    guard let data = response.data else {
                        callback(nil, nil)
                        print(response.debugDescription)
                        return
                    }

                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    callback(json, nil)
                    
                case .failure(let error):
                    callback(nil, error)
                }
            }
    }
}

