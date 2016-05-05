//
//  ShaManager.swift
//  ShaRead
//
//  Created by martin on 2016/4/28.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import Foundation
import SwiftyJSON
import FBSDKCoreKit

class MRTStationExit {
    var name: String
    var longitude: Float
    var latitude: Float
    
    init(data: JSON) {
        self.name = data["exit"].stringValue
        self.longitude = data["longitude"].floatValue
        self.latitude = data["latitude"].floatValue
    }
}

class MRTStation {
    var station: [String: [MRTStationExit]]

    init(data: JSON) {
        station = [:]

        for (stationName, exitArray) in data.dictionaryValue {

            if station[stationName] == nil {
                station[stationName] = []
            }

            for exitData in exitArray.arrayValue {
                station[stationName]?.append(MRTStationExit(data: exitData))
            }
        }
    }
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
}

enum ShaBookItem: Int {
    case ShaBookRent = 0
    case ShaBookComment
    case ShaBookStatus
    case ShaBookCategory
    case ShaBookStyle
}

class ShaAdminStore {
    var id: Int = 0
    var name: String = ""
    var image: NSURL?
    var description: String = ""
    var position = ShaStorePosition()
}

class ShaBookBase {
    var isbn: String
    var name: String
    var author: String
    var publisher: String
    var price: Int
    var image: String
    
    init(data: JSON) {
        self.isbn = data["isbn"].stringValue
        self.name = data["name"].stringValue
        self.author = data["author"].stringValue
        self.publisher = data["publisher"].stringValue
        self.price = data["price"].intValue
        self.image = data["image_path"].stringValue
    }
}

class ShaBook: ShaBookBase {
    var id: Int = 0
    var status_image: [String] = []
    var rent: Int = 0
    var comment: String = ""
    var status: String = ""
    var category: String = ""
    var style: Int = 0

    override init(data: JSON) {
        super.init(data: data)

        self.id = data["id"].intValue
        self.rent = data["rent"].intValue
        self.comment = data["comment"].stringValue
        self.status = data["status"].stringValue
        self.category = data["category"].stringValue
        self.style = data["style"].intValue
    }
}

class ShaUser {
    var name: String
    var firstName: String
    var lastName: String
    var picture: String
    
    init(data: AnyObject) {
        self.firstName = data.valueForKey("first_name") as? String ?? ""
        self.lastName = data.valueForKey("last_name") as? String ?? ""
        self.name = data.valueForKey("name") as? String ?? ""
        self.picture = data.valueForKey("picture")?.valueForKey("data")?.valueForKey("url") as? String ?? ""
    }
}

class ShaManager {
    static let sharedInstance = ShaManager()

    var adminStores: [ShaAdminStore] = []
    var adminBooks: [ShaBook] = []

    var mrtStation: MRTStation?
    var user: ShaUser?
    var authToken: String = ""


    func login(facebook_token: String, success: () -> Void, failure: () -> Void) {

        HttpManager.sharedInstance.request(
            .HttpMethodPost,
            path: "/login",
            param: ["facebook_token": facebook_token],
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

    func getAdminStore(success: () -> Void, failure: () -> Void) {
        
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
    
    func getMRTStation(success: () -> Void, failure: () -> Void) {
        
        HttpManager.sharedInstance.request(
            .HttpMethodGet,
            path: "/mrt",
            param: [:],
            success: { code, data in
                self.mrtStation = MRTStation(data: data["data"])
                success()
            },
            failure: { code, data in
                failure()
            }
        )
    }
    
    func newAdminBook(isbn: String, success: () -> Void, failure: () -> Void) {

        HttpManager.sharedInstance.request(
            .HttpMethodPost,
            path: "/books?auth_token=\(authToken)",
            param: ["isbn": isbn],
            success: { code, data in

                for book in data["data"].arrayValue {
                    self.adminBooks.append(ShaBook(data: book))
                }

                success()
            },
            failure: { code, data in
                failure()
            }
        )
    }

    func getAdminBook(success: () -> Void, failure: () -> Void) {

        HttpManager.sharedInstance.request(
            .HttpMethodGet,
            path: "/books?auth_token=\(authToken)",
            param: [:],
            success: { code, data in

                self.adminBooks.removeAll()

                for book in data["data"].arrayValue {
                    self.adminBooks.append(ShaBook(data: book))
                }

                success()
            },
            failure: { code, data in
                failure()
            }
        )
    }
    
    func updateAdminBook(book: ShaBook, column: [ShaBookItem], success: () -> Void, failure: () -> Void) {

        var param = [String: AnyObject]()

        for item in column {
            switch item {
            case .ShaBookRent:
                param["rent"] = book.rent
            case .ShaBookComment:
                param["comment"] = book.comment
            case .ShaBookStatus:
                param["status"] = book.status
            case .ShaBookCategory:
                param["category"] = book.category
            case .ShaBookStyle:
                param["style"] = book.style
            }
        }

        HttpManager.sharedInstance.request(
            .HttpMethodPut,
            path: "/books/\(book.id)?auth_token=\(authToken)",
            param: param,
            success: { code, data in
                success()
            },
            failure: { code, data in
                failure()
            }
        )
    }

    func deleteAdminBook(book: ShaBook, success: () -> Void, failure: () -> Void) {

        if let index = self.adminBooks.indexOf({ $0.id == book.id }) {

            HttpManager.sharedInstance.request(
                .HttpMethodDelete,
                path: "/books/\(book.id)?auth_token=\(authToken)",
                param: [:],
                success: { code, data in
                    self.adminBooks.removeAtIndex(index)
                    success()
                },
                failure: { code, data in
                    failure()
                }
            )

            return
        }

        failure()
    }
}
