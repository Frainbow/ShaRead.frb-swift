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
    
    var store: ShaAdminStore?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        HUD.show(.Progress)

        ShaManager.sharedInstance.getAdminStore(
            { stores in

                dispatch_async(dispatch_get_main_queue()) {
                    if stores.count == 0 {

                        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("StoreNameConfig") {
                            self.navigationController?.pushViewController(controller, animated: false)
                        }

                    } else {
                        self.store = stores[0]
                        self.navigationItem.title = self.store?.name
                        self.bookTableView.reloadData()
                    }

                    HUD.hide()
                }
            },
            failure: {
                HUD.flash(.Error)
            }
        )
    }
    
    override func viewDidAppear(animated: Bool) {

        if store != nil && animated == false {
            showBookAdminPage()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func editBookStore(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowStoreNameConfig", sender: sender)
    }

    @IBAction func adminBooks(sender: AnyObject) {
        showBookAdminPage()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let controller = segue.destinationViewController as? StoreNameViewController {
            if ShaManager.sharedInstance.adminStores.count > 0 {
                controller.store = self.store
            }
        }
    }
    
    func showBookAdminPage() {
        let storyboard = UIStoryboard(name: "BookAdmin", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("BookAdminController")
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

extension StoreAdminViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShaManager.sharedInstance.adminStores.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StoreAdminBookCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = "Book1"
        
        return cell
    }
}
