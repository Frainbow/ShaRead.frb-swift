//
//  MRT.swift
//  ShaRead
//
//  Created by martin on 2016/5/14.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import Foundation
import SwiftyJSON

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

extension ShaManager {

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
}
