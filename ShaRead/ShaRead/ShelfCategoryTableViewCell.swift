//
//  ShelfCategoryTableViewCell.swift
//  ShaRead
//
//  Created by martin on 2016/5/8.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class ShelfCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
