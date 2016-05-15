//
//  MailAdminTableViewCell.swift
//  ShaRead
//
//  Created by martin on 2016/5/14.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class MailAdminTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 30
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
