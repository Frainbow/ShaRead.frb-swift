//
//  StoreConfigViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/24.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class StoreConfig {
    var title: String
    var description: String
    var identifier: String
    
    init(title: String, description: String, identifier: String) {
        self.title = title
        self.description = description
        self.identifier = identifier
    }
}

class StoreConfigViewController: UIViewController {

    @IBOutlet weak var configTableView: UITableView!

    var configItems: [StoreConfig]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // init config items
        configItems = [
            StoreConfig(title: "關於書店", description: "描述一下您書店的特色", identifier: "StoreDescription"),
            StoreConfig(title: "面交地點", description: "請選擇您方便面交的捷運站", identifier: "StorePosition"),
            StoreConfig(title: "選擇書櫃類別", description: "為您的書櫃分類吧", identifier: "StoreCategory"),
            StoreConfig(title: "選擇書櫃樣式", description: "為您的書籍選擇適合的書櫃吧", identifier: "StoreStyle")
        ]

        // config table view height

        if let headerVeiw = configTableView.tableHeaderView {
            headerVeiw.frame.size.height = 200
        }

        configTableView.registerNib(UINib(nibName: "StoreConfigTableViewCell", bundle: nil), forCellReuseIdentifier: "StoreConfigCell")

        configTableView.rowHeight = UITableViewAutomaticDimension
        configTableView.estimatedRowHeight = 200

        if let footerVeiw = configTableView.tableFooterView {
            footerVeiw.frame.size.height = 40
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

    @IBAction func navBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension StoreConfigViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configItems?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StoreConfigCell", forIndexPath: indexPath) as! StoreConfigTableViewCell

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
