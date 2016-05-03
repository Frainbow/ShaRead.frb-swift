//
//  BookNameViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/26.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import PKHUD

class BookNameViewController: UIViewController {
    @IBOutlet weak var inputTextField: UITextField!

    var book: ShaBook?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        newShaBook("9789864340729")
    }

    @IBAction func showScanner(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("SearchScannerController") as! ScannerViewController
        
        controller.delegate = self
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func newShaBook(code: String) {

        HUD.show(.Progress)
        ShaManager.sharedInstance.newAdminBook(code,
            success: { books in
                dispatch_async(dispatch_get_main_queue(), {
                    HUD.hide()
                    self.book = books[0]
                    self.performSegueWithIdentifier("ShowBookConfig", sender: nil)
                })
            },
            failure: {
                HUD.flash(.Error)
            }
        )
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let controller = segue.destinationViewController as? BookConfigViewController {
            controller.book = self.book
        }
    }

    @IBAction func navBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension BookNameViewController: ScannerDelegate {
    
    func captureCode(code: String) {
        self.navigationController?.popViewControllerAnimated(true)
        inputTextField.text = code
        newShaBook(code)
    }
}
