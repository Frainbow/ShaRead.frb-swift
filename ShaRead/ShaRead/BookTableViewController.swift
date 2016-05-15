//
//  BookTableViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/22.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import PKHUD

class BookTableViewController: UITableViewController {

    @IBOutlet var bookTableHeaderView: BookTableHeaderView!

    var book_id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // config table view height
        
        let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
        let screenHeight: CGFloat = UIScreen.mainScreen().bounds.height

        bookTableHeaderView.bannerCollectionView.dataSource = self
        bookTableHeaderView.bannerCollectionView.delegate = self
        bookTableHeaderView.bannerFlowLayout.itemSize = CGSizeMake(screenWidth, 200)
        bookTableHeaderView.frame.size.width = screenWidth
        tableView.tableHeaderView?.addSubview(bookTableHeaderView)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200

        if let headerView = tableView.tableHeaderView {
            headerView.frame.size.height = 200
        }
        
        if let footerView = tableView.tableFooterView {
            footerView.frame.size.height = 0
        }

        getBookByID()

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
    
    func getBookByID() {

        HUD.show(.Progress)
        ShaManager.sharedInstance.getBookByID(book_id,
            success: {
                dispatch_async(dispatch_get_main_queue(), {
                    HUD.hide()
                    self.reloadHeaderData()
                    self.tableView.reloadData()
                })
            },
            failure: {
                HUD.flash(.Error)
            }
        )
    }
    
    func reloadHeaderData() {
        bookTableHeaderView.bannerCollectionView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 10
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("BookBasic", forIndexPath: indexPath) as! BookBasicTableViewCell
            let book = ShaManager.sharedInstance.books[book_id]

            cell.nameLabel.text = book?.name ?? ""
            cell.authorLabel.text = book?.author ?? ""
            cell.publisherLabel.text = book?.publisher ?? ""
            cell.publishDateLabel.text = book?.publish_date ?? ""
            cell.priceLabel.text = book?.price > 0 ? "\((book?.price)!) 元" : "? 元"
            cell.delegate = self

            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("BookDescription", forIndexPath: indexPath) as! BookDescriptionTableViewCell
            let book = ShaManager.sharedInstance.books[book_id]

            cell.rentLabel.text = book?.rent > 0 ? "\((book?.rent)!) 元" : "? 元"
            cell.commentLabel.text = book?.comment ?? ""
            cell.statusLabel.text = book?.status ?? ""

            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("BookStoreDescription", forIndexPath: indexPath) as! BookStoreDescriptionTableViewCell
            let book = ShaManager.sharedInstance.books[book_id]

            if let url = book?.store?.avatar {
                cell.avatarImageView.sd_setImageWithURL(url, placeholderImage: ShaDefault.defaultAvatar)
            }

            cell.storeNameLabel.text = book?.store?.name ?? ""
            cell.storeDescriptionLabel.text = book?.store?.description ?? ""

            return cell
        }
        else if indexPath.section == 3 {

            if indexPath.row == 0 {

                let cell = tableView.dequeueReusableCellWithIdentifier("BookCommentForm", forIndexPath: indexPath) as! BookCommentFormTableViewCell

                if let avatar = ShaManager.sharedInstance.user?.avatar,
                    url = NSURL(string: avatar) {
                    cell.avatarImageView.sd_setImageWithURL(url, placeholderImage: ShaDefault.defaultAvatar)
                }

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

    @IBAction func showMessage(sender: AnyObject) {

        if let controller = storyboard?.instantiateViewControllerWithIdentifier("MessageController") as? MessageTableViewController {
            let book = ShaManager.sharedInstance.books[book_id]
            controller.targetUser = book?.owner
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}


extension BookTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if let book = ShaManager.sharedInstance.books[book_id] {
            return book.images.count > 0 ? book.images.count : 1
        }
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BannerImageCell", forIndexPath: indexPath) as! BookImageCollectionViewCell
        
        cell.bookImageView.clipsToBounds = true
        
        if let book = ShaManager.sharedInstance.books[book_id] {

            if book.images.count > 0 {
                cell.bookImageView.sd_setImageWithURL(book.images[indexPath.row].url, placeholderImage: ShaDefault.defaultBanner)
            } else if let url = NSURL(string: book.image) {
                cell.bookImageView.sd_setImageWithURL(url, placeholderImage: ShaDefault.defaultBanner)
            }
        }

        return cell
    }

}

extension BookTableViewController: BookBasicDelegate {

    func addItem() {
        let controller = UIAlertController(title: "已將此書籍\n加入租借清單", message: "", preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "關閉", style: .Default, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
    }
}
