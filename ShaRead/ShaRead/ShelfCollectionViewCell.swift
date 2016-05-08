//
//  ShelfCollectionViewCell.swift
//  ShaRead
//
//  Created by martin on 2016/4/20.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class ShelfCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        coverImageView.clipsToBounds = true
    }

}
