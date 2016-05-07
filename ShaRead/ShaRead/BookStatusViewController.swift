//
//  BookStatusViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/26.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import PKHUD

protocol BookStatusDelegate: class {
    func statusSaved()
}

class BookStatusViewController: UIViewController {

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var inputLengthLabel: UILabel!

    weak var delegate: BookStatusDelegate?
    weak var book: ShaBook?

    let maxInputLength: Int = 60

    override func viewDidLoad() {
        super.viewDidLoad()

        if let book = self.book {
            if book.status.characters.count > 0 {
                inputTextView.text = book.status
                placeholder.hidden = true
            }

            if book.status.characters.count == 0 && ShaDemo == true {
                // default text for demo
                book.status = "九成新"
                inputTextView.text = book.status
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
                let controller = UIAlertController(title: "錯誤", message: "請描述一下這本書的概況", preferredStyle: .Alert)
                controller.addAction(UIAlertAction(title: "確定", style: .Default, handler: nil))
                presentViewController(controller, animated: true, completion: nil)
                return
            }
            
            if let book = self.book {
                
                let originStatus = book.status
                
                self.book?.status = inputText
                
                HUD.show(.Progress)
                ShaManager.sharedInstance.updateAdminBook(book, column: [.ShaBookStatus],
                    success: {
                        HUD.hide()
                        self.delegate?.statusSaved()
                        self.navigationController?.popViewControllerAnimated(true)
                    },
                    failure: {
                        self.book?.status = originStatus
                        HUD.flash(.Error)
                    }
                )
            }
            
        } else {
            
            let controller = UIAlertController(title: "錯誤", message: "請描述一下這本書的概況", preferredStyle: .Alert)
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

extension BookStatusViewController: UITextViewDelegate {
    
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
