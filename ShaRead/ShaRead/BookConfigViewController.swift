//
//  BookConfigViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/26.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class BookConfig {
    var title: String
    var description: String
    var identifier: String
    
    init(title: String, description: String, identifier: String) {
        self.title = title
        self.description = description
        self.identifier = identifier
    }
}

class BookConfigViewController: UIViewController {

    @IBOutlet weak var configTableView: UITableView!

    var configItems: [BookConfig]?

    override func viewDidLoad() {
        super.viewDidLoad()

        let screenHeight = UIScreen.mainScreen().bounds.height
        var navHeight: CGFloat = 0
        var headerHeight: CGFloat = 0
        let rowHeight: CGFloat = 70
        var bodyHeight: CGFloat = 0
        var footerHeight: CGFloat = 0

        // init config items
        configItems = [
            BookConfig(title: "租金定價", description: "您可以參考我們建議的價格", identifier: "BookPrice"),
            BookConfig(title: "填寫書評", description: "寫下您對這本書的評價吧", identifier: "BookComment"),
            BookConfig(title: "填寫書況", description: "描述一下這本書的概況吧", identifier: "BookStatus")
        ]

        // config table view height

        if let navController = self.navigationController {
            navHeight = navController.navigationBar.frame.height
        }

        if let headerVeiw = configTableView.tableHeaderView {
            headerHeight = 200
            headerVeiw.frame.size.height = headerHeight
        }

        configTableView.registerNib(UINib(nibName: "StoreConfigTableViewCell", bundle: nil), forCellReuseIdentifier: "BookConfigCell")
        configTableView.rowHeight = rowHeight

        if let config = configItems {
            bodyHeight = rowHeight * CGFloat(config.count)
        }

        if let footerVeiw = configTableView.tableFooterView {
            footerHeight = screenHeight - navHeight - headerHeight - bodyHeight
            footerVeiw.frame.size.height = footerHeight > 40 ? footerHeight : 40
        }
    }

    override func viewWillAppear(animated: Bool) {

        // deselect row on appear
        if let indexPath = configTableView.indexPathForSelectedRow {
            configTableView.deselectRowAtIndexPath(indexPath, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func adminBookPhoto(sender: AnyObject) {

        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("BookPhoto") {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    @IBAction func navBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}

extension BookConfigViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configItems?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BookConfigCell", forIndexPath: indexPath) as! StoreConfigTableViewCell

        if let config = self.configItems?[indexPath.row] {
            cell.titleLabel.text = config.title
            cell.subtitleLabel.text = config.description
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if let config = self.configItems?[indexPath.row],
            controller = self.storyboard?.instantiateViewControllerWithIdentifier(config.identifier) {
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
