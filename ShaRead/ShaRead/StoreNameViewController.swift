//
//  StoreNameViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/24.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import PKHUD

class StoreNameViewController: UIViewController {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var inputLengthLabel: UILabel!

    var store: ShaAdminStore?
    let maxInputLength: Int = 20

    override func viewDidLoad() {
        super.viewDidLoad()

        inputTextField.becomeFirstResponder()
        inputTextField.text = store?.name
        inputLengthLabel.text = "(\(inputTextField.text?.characters.count ?? 0) / \(maxInputLength))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }

    @IBAction func endOnExit(sender: AnyObject) {
        self.resignFirstResponder()

        if inputTextField.text?.characters.count > 0 {
            
            if store == nil {
                store = ShaAdminStore()
                store?.name = inputTextField.text ?? ""

                HUD.show(.Progress)
                ShaManager.sharedInstance.newAdminStore(store!,
                    success: {
                        HUD.hide()
                        self.performSegueWithIdentifier("ShowStoreConfig", sender: sender)
                    },
                    failure: {
                        HUD.flash(.Error)
                    }
                )
            } else {
                store?.name = inputTextField.text ?? ""
                
                HUD.show(.Progress)
                ShaManager.sharedInstance.updateAdminStore(store!, column: [.ShaAdminStoreName],
                    success: {
                        HUD.hide()
                        self.performSegueWithIdentifier("ShowStoreConfig", sender: sender)
                    },
                    failure: {
                        HUD.flash(.Error)
                    }
                )
            }
        }
        else {
            let controller = UIAlertController(title: "錯誤", message: "請輸入您的店名", preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "確定", style: .Default, handler: nil))
            presentViewController(controller, animated: true, completion: nil)
        }
    }

    @IBAction func inputEditingChanged(sender: AnyObject) {

        if let textField = sender as? UITextField, text = textField.text {
            let length = text.characters.count

            if length <= maxInputLength {
                inputLengthLabel.text = "(\(length) / \(maxInputLength))"
            } else {
                textField.text = String(text.characters.dropLast())
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let controller = segue.destinationViewController as? StoreConfigViewController {
            controller.store = store
        }
    }

}
