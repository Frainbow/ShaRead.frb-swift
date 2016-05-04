//
//  BookCustomCategoryTableViewCell.swift
//  ShaRead
//
//  Created by martin on 2016/5/3.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

protocol BookCustomCategoryDelegate: class {
    func customCategoryChanged(category: String)
}

class BookCustomCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var inputLengthLabel: UILabel!
    
    let maxInputLength: Int = 10
    weak var delegate: BookCustomCategoryDelegate?
    
    var category: String = "" {

        didSet {
            let length = category.characters.count

            if length <= maxInputLength {
                inputTextField.text = category
                inputLengthLabel.text = "(\(length) / \(maxInputLength))"
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func inputEditingChanged(sender: AnyObject) {

        if let textField = sender as? UITextField, text = textField.text {
            let length = text.characters.count
            
            if length <= maxInputLength {
                inputLengthLabel.text = "(\(length) / \(maxInputLength))"
            } else {
                textField.text = String(text.characters.dropLast())
            }
            
            delegate?.customCategoryChanged(textField.text!)
        }
    }
}
