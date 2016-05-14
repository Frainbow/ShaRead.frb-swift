//
//  ShaBook.swift
//  ShaRead
//
//  Created by martin on 2016/5/14.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ShaBookItem: Int {
    case ShaBookRent = 0
    case ShaBookComment
    case ShaBookStatus
    case ShaBookCategory
    case ShaBookStyle
}

class ShaBookBase {
    var isbn: String
    var name: String
    var author: String
    var publisher: String
    var publish_date: String
    var price: Int
    var image: String
    
    init(data: JSON) {
        self.isbn = data["isbn"].stringValue
        self.name = data["name"].stringValue
        self.author = data["author"].stringValue
        self.publisher = data["publisher"].stringValue
        self.publish_date = ""
        self.price = data["price"].intValue
        self.image = data["image_path"].stringValue
        
        self.publish_date = formatDate(data["publish_date"].stringValue)
    }
    
    func formatDate(date: String) -> String {
        let formattor = NSDateFormatter()
        
        formattor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formattor.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        
        if let date = formattor.dateFromString(date) {
            formattor.dateFormat = "yyyy/MM/dd"
            return formattor.stringFromDate(date)
        }
        
        return ""
    }
}

class ShaBookImage {
    var id: Int
    var url: NSURL?
    
    init(data: JSON) {
        self.id = data["image_id"].intValue
        self.url = NSURL(string: data["image_path"].stringValue)
    }
}

class ShaBook: ShaBookBase {
    var id: Int = 0
    var rent: Int = 0
    var comment: String = ""
    var status: String = ""
    var category: String = ""
    var style: String = ""
    var avatar: NSURL?
    var owner: ShaUser?
    var store: ShaStore?
    var images: [ShaBookImage] = []
    
    override init(data: JSON) {
        super.init(data: data)

        self.id = data["id"].intValue
        self.rent = data["rent"].intValue
        self.comment = data["comment"].stringValue
        self.status = data["status"].stringValue
        self.category = data["category"].stringValue
        self.style = data["style"].stringValue
        self.avatar = NSURL(string: data["avatar"].stringValue)

        if data["store"].error == nil {
            self.store = ShaStore(data: data["store"])
        }

        if data["owner"].error == nil {
            self.owner = ShaUser(jsonData: data["owner"])
        }

        for image in data["images"].arrayValue {
            images.append(ShaBookImage(data: image))
        }
    }
}

extension ShaManager {

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
    
    func uploadBookImage(book: ShaBook, image: UIImage, success: () -> Void, failure: () -> Void) {
        let resizedImage = resizeImage(image, newWidth: 200)
        
        if let data = UIImageJPEGRepresentation(resizedImage, 0.1) {
            
            HttpManager.sharedInstance.uploadData(
                "/books/\(book.id)/images?auth_token=\(authToken)",
                name: "book_image",
                data: data,
                success: { (code, data) in
                    book.images.append(ShaBookImage(data: data["data"]))
                    success()
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

    func getRecommendBook(complete: () -> Void) {
        
        HttpManager.sharedInstance.request(
            .HttpMethodGet,
            path: "/books",
            param: ["order": "recommend"],
            success: { code, data in
                self.recommendBooks.removeAll()
                
                for book in data["data"].arrayValue {
                    self.recommendBooks.append(ShaBook(data: book))
                }
            },
            complete: {
                complete()
            }
        )
    }
    
    func getBookByID(id: Int, success: () -> Void, failure: () -> Void) {
        
        HttpManager.sharedInstance.request(
            .HttpMethodGet,
            path: "/books/\(id)",
            param: [:],
            success: { code, data in
                self.books[id] = ShaBook(data: data["data"])
                success()
            },
            failure: { code, data in
                failure()
            }
        )
    }
}

