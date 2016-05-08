//
//  BookCommentFormTableViewCell.swift
//  ShaRead
//
//  Created by martin on 2016/5/8.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class BookCommentFormTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImageView.layer.cornerRadius = 32
        avatarImageView.clipsToBounds = true
        inputTextView.delegate = self
        inputTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        inputTextView.layer.borderWidth = 1
        submitButton.layer.cornerRadius = 5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension BookCommentFormTableViewCell: UITextViewDelegate {

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {

        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }

        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        placeholderLabel.hidden = true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textView.resignFirstResponder()
        
        if textView.text.characters.count == 0 {
            placeholderLabel.hidden = false
        }
    }
}
