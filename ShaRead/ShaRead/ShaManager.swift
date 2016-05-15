//
//  ShaManager.swift
//  ShaRead
//
//  Created by martin on 2016/4/28.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import Foundation
import SwiftyJSON

class ShaManager {
    static let sharedInstance = ShaManager()

    let firebaseUrl: String = "https://sharead.firebaseio.com"

    var adminStores: [ShaStore] = []
    var adminBooks: [ShaBook] = []
    var stores: [Int: ShaStore] = [:]
    var books: [Int: ShaBook] = [:]
    var recommendBooks: [ShaBook] = []
    var popularStores: [ShaStore] = []
    var latestStores: [ShaStore] = []
    var users: [String: ShaUser] = [:]

    var mrtStation: MRTStation?
    var user: ShaUser?
    var authToken: String = ""
}
