//
//  BookBasicTableViewCell.swift
//  ShaRead
//
//  Created by martin on 2016/5/9.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class BookBasicTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addListButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addListButton.layer.cornerRadius = 5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
