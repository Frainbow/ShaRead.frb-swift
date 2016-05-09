//
//  MainViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/13.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import PKHUD

class MainViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    var refreshControl: UIRefreshControl!

    var colWidth: CGFloat = 320
    var colHeight: CGFloat = 200
    var reqCount: Int = 0
    
    enum SectionItem: Int {
        case SectionRecommendBook = 0
//        case SectionHistory
        case SectionPopularStore
        case SectionLatestStore
    }

    let itemTitles: [SectionItem: String] = [
        .SectionRecommendBook: "店長推薦書籍",
//        .SectionHistory: "最近瀏覽",
        .SectionPopularStore: "熱門書店",
        .SectionLatestStore: "最新書店"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MainViewController.refreshTable), forControlEvents: .ValueChanged)
        mainTableView.addSubview(refreshControl)

        dispatch_async(dispatch_get_main_queue(), {
            let instance = ShaManager.sharedInstance
            
            if instance.recommendBooks.count == 0 {
                self.getRecommendBook()
            }
            
            if instance.popularStores.count == 0 {
                self.getPopularStore()
            }
            
            if instance.latestStores.count == 0 {
                self.getLatestStore()
            }
        })

        // config table view height

        let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
        let screenHeight: CGFloat = UIScreen.mainScreen().bounds.height

        // Adjust table header height to half of screen
        if let headerView = mainTableView.tableHeaderView {
            headerView.frame.size.height = screenHeight / 2
        }

        if let footerView = mainTableView.tableFooterView {
            footerView.frame.size.height = 0
        }

        // Expand table row height according to content
//        mainTableView.rowHeight = UITableViewAutomaticDimension
//        mainTableView.estimatedRowHeight = 500

        colWidth = screenWidth - screenWidth / 5
        colHeight = screenHeight / 2 - 80
    }

    override func viewWillLayoutSubviews() {
        // Change to rounded search button
        searchButton.layer.cornerRadius = searchButton.frame.width / 2
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        setTabBarVisible(true, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        setTabBarVisible(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom method
    
    func getRecommendBook() {

        if !refreshControl.refreshing {
            HUD.show(.Progress)
        }

        reqCount += 1
        ShaManager.sharedInstance.getRecommendBook({
            self.requestComplete()
        })
    }

    func getPopularStore() {

        if !refreshControl.refreshing {
            HUD.show(.Progress)
        }

        reqCount += 1
        ShaManager.sharedInstance.getPopularStore({
            self.requestComplete()
        })
    }

    func getLatestStore() {

        if !refreshControl.refreshing {
            HUD.show(.Progress)
        }

        reqCount += 1
        ShaManager.sharedInstance.getLatestStore({
            self.requestComplete()
        })
    }

    func requestComplete() {

        dispatch_async(dispatch_get_main_queue(), {
            self.reqCount -= 1

            if self.reqCount <= 0 {
                HUD.hide()
                self.refreshControl.endRefreshing()
                self.mainTableView.reloadData()
            }
        })
    }

    func refreshTable() {
        getRecommendBook()
        getPopularStore()
        getLatestStore()
    }

    // MARK: - IBAction

    @IBAction func searchBook(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("SearchNavController")

        presentViewController(controller, animated: false, completion: nil)
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
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return itemTitles.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if let item = SectionItem(rawValue: section) {
            return itemTitles[item]
        }
        
        return nil
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return colHeight
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = SectionItem(rawValue: indexPath.section)

        if item == .SectionRecommendBook {
            let cell = tableView.dequeueReusableCellWithIdentifier("BookTableViewCell", forIndexPath: indexPath) as! BookTableViewCell

            cell.bookFlowLayout.itemSize = CGSizeMake(colWidth, colHeight - 1)
            cell.bookCollectionView.tag = indexPath.section
            cell.reloadCollectionViewData()

            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("StoreTableViewCell", forIndexPath: indexPath) as! StoreTableViewCell

            cell.storeFlowLayout.itemSize = CGSizeMake(colWidth, colHeight - 1)
            cell.storeCollectionView.tag = indexPath.section
            cell.reloadCollectionViewData()

            return cell
        }
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let instance = ShaManager.sharedInstance
        let item = SectionItem(rawValue: collectionView.tag)

        if item == .SectionRecommendBook {
            return instance.recommendBooks.count
        }
//        else if item == .SectionHistory {
//            return instance.historyStores.count
//        }
        else if item == .SectionPopularStore {
            return instance.popularStores.count
        }
        else if item == .SectionLatestStore {
            return instance.latestStores.count
        }

        return 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let instance = ShaManager.sharedInstance
        let item = SectionItem(rawValue: collectionView.tag)
        
        if item == .SectionRecommendBook {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                "BookCollectionViewCell", forIndexPath: indexPath) as! BookCollectionViewCell
            
            cell.mainLabel.text = instance.recommendBooks[indexPath.row].name
            cell.descriptionLabel.text = instance.recommendBooks[indexPath.row].comment

            let rent = instance.recommendBooks[indexPath.row].rent
            cell.rentLabel.text = rent > 0 ? "\(rent) 元" : "? 元"

            if let url = NSURL(string: instance.recommendBooks[indexPath.row].image) {
                cell.bannerImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "shaRead-banner"))
            }

            if let url = instance.recommendBooks[indexPath.row].avatar {
                cell.avatarImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Avatar"))
            }

            return cell
        }

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            "StoreCollectionViewCell", forIndexPath: indexPath) as! StoreCollectionViewCell
        
        if item == .SectionPopularStore {
            cell.mainLabel.text = instance.popularStores[indexPath.row].name
            cell.descriptionLabel.text = instance.popularStores[indexPath.row].description
            
            if let url = instance.popularStores[indexPath.row].image {
                cell.bannerImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "shaRead-banner"))
            }

            if let url = instance.popularStores[indexPath.row].avatar {
                cell.avatarImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Avatar"))
            }
        }
        else if item == .SectionLatestStore {
            cell.mainLabel.text = instance.latestStores[indexPath.row].name
            cell.descriptionLabel.text = instance.latestStores[indexPath.row].description

            if let url = instance.latestStores[indexPath.row].image {
                cell.bannerImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "shaRead-banner"))
            }

            if let url = instance.latestStores[indexPath.row].avatar {
                cell.avatarImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Avatar"))
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let instance = ShaManager.sharedInstance
        let item = SectionItem(rawValue: collectionView.tag)
        

        if item == .SectionRecommendBook {
            let controller = storyboard?.instantiateViewControllerWithIdentifier("BookDetail") as! BookTableViewController

            controller.book_id = instance.recommendBooks[indexPath.row].id
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else {
            let controller = storyboard?.instantiateViewControllerWithIdentifier("StoreDetail") as! StoreViewController

            if item == .SectionPopularStore {
                controller.store_id = instance.popularStores[indexPath.row].id
            }
            else if item == .SectionLatestStore {
                controller.store_id = instance.latestStores[indexPath.row].id
            }

            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
