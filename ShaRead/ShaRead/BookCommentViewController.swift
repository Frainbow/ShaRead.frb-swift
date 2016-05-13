//
//  BookCommentViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/26.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import PKHUD

protocol BookCommentDelegate: class {
    func commentSaved()
}

class BookCommentViewController: UIViewController {

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var inputLengthLabel: UILabel!

    weak var delegate: BookCommentDelegate?
    weak var book: ShaBook?

    let maxInputLength: Int = 120

    override func viewDidLoad() {
        super.viewDidLoad()

        if let book = self.book {
            if book.comment.characters.count > 0 {
                inputTextView.text = book.comment
                placeholder.hidden = true
            }
        }

        inputLengthLabel.text = "(\(inputTextView.text.characters.count) / \(maxInputLength))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func save(sender: AnyObject) {

        if let inputText = inputTextView.text {
            
            if inputText.characters.count == 0 {
                let controller = UIAlertController(title: "錯誤", message: "請寫下您對這本書的評價", preferredStyle: .Alert)
                controller.addAction(UIAlertAction(title: "確定", style: .Default, handler: nil))
                presentViewController(controller, animated: true, completion: nil)
                return
            }
            
            if let book = self.book {
                
                let originComment = book.comment
                
                self.book?.comment = inputText

                HUD.show(.Progress)
                ShaManager.sharedInstance.updateAdminBook(book, column: [.ShaBookComment],
                    success: {
                        HUD.hide()
                        self.delegate?.commentSaved()
                        self.navigationController?.popViewControllerAnimated(true)
                    },
                    failure: {
                        self.book?.comment = originComment
                        HUD.flash(.Error)
                    }
                )
            }

        } else {

            let controller = UIAlertController(title: "錯誤", message: "請寫下您對這本書的評價", preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "確定", style: .Default, handler: nil))
            presentViewController(controller, animated: true, completion: nil)
        }
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

extension BookCommentViewController: UITextViewDelegate {
    
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
