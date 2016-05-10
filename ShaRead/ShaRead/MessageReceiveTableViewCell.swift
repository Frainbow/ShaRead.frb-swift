//
//  MessageReceiveTableViewCell.swift
//  ShaRead
//
//  Created by martin on 2016/5/10.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class MessageReceiveTableViewCell: UITableViewCell {

    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!

    func setMessage(message: String) {
        messageLabel.text = message
        messageLabel.sizeToFit()
        cornerView.layer.cornerRadius = 16
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
