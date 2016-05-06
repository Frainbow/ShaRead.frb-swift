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
    
    var refreshControl: UIRefreshControl!

    var uploadBook: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(StoreAdminViewController.refreshTable), forControlEvents: .ValueChanged)
        bookTableView.addSubview(refreshControl)

        bookTableView.rowHeight = 100
//        bookTableView.rowHeight = UITableViewAutomaticDimension
//        bookTableView.estimatedRowHeight = 200

        if let footerView = bookTableView.tableFooterView {
            footerView.frame.size.height = 0
        }

        if ShaManager.sharedInstance.adminStores.count == 0 {
            getAdminStore()
        } else if ShaManager.sharedInstance.adminBooks.count == 0 {
            getAdminBook()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        let instance = ShaManager.sharedInstance

        if instance.adminStores.count != 0 {
            navigationItem.title = instance.adminStores[0].name
            bookTableView.reloadData()
        }

        if uploadBook == true {
            dispatch_async(dispatch_get_main_queue(), {
                self.uploadBook = false
                self.showBookAdminPage()
            })
        }
    }

    override func viewWillDisappear(animated: Bool) {
        setTabBarVisible(false, animated: false)
    }

    override func viewDidAppear(animated: Bool) {
        setTabBarVisible(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBAction
    
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

    }
    
    // MARK: - Custom method

    func showBookAdminPage() {
        let storyboard = UIStoryboard(name: "BookAdmin", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("BookAdminController")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func getAdminStore() {
        let instance = ShaManager.sharedInstance

        if !refreshControl.refreshing {
            HUD.show(.Progress)
        }

        instance.getAdminStore(
            { // success
                dispatch_async(dispatch_get_main_queue()) {

                    if instance.adminStores.count == 0 {
                        // Go to create store page
                        let controller = self.storyboard!
                            .instantiateViewControllerWithIdentifier("StoreNameConfig")
                        self.navigationController?.pushViewController(controller, animated: false)
                        self.refreshControl.endRefreshing()
                        HUD.hide()
                        return
                    }

                    // Get store books
                    self.navigationItem.title = instance.adminStores[0].name
                    self.getAdminBook()
                }
            },
            failure: {
                HUD.flash(.Error)
            }
        )
    }
    
    func getAdminBook() {
        let instance = ShaManager.sharedInstance

        if !refreshControl.refreshing {
            HUD.show(.Progress)
        }
        
        instance.getAdminBook(
            { // success
                dispatch_async(dispatch_get_main_queue()) {

                    if instance.adminBooks.count == 0 {
                        // Go to book create page
                        let storyboard = UIStoryboard(name: "BookAdmin", bundle: nil)
                        let controller = storyboard.instantiateViewControllerWithIdentifier("BookAdminController")

                        self.navigationController?.pushViewController(controller, animated: false)
                        self.refreshControl.endRefreshing()
                        HUD.hide()
                        return
                    }

                    self.bookTableView.reloadData()
                    self.refreshControl.endRefreshing()
                    HUD.hide()
                }
            },
            failure: {
                HUD.flash(.Error)
            }
        )
    }

    func refreshTable() {
        getAdminStore()
    }
}

extension StoreAdminViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShaManager.sharedInstance.adminBooks.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let books = ShaManager.sharedInstance.adminBooks
        let cell = tableView.dequeueReusableCellWithIdentifier("StoreAdminBookCell", forIndexPath: indexPath) as! StoreAdminTableViewCell

        if let url = NSURL(string: books[indexPath.row].image) {
            cell.bookImageView.sd_setImageWithURL(url)
        }

        let name = books[indexPath.row].name
        let price = books[indexPath.row].price
        let rent = books[indexPath.row].rent
        let category = books[indexPath.row].category

        cell.bookNameLabel.text = name
        cell.bookPriceLabel.text = "定價：\(price == 0 ? "? " : String(price))元"
        cell.bookRentLabel.text = "租金：\(rent == 0 ? "? " : String(rent))元"
        cell.bookCategoryLabel.text = category

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Go to book config page
        let books = ShaManager.sharedInstance.adminBooks
        let storyboard = UIStoryboard(name: "BookAdmin", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("BookAdminConfigController") as! BookConfigViewController

        controller.book = books[indexPath.row]

        self.navigationController?.pushViewController(controller, animated: true)
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        let instance = ShaManager.sharedInstance

        if editingStyle == .Delete {

            HUD.show(.Progress)
            instance.deleteAdminBook(instance.adminBooks[indexPath.row],
                success: {
                    HUD.hide()
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                },
                failure: {
                    HUD.flash(.Error)
                }
            )
        }
    }
}
