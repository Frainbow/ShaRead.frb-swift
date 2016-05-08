//
//  MainCollectionViewCell.swift
//  ShaRead
//
//  Created by martin on 2016/4/18.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
//    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        bannerImageView.clipsToBounds = true

        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        avatarImageView.layer.borderWidth = 2
        
        shadowView.layer.masksToBounds = false
        shadowView.layer.borderWidth = 1
        shadowView.layer.borderColor = UIColor.lightGrayColor().CGColor
//        shadowView.layer.shadowColor = UIColor.blackColor().CGColor
//        shadowView.layer.shadowOffset = CGSizeMake(2, 2)
//        shadowView.layer.shadowOpacity = 0.3
    }
}
