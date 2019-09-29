import Foundation
import Alamofire

protocol IBaseRequest {
    func request(_ callback: @escaping (Any?, Error?) -> Void)
}

struct UploadData {
    let data: Data
    let key: String
    let filename: String
    let mimeType: String
}

class BaseRequest: IBaseRequest {

    var host = "http://sports.doubletapp.ru/api"

    lazy var headers: [String: String] = {

        var innerHeaders: [String: String] = [:]

        innerHeaders["authentication"] = UIDevice.current.identifierForVendor!.uuidString

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

    func uploadRequest(data: [String: UploadData], with callback: @escaping (Any?, Error?) -> Void) {

        let url = URL(string: host + path)
        let urlRequest = try! URLRequest(url: url!, method: .post, headers: headers)
        let parameters = self.parameters
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in data {
                multipartFormData.append(value.data, withName: key, fileName: value.filename, mimeType: value.mimeType)
            }

            for (key, value) in parameters {
                if let v = value as? String, let data = v.data(using: String.Encoding.utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
        }, with: urlRequest, encodingCompletion: { result in
            switch result {
            case .success(let request, _, _):
                request.responseJSON { BaseRequest.parse(response: $0, with: callback) }
            case .failure(let error):
                callback(nil, error)
            }
        })
    }
    
    fileprivate static func parse(response: DataResponse<Any>, with callback: @escaping (Any?, Error?) -> Void) {
        do {
            if let data = response.data {
                if let obj = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    callback(obj, nil)
                }
            }
        } catch {
            callback(nil, nil)
        }
    }
}

