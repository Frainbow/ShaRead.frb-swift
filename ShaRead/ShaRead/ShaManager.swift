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

class ShaStorePosition {
    var address: String = ""
    var longitude: Float = 0
    var latitude: Float = 0
}

class ShaAdminStore {
    var id: Int = 0
    var name: String = ""
    var image: NSURL?
    var description: String = ""
    var position = ShaStorePosition()
    var shelfs: [ShaShelf] = []
}

class ShaManager {
    static let sharedInstance = ShaManager()
    
    var adminStores: [ShaAdminStore] = []
    var authToken: String = ""
    
    init() {

    }
    
    func login(facebook_token: String, success: () -> Void, failure: () -> Void) {

        HttpManager.sharedInstance.request(
            .HttpMethodPost,
            path: "/login",
            param: ["facebook_token": facebook_token],
            success: { code, data in
                self.authToken = data["auth_token"].stringValue
                success()
            },
            failure: { code, data in
                self.authToken = ""
                failure()
            }
        )
    }
    
    func getAdminStore(success: ([ShaAdminStore]) -> Void, failure: () -> Void) {
        
        HttpManager.sharedInstance.request(
            .HttpMethodGet,
            path: "/stores",
            param: ["auth_token": self.authToken],
            success: { code, data in

                let storeList = data["data"].arrayValue

                self.adminStores.removeAll()
                
                for store in storeList {
                    let adminStore = ShaAdminStore()
                    
                    adminStore.id = store["store_id"].intValue
                    adminStore.name = store["store_name"].stringValue
                    adminStore.description = store["description"].stringValue

                    let position = store["position"].dictionaryValue
                    adminStore.position.address = position["address"]?.stringValue ?? ""
                    adminStore.position.longitude = position["longitude"]?.floatValue ?? 0
                    adminStore.position.latitude = position["latitude"]?.floatValue ?? 0
                    
                    self.adminStores.append(adminStore)
                }

                success(self.adminStores)
            },
            failure: { code, data in
                failure()
            }
        )
    }
}
