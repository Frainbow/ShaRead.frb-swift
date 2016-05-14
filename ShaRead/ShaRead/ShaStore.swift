//
//  ShaStore.swift
//  ShaRead
//
//  Created by martin on 2016/5/14.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ShaAdminStoreItem: Int {
    case ShaAdminStoreName = 0
    case ShaAdminStoreDescription
    case ShaAdminStorePosition
}

class ShaStorePosition {
    var address: String = ""
    var longitude: Float = 0
    var latitude: Float = 0
}

class ShaStore {
    var id: Int = 0
    var name: String = ""
    var image: NSURL?
    var description: String = ""
    var avatar: NSURL?
    var owner: ShaUser?
    var position = ShaStorePosition()
    var books: [ShaBook] = []
    
    init() {
        
    }
    
    init (data: JSON) {
        self.id = data["store_id"].intValue
        self.name = data["store_name"].stringValue
        self.description = data["description"].stringValue
        self.position.address = data["position"]["address"].stringValue
        
        if data["store_image"].error == nil {
            self.image = NSURL(string: data["store_image"].stringValue)
        }
        
        if data["owner"].error == nil {
            self.owner = ShaUser(jsonData: data["owner"])
        }
        
        if data["avatar"].error == nil {
            self.avatar = NSURL(string: data["avatar"].stringValue)
        }
        
        for book in data["books"].arrayValue {
            self.books.append(ShaBook(data: book))
        }
    }
}

extension ShaManager {

    func newAdminStore(store: ShaStore, success: () -> Void, failure: () -> Void) {
        
        HttpManager.sharedInstance.request(
            .HttpMethodPost,
            path: "/stores?auth_token=\(authToken)",
            param: [ "store_name": store.name ],
            success: { code, data in
                store.id = data["store_id"].intValue
                self.adminStores.append(store)
                success()
            },
            failure: { code, data in
                failure()
            }
        )
    }
    
    func getAdminStore(success: () -> Void, failure: () -> Void) {
        
        HttpManager.sharedInstance.request(
            .HttpMethodGet,
            path: "/stores",
            param: ["auth_token": self.authToken],
            success: { code, data in
                
                let storeList = data["data"].arrayValue
                
                self.adminStores.removeAll()
                
                for store in storeList {
                    let adminStore = ShaStore(data: store)
                    self.adminStores.append(adminStore)
                }
                
                success()
            },
            failure: { code, data in
                failure()
            }
        )
    }
    
    func updateAdminStore(store: ShaStore, column: [ShaAdminStoreItem],
                          success: () -> Void, failure: () -> Void) {
        
        var param = [String: AnyObject]()
        
        for item in column {
            switch item {
            case .ShaAdminStoreName:
                param["store_name"] = store.name
            case .ShaAdminStoreDescription:
                param["description"] = store.description
            case .ShaAdminStorePosition:
                param["address"] = store.position.address
                param["longitude"] = store.position.longitude
                param["latitude"] = store.position.latitude
            }
        }
        
        HttpManager.sharedInstance.request(
            .HttpMethodPut,
            path: "/stores/\(store.id)?auth_token=\(authToken)",
            param: param,
            success: { code, data in
                success()
            },
            failure: { code, data in
                failure()
            }
        )
    }
    
    func uploadAdminStoreImage(store: ShaStore, image: UIImage, success: (url: NSURL) -> Void, failure: () -> Void) {
        
        let resizedImage = resizeImage(image, newWidth: 200)
        
        if let data = UIImageJPEGRepresentation(resizedImage, 0.1) {
            
            HttpManager.sharedInstance.uploadData(
                "/stores/\(store.id)/images?auth_token=\(authToken)",
                name: "store_image",
                data: data,
                success: { (code, data) in
                    if let url = NSURL(string: data["image_path"].stringValue) {
                        success(url: url)
                    } else {
                        failure()
                    }
                },
                failure: { (code, data) in
                    failure()
                }
            )
        } else {
            failure()
        }
    }
}

extension ShaManager {

    func getPopularStore(complete: () -> Void) {
        
        HttpManager.sharedInstance.request(
            .HttpMethodGet,
            path: "/stores",
            param: ["order": "popular"],
            success: { code, data in
                self.popularStores.removeAll()
                
                for store in data["data"].arrayValue {
                    self.popularStores.append(ShaStore(data: store))
                }
            },
            complete: {
                complete()
            }
        )
    }
    
    func getLatestStore(complete: () -> Void) {
        
        HttpManager.sharedInstance.request(
            .HttpMethodGet,
            path: "/stores",
            param: ["order": "latest"],
            success: { code, data in
                self.latestStores.removeAll()
                
                for store in data["data"].arrayValue {
                    self.latestStores.append(ShaStore(data: store))
                }
            },
            complete: {
                complete()
            }
        )
    }
    
    func getStoreByID(id: Int, success: () -> Void, failure: () -> Void) {
        
        HttpManager.sharedInstance.request(
            .HttpMethodGet,
            path: "/stores/\(id)",
            param: [:],
            success: { code, data in
                self.stores[id] = ShaStore(data: data["data"])
                success()
            },
            failure: { code, data in
                failure()
            }
        )
    }
    
    func getStoreBooks(store: ShaStore, success: () -> Void, failure: () -> Void) {
        
        HttpManager.sharedInstance.request(
            .HttpMethodGet,
            path: "/stores/\(store.id)/books",
            param: [:],
            success: { code, data in
                store.books.removeAll()
                
                for book in data["data"].arrayValue {
                    store.books.append(ShaBook(data: book))
                }
                
                success()
            },
            failure: { code, data in
                failure()
            }
        )
    }
}
