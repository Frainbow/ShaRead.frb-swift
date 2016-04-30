//
//  ShaManager.swift
//  ShaRead
//
//  Created by martin on 2016/4/28.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import Foundation
import SwiftyJSON

class ShaShelf {
    var category: String = ""
    var style: String = ""
}

class ShaStore {

}

class ShaAdminStore {
    var name: String = ""
    var image: NSURL?
    var description: String = ""
    var position: String = ""
    var shelfs: [ShaShelf] = []
}

class ShaManager {
    static let sharedInstance = ShaManager()
    
    let adminStore: ShaAdminStore
    var accessToken: String = ""
    
    init() {
        self.adminStore = ShaAdminStore()
    }
    
    func login(facebook_token: String, success: () -> Void, failure: () -> Void) {

        HttpManager.sharedInstance.request(
            .HttpMethodPost,
            path: "/login",
            param: ["facebook_token": facebook_token],
            success: { code, data in
                
                self.accessToken = data["auth_token"].stringValue
                success()
            },
            failure: { code, data in
                print(data ?? "no data responsed")
                self.accessToken = ""
                failure()
            }
        )
    }
}
