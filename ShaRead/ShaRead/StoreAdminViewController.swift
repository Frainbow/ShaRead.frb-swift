//
//  StoreAdminTableViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/27.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import PKHUD

class StoreAdminViewController: UIViewController {
    
    @IBOutlet weak var bookTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        HUD.show(.Progress)

        ShaManager.sharedInstance.getAdminStore(
            { stores in
                if stores.count == 0 {
                    dispatch_async(dispatch_get_main_queue()) {
                        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("StoreAdmin") {
                            self.navigationController?.pushViewController(controller, animated: false)
                        }
                    }
                } else {
                    self.bookTableView.reloadData()
                }

                HUD.hide()
            },
            failure: {
                HUD.flash(.Error)
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
