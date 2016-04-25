//
//  StoreConfigTableViewCell.swift
//  ShaRead
//
//  Created by martin on 2016/4/25.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class StoreConfigTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!

    var bgColor: UIColor?

    override func awakeFromNib() {
        super.awakeFromNib()

        checkButton.layer.cornerRadius = checkButton.frame.width / 2
        checkButton.layer.borderColor = UIColor.grayColor().CGColor
        bgColor = checkButton.backgroundColor

        toggleCheckMark(false)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func toggleCheckMark(mark: Bool) {
        checkButton.backgroundColor = mark ? bgColor : UIColor.whiteColor()
        checkButton.layer.borderWidth = mark ? 0 : 1
    }
}
