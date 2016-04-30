//
//  HttpManager.swift
//  ShaRead
//
//  Created by martin on 2016/4/26.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum HttpMethod {
    case HttpMethodGet
    case HttpMethodPost
    case HttpMethodPut
    case HttpMethodDelete
}

typealias HttpCallbackSuccess = (code: Int, data: JSON) -> Void
typealias HttpCallbackFailure = (code: Int?, data: JSON?) -> Void
typealias HttpCallbackComplete = () -> Void

class HttpManager {

    static let sharedInstance = HttpManager()
    
    let baseUrl: String = ""

    func request(httpMethod: HttpMethod, path: String, param: [String: AnyObject]?, success: HttpCallbackSuccess? = nil, failure: HttpCallbackFailure? = nil, complete: HttpCallbackComplete? = nil) {

        var method: Alamofire.Method = .GET
        var encode: ParameterEncoding = .URLEncodedInURL

        switch httpMethod {
        case .HttpMethodGet:
            method = .GET
            encode = .URLEncodedInURL
        case .HttpMethodPost:
            method = .POST
            encode = .JSON
        case .HttpMethodPut:
            method = .PUT
            encode = .JSON
        case .HttpMethodDelete:
            method = .DELETE
            encode = .URLEncodedInURL
        }

        Alamofire
        .request(method, baseUrl + path, parameters: param, encoding: encode, headers: nil)
        .responseJSON { (response) in
            switch response.result {
            case .Success(let data):
                let code = response.response?.statusCode

                if code != nil && code! >= 200 && code! < 300 {
                    success?(code: code!, data: JSON(data))
                } else {
                    failure?(code: code, data: JSON(data))
                }
            case .Failure(_):
                failure?(code: nil, data: nil)
            }

            complete?()
        }
    }
}
