//
//  StoreAdminTableViewCell.swift
//  ShaRead
//
//  Created by martin on 2016/5/4.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class StoreAdminTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookPriceLabel: UILabel!
    @IBOutlet weak var bookRentLabel: UILabel!
    @IBOutlet weak var bookCategoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
