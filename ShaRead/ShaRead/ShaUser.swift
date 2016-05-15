//
//  ShaUser.swift
//  ShaRead
//
//  Created by martin on 2016/5/14.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import Foundation
import SwiftyJSON
import FBSDKCoreKit

class ShaUser {
    var uid: String
    var name: String
    var firstName: String
    var lastName: String
    var avatar: String
    
    init(data: AnyObject) {
        self.uid = ""
        self.firstName = data.valueForKey("first_name") as? String ?? ""
        self.lastName = data.valueForKey("last_name") as? String ?? ""
        self.name = data.valueForKey("name") as? String ?? ""
        self.avatar = data.valueForKey("picture")?.valueForKey("data")?.valueForKey("url") as? String ?? ""
    }
    
    init(jsonData: JSON) {
        self.uid = jsonData["firebase_uid"].stringValue
        self.name = jsonData["name"].stringValue
        self.firstName = ""
        self.lastName = ""
        self.avatar = jsonData["avatar"].stringValue
    }
}

extension ShaManager {

    func login(facebook_token: String, firebase_uid: String, success: () -> Void, failure: () -> Void) {
        
        HttpManager.sharedInstance.request(
            .HttpMethodPost,
            path: "/login",
            param: ["facebook_token": facebook_token, "firebase_uid": firebase_uid],
            success: { code, data in
                self.authToken = data["auth_token"].stringValue
                self.getFacebookUsername({
                    success()
                })
            },
            failure: { code, data in
                self.authToken = ""
                failure()
            }
        )
    }
    
    func getFacebookUsername(complete: () -> Void) {
        
        FBSDKGraphRequest(graphPath: "me",
            parameters: ["fields": "name, first_name, last_name, picture.type(large)"])
            .startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil) {
                    self.user = ShaUser(data: result)
                }
                complete()
            })
    }
    
    func getUserByUid(uid: String, success: () -> Void, failure: () -> Void) {

        HttpManager.sharedInstance.request(
            .HttpMethodGet,
            path: "/users/\(uid)?auth_token=\(authToken)",
            param: [:],
            success: { code, data in
                self.users[uid] = ShaUser(jsonData: data["data"])
                success()
            },
            failure: { code, data in
                failure()
            }
        )
    }
}
