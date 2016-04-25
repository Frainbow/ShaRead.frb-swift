//
//  StoreDescriptionViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/25.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class StoreDescriptionViewController: UIViewController {

    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var inputLengthLabel: UILabel!

    let maxInputLength: Int = 60

    override func viewDidLoad() {
        super.viewDidLoad()

        inputLengthLabel.text = "(0 / \(maxInputLength))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func navBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension StoreDescriptionViewController: UITextViewDelegate {

    func textViewDidChange(textView: UITextView) {

        let length = textView.text.characters.count

        if length <= maxInputLength {
            inputLengthLabel.text = "(\(length) / \(maxInputLength))"
        } else {
            textView.text = String(textView.text.characters.dropLast())
        }
    }

    func textViewDidBeginEditing(textView: UITextView) {
        placeholder.hidden = true
    }

    func textViewDidEndEditing(textView: UITextView) {
        let length = textView.text.characters.count

        if length == 0 {
            placeholder.hidden = false
        }
    }
}
