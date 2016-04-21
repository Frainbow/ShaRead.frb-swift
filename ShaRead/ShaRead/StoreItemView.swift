//
//  StoreItemView.swift
//  ShaRead
//
//  Created by martin on 2016/4/21.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class StoreItemView: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.blackColor().CGColor
        shadowView.layer.shadowOffset = CGSizeMake(2, 2)
        shadowView.layer.shadowOpacity = 0.3
    }
}
