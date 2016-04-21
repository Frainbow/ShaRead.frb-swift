//
//  SearchViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/16.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    var originalBarTintColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()

        scanButton.layer.cornerRadius = 5
        
        // custom nav bar color
        originalBarTintColor = self.navigationController?.navigationBar.barTintColor
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()

        searchTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = originalBarTintColor

        searchTextField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismissSearch(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.navigationController?.view.endEditing(true)
    }

    @IBAction func endOnExit(sender: AnyObject) {
        self.resignFirstResponder()

        performSegueWithIdentifier("ShowSearchResult", sender: sender)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
