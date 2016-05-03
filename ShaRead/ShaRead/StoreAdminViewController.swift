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
    var books: [ShaBook]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        bookTableView.rowHeight = UITableViewAutomaticDimension
        bookTableView.estimatedRowHeight = 200
        
        if let footerView = bookTableView.tableFooterView {
            footerView.frame.size.height = 0
        }

        getAdminStore()
    }
    
    override func viewWillAppear(animated: Bool) {
        setTabBarVisible(true, animated: false)
    }

    override func viewWillDisappear(animated: Bool) {
        setTabBarVisible(false, animated: false)
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
    
    // MARK: - TabBar
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animateWithDuration(duration) {
                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, offsetY!)
                return
            }
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
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
    
    func getAdminStore() {
        HUD.show(.Progress)
        
        ShaManager.sharedInstance.getAdminStore(
            { stores in
                
                dispatch_async(dispatch_get_main_queue()) {
                    if stores.count == 0 {

                        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("StoreNameConfig") {
                            self.navigationController?.pushViewController(controller, animated: false)
                        }

                        HUD.hide()

                    } else {
                        self.store = stores[0]
                        self.navigationItem.title = self.store?.name
                        self.getAdminBook()
                    }
                }
            },
            failure: {
                HUD.flash(.Error)
            }
        )
    }
    
    func getAdminBook() {
        HUD.show(.Progress)
        
        ShaManager.sharedInstance.getAdminBook(
            { books in
                
                dispatch_async(dispatch_get_main_queue()) {
                    if books.count == 0 {
                        let storyboard = UIStoryboard(name: "BookAdmin", bundle: nil)
                        let controller = storyboard.instantiateViewControllerWithIdentifier("BookAdminController")

                        self.navigationController?.pushViewController(controller, animated: false)
                    } else {
                        self.books = books
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
}

extension StoreAdminViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StoreAdminBookCell", forIndexPath: indexPath) as! StoreAdminTableViewCell

        if let books = self.books {

            if let url = NSURL(string: books[indexPath.row].image) {
                cell.bookImageView.sd_setImageWithURL(url)
            }
            
            let price = books[indexPath.row].price
            let rent = books[indexPath.row].rent

            cell.bookNameLabel.text = books[indexPath.row].name
            cell.bookPriceLabel.text = "定價：\(price == 0 ? "? " : String(price))元"
            cell.bookRentLabel.text = "租金：\(rent == 0 ? "? " : String(rent))元"
            cell.bookCategoryLabel.text = books[indexPath.row].category
        }

        return cell
    }
}
