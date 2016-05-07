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

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var storeTableView: UITableView!

    weak var store: ShaStore?

    var shelfSize: CGSize?

    override func viewDidLoad() {
        super.viewDidLoad()

        // init content
        if let store = self.store {
            bannerImageView.sd_setImageWithURL(store.image)
        }

        if store?.books.count == 0 {
            getStoreBooks();
        }

        // config table view height

        let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
        let screenHeight: CGFloat = UIScreen.mainScreen().bounds.height

        shelfSize = CGSizeMake(screenWidth / 3, 100)

        if let headerView = storeTableView.tableHeaderView {
            headerView.frame.size.height = screenHeight / 3
        }

        if let footerView = storeTableView.tableFooterView {
            footerView.frame.size.height = 0
        }
        
        // custom nav bar color
//        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
//        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

//        storeTableView.rowHeight = UITableViewAutomaticDimension
//        storeTableView.estimatedRowHeight = 200
    }
    
    override func viewWillLayoutSubviews() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom method
    func getStoreBooks() {
        
        HUD.show(.Progress)
        ShaManager.sharedInstance.getStoreBooks(store!,
            success: {
                HUD.hide()
                self.storeTableView.reloadData()
            },
            failure: {
                HUD.flash(.Error)
            }
        )
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

extension StoreViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "" : "書籍清單"
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 200
        }

        var count: Float = 0

        if store != nil {
            count = Float(store!.books.count)
        }

        return CGFloat(floor((count - 1) / 3) + 1) * shelfSize!.height
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("StoreDescriptionCell", forIndexPath: indexPath) as! StoreDescriptionTableViewCell
            
            if let store = self.store {
                cell.storeNameLabel.text = store.name
                cell.descriptionLabel.text = store.description
            }

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
        return store?.books.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ShelfCollectionViewCell", forIndexPath: indexPath) as! ShelfCollectionViewCell

        if let book = self.store?.books[indexPath.row] {
            if let url = NSURL(string: book.image) {
                cell.coverImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default-cover"))
            }
            cell.nameLabel.text = book.name
            cell.rentLabel.text = String(book.rent)
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let sender = collectionView.cellForItemAtIndexPath(indexPath) {
            performSegueWithIdentifier("ShowBookDetail", sender: sender)
        }
    }
}

