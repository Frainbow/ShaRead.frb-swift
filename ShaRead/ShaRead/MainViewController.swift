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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Adjust table header height to half of screen
        if let headerView = mainTableView.tableHeaderView {
            headerView.frame.size.height = UIScreen.mainScreen().bounds.height / 2
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainTableCell", forIndexPath: indexPath)

        return cell
    }
}
