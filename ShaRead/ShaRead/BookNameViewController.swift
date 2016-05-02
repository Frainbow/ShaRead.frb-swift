//
//  BookNameViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/26.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class BookNameViewController: UIViewController {
    @IBOutlet weak var inputTextField: UITextField!

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
        
        performSegueWithIdentifier("ShowBookConfig", sender: sender)
    }

    @IBAction func showScanner(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("SearchScannerController") as! ScannerViewController
        
        controller.delegate = self
        
        self.navigationController?.pushViewController(controller, animated: true)
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

extension BookNameViewController: ScannerDelegate {
    
    func captureCode(code: String) {
        self.navigationController?.popViewControllerAnimated(true)
        inputTextField.text = code
    }
}
