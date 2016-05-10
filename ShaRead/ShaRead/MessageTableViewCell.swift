//
//  MessageTableViewCell.swift
//  ShaRead
//
//  Created by martin on 2016/5/10.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageTableView: UITableView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 50
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
