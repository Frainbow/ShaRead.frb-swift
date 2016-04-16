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

    override func viewDidLoad() {
        super.viewDidLoad()

        scanButton.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissSearch(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
