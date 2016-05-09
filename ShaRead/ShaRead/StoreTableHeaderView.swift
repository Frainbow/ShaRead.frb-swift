//
//  StoreTableHeaderView.swift
//  ShaRead
//
//  Created by martin on 2016/5/7.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class StoreTableHeaderView: UIView {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var shopDateLabel: UILabel!
    
    override func awakeFromNib() {
        bannerImageView.clipsToBounds = true

        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 70 / 2
        avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        avatarImageView.layer.borderWidth = 2
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
