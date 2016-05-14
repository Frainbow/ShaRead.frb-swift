//
//  ShaDefault.swift
//  ShaRead
//
//  Created by martin on 2016/5/14.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import Foundation
import UIKit

class ShaDefault {
    static let defaultBanner = UIImage(named: "shaRead-banner")
    static let defaultCover = UIImage(named: "default-cover")
    static let defaultAvatar = UIImage(named: "Avatar")
}

extension ShaManager {

    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
