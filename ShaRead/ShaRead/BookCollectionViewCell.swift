//
//  MainCollectionViewCell.swift
//  ShaRead
//
//  Created by martin on 2016/4/18.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bannerImageView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
}
