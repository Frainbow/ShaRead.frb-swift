//
//  MessageFooterView.swift
//  ShaRead
//
//  Created by martin on 2016/5/10.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

protocol MessageFooterDelegate: class {
    func textFieldFocused()
    func textFieldBlurred()
    func submitMessage(message: String)
}

class MessageFooterView: UIView {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    weak var delegate: MessageFooterDelegate?

    override func awakeFromNib() {
        submitButton.layer.cornerRadius = 5
    }

    @IBAction func editBegin(sender: AnyObject) {
        delegate?.textFieldFocused()
    }

    @IBAction func editEnd(sender: AnyObject) {
        delegate?.textFieldBlurred()
    }

    @IBAction func endOnExit(sender: AnyObject) {
        inputTextField.resignFirstResponder()
    }

    @IBAction func submit(sender: AnyObject) {
        delegate?.submitMessage(inputTextField.text!)
        inputTextField.text?.removeAll()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
