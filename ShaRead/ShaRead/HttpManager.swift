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

enum HttpError: Int {
    case HttpErrorUnknown
}

typealias HttpCallbackSuccess = (data: JSON) -> Void
typealias HttpCallbackFailure = (error: HttpError) -> Void

class HttpManager {

    static let sharedInstance = HttpManager()
    
    let baseUrl: String = ""

    func request(httpMethod: HttpMethod, path: String, param: [String: AnyObject]?, success: HttpCallbackSuccess, failure: HttpCallbackFailure) {

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
                success(data: JSON(data))
            case .Failure(let error):
                switch HttpError(rawValue: error.code) {
                default:
                    failure(error: .HttpErrorUnknown)
                }
            }
        }
    }
}
