//
//  StoreDescriptionViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/25.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import PKHUD

protocol StoreDescriptionDelegate: class {
    func descriptionSaved()
}

class StoreDescriptionViewController: UIViewController {

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var inputLengthLabel: UILabel!

    weak var delegate: StoreDescriptionDelegate?

    let maxInputLength: Int = 60

    override func viewDidLoad() {
        super.viewDidLoad()

        let stores = ShaManager.sharedInstance.adminStores

        if stores.count != 0 {
            inputTextView.text = stores[0].description
        }
        
        if inputTextView.text.characters.count == 0 {
            // default text for demo
            inputTextView.text = "閱讀共享，傳遞知識，讓家裡的書，不再只是書櫃上的裝飾品。"
        }

        inputTextView.becomeFirstResponder()
        inputLengthLabel.text = "(\(inputTextView.text.characters.count ?? 0) / \(maxInputLength))"
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

    @IBAction func save(sender: AnyObject) {

        let instance = ShaManager.sharedInstance
        
        if inputTextView.text.characters.count > 0 {
            
            if instance.adminStores.count > 0 {
                let store = instance.adminStores[0]
                let originDescription = store.description

                store.description = inputTextView.text

                HUD.show(.Progress)
                instance.updateAdminStore(store, column: [.ShaAdminStoreDescription],
                    success: {
                        HUD.hide()
                        // Go to previous page
                        self.delegate?.descriptionSaved()
                        self.navigationController?.popViewControllerAnimated(true)
                    },
                    failure: {
                        HUD.flash(.Error)
                        // Recover value
                        store.description = originDescription
                    }
                )
            }
            
            return
        }

        // Error handling
        let controller = UIAlertController(title: "錯誤", message: "請描述您書店的特色", preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "確定", style: .Default, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
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
