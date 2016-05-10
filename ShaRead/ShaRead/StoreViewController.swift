//
//  StoreViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/19.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import PKHUD

class StoreViewController: UIViewController {

    @IBOutlet weak var storeTableView: UITableView!
    @IBOutlet var storeTableHeaderView: StoreTableHeaderView!

    var store_id: Int = 0
    var selected_book: Int = 0

    var shelfSize: CGSize?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // config table view height
        
        let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
        let screenHeight: CGFloat = UIScreen.mainScreen().bounds.height
        
        shelfSize = CGSizeMake(screenWidth / 3, 150)
        storeTableHeaderView.frame.size.width = screenWidth
        storeTableView.tableHeaderView?.addSubview(storeTableHeaderView)
        storeTableView.rowHeight = UITableViewAutomaticDimension
        storeTableView.estimatedRowHeight = 200

        if let headerView = storeTableView.tableHeaderView {
            headerView.frame.size.height = screenHeight / 2
        }

        if let footerView = storeTableView.tableFooterView {
            footerView.frame.size.height = 0
        }
        
        // custom nav bar color
//        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
//        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        getStoreByID()

        dispatch_async(dispatch_get_main_queue(), {
            // workaround for ios8
            self.storeTableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Custom method
    func getStoreByID() {
        
        HUD.show(.Progress)
        ShaManager.sharedInstance.getStoreByID(store_id,
            success: {
                dispatch_async(dispatch_get_main_queue(), {
                    HUD.hide()
                    self.reloadHeaderData()
                    self.storeTableView.reloadData()
                })
            },
            failure: {
                HUD.flash(.Error)
            }
        )
    }

    func reloadHeaderData() {

        if let store = ShaManager.sharedInstance.stores[store_id] {

            storeTableHeaderView.bannerImageView.sd_setImageWithURL(store.image, placeholderImage: ShaImage.defaultBanner)
            storeTableHeaderView.storeNameLabel.text = store.name

            if let url = store.avatar {
                storeTableHeaderView.avatarImageView.sd_setImageWithURL(url, placeholderImage: ShaImage.defaultAvatar)
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let controller = segue.destinationViewController as? BookTableViewController {
            controller.book_id = selected_book
        }
    }

    @IBAction func navBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension StoreViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        if indexPath.section == 1 && indexPath.row == 1 {

            var count: Float = 0

            if let store = ShaManager.sharedInstance.stores[store_id] {
                count = Float(store.books.count)
            }

            return CGFloat(floor((count - 1) / 3) + 1) * shelfSize!.height
        }

        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("StoreDescriptionCell", forIndexPath: indexPath) as! StoreDescriptionTableViewCell
            let store = ShaManager.sharedInstance.stores[store_id]

            if indexPath.row == 0 {
                cell.titleLabel?.text = "關於書店"
                cell.descriptionLabel?.text = store?.description ?? ""
            }
            else if indexPath.row == 1 {
                cell.titleLabel?.text = "面交地點"
                cell.descriptionLabel?.text = store?.position.address ?? ""
            }

            return cell
        }

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ShelfCategoryTableViewCell", forIndexPath: indexPath) as! ShelfCategoryTableViewCell
            let store = ShaManager.sharedInstance.stores[store_id]
            
            cell.amountLabel.text = "共 \(store?.books.count ?? 0) 本書"

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ShelfTableViewCell", forIndexPath: indexPath) as! ShelfTableViewCell

            let itemWidth: CGFloat = shelfSize!.width
            let itemHeight: CGFloat = shelfSize!.height

            cell.shelfFlowLayout.itemSize = CGSizeMake(itemWidth, itemHeight)
            cell.shelfCollectionView.reloadData()

            return cell
        }
    }
}

extension StoreViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let store = ShaManager.sharedInstance.stores[store_id]
        return store?.books.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ShelfCollectionViewCell", forIndexPath: indexPath) as! ShelfCollectionViewCell
        let store = ShaManager.sharedInstance.stores[store_id]
        
        if let book = store?.books[indexPath.row] {
            if let url = NSURL(string: book.image) {
                cell.coverImageView.sd_setImageWithURL(url, placeholderImage: ShaImage.defaultCover)
            }
            cell.nameLabel.text = book.name
            cell.rentLabel.text = book.rent == 0 ? "? 元" : "\(book.rent) 元"
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let sender = collectionView.cellForItemAtIndexPath(indexPath) {

            if let store = ShaManager.sharedInstance.stores[store_id] {
                selected_book = store.books[indexPath.row].id
            }

            performSegueWithIdentifier("ShowBookDetail", sender: sender)
        }
    }
}

