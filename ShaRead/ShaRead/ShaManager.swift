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

enum ShaAdminStoreItem: Int {
    case ShaAdminStoreName = 0
    case ShaAdminStoreDescription
    case ShaAdminStorePosition
    case ShaAdminStoreCategory
    case ShaAdminStoreStyle
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
    
    func newAdminStore(store: ShaAdminStore, success: () -> Void, failure: () -> Void) {

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

    func updateAdminStore(store: ShaAdminStore, column: [ShaAdminStoreItem],
                          success: () -> Void, failure: () -> Void) {
        
        var param = [String: AnyObject]()
        
        for item in column {
            switch item {
            case .ShaAdminStoreName:
                param["store_name"] = store.name
            case .ShaAdminStoreDescription:
                param["description"] = store.description
            default:
                break
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
    
    func uploadAdminStoreImage(store: ShaAdminStore, image: UIImage, success: (url: NSURL) -> Void, failure: () -> Void) {
        
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
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
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
                    adminStore.image = NSURL(string: store["store_image"].stringValue)
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
