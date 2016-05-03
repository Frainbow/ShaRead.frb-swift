//
//  BookPriceViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/26.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import PKHUD

protocol BookPriceDelegate: class {
    func priceSaved()
}

class BookPriceViewController: UIViewController {
    
    @IBOutlet weak var priceTextField: UITextField!
    
    weak var delegate: BookPriceDelegate?
    weak var book: ShaBook?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func save(sender: AnyObject) {
        
        if let priceText = priceTextField.text {
            
            if priceText.characters.count == 0 {
                let controller = UIAlertController(title: "錯誤", message: "請輸入租金定價", preferredStyle: .Alert)
                controller.addAction(UIAlertAction(title: "確定", style: .Default, handler: nil))
                presentViewController(controller, animated: true, completion: nil)
                return
            }
            
            if Int(priceText) == nil {
                let controller = UIAlertController(title: "錯誤", message: "定價錯誤", preferredStyle: .Alert)
                controller.addAction(UIAlertAction(title: "確定", style: .Default, handler: nil))
                presentViewController(controller, animated: true, completion: nil)
                return
            }
            
            if let book = self.book {
                
                let originRent = book.rent
                
                self.book?.rent = Int(priceText)!
                
                HUD.show(.Progress)
                ShaManager.sharedInstance.updateAdminBook(book, column: [.ShaBookRent],
                    success: {
                        HUD.hide()
                        self.delegate?.priceSaved()
                        self.navigationController?.popViewControllerAnimated(true)
                    },
                    failure: {
                        self.book?.rent = originRent
                        HUD.flash(.Error)
                    }
                )
            }
        }
        else {

            let controller = UIAlertController(title: "錯誤", message: "請輸入租金定價", preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "確定", style: .Default, handler: nil))
            presentViewController(controller, animated: true, completion: nil)
        }
    }

    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }

    @IBAction func endOnExit(sender: AnyObject) {
        self.resignFirstResponder()
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
