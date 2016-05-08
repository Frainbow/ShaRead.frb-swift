//
//  BookStoreDescriptionTableViewCell.swift
//  ShaRead
//
//  Created by martin on 2016/5/8.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class BookStoreDescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImageView.layer.cornerRadius = 32
        avatarImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
