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

    let sectionTitleArray: [String] = [
        "店長推薦書籍",
        "最近瀏覽",
        "熱門書店",
        "最新書店"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Adjust table header height to half of screen
        if let headerView = mainTableView.tableHeaderView {
            headerView.frame.size.height = UIScreen.mainScreen().bounds.height / 2
        }

        if let footerView = mainTableView.tableFooterView {
            footerView.frame.size.height = 0
        }

        // Expand table row height according to content
        mainTableView.rowHeight = UITableViewAutomaticDimension
        mainTableView.estimatedRowHeight = 200
    }
    
    override func viewWillLayoutSubviews() {
        // Change to rounded search button
        searchButton.layer.cornerRadius = searchButton.frame.width / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainTableCell", forIndexPath: indexPath)

        return cell
    }
}
