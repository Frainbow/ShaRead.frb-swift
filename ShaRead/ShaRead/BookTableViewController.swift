//
//  BookTableViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/22.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class BookTableViewController: UITableViewController {

    @IBOutlet var bookTableHeaderView: BookTableHeaderView!

    weak var book: ShaBook?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // config table view height
        
        let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
        let screenHeight: CGFloat = UIScreen.mainScreen().bounds.height

        bookTableHeaderView.frame.size.width = screenWidth
        tableView.tableHeaderView?.addSubview(bookTableHeaderView)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200

        if let headerView = tableView.tableHeaderView {
            headerView.frame.size.height = 380
        }
        
        if let footerView = tableView.tableFooterView {
            footerView.frame.size.height = 0
        }
        
        // init content
        bookTableHeaderView.nameLabel.text = book?.name ?? ""
        bookTableHeaderView.authorLabel.text = book?.author ?? ""
        bookTableHeaderView.publisherLabel.text = book?.publisher ?? ""
        bookTableHeaderView.publishDateLabel.text = ""
        bookTableHeaderView.priceLabel.text = book?.price > 0 ? "\((book?.price)!) 元" : "? 元"
        bookTableHeaderView.addListButton.layer.cornerRadius = 5
        
        dispatch_async(dispatch_get_main_queue(), {
            // workaround for ios8
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {

        let screenHeight: CGFloat = UIScreen.mainScreen().bounds.height
        
        if let tabBar = tabBarController?.tabBar {
            // workaround for expanding to tabbar item
            tableView.frame.size.height = screenHeight + tabBar.frame.height
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("BookDescription", forIndexPath: indexPath) as! BookDescriptionTableViewCell

            cell.rentLabel.text = book?.rent > 0 ? "\((book?.rent)!) 元" : "? 元"
            cell.commentLabel.text = book?.comment ?? ""
            cell.statusLabel.text = book?.status ?? ""

            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("BookStoreDescription", forIndexPath: indexPath) as! BookStoreDescriptionTableViewCell
            
            return cell
        }
        else if indexPath.section == 2 {
            
            if indexPath.row == 0 {

                let cell = tableView.dequeueReusableCellWithIdentifier("BookCommentForm", forIndexPath: indexPath) as! BookCommentFormTableViewCell
                
                return cell
            } else {

                let cell = tableView.dequeueReusableCellWithIdentifier("BookComment", forIndexPath: indexPath) as! BookCommentTableViewCell
                
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("", forIndexPath: indexPath)

            return cell
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
