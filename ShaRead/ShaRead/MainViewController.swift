//
//  MainViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/13.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    var colWidth: CGFloat = 320
    var colHeight: CGFloat = 200

    let sectionTitleArray: [String] = [
        "店長推薦書籍",
        "最近瀏覽",
        "熱門書店",
        "最新書店"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchBook(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("SearchNavController")

        presentViewController(controller, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitleArray.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitleArray[section]
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return colHeight
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainTableCell", forIndexPath: indexPath) as! MainTableViewCell

        cell.mainFlowLayout.itemSize = CGSizeMake(colWidth, colHeight - 1)

        return cell
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MainCollectionViewCell", forIndexPath: indexPath)

        return cell
    }
}
