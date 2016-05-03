//
//  BookCategoryViewController.swift
//  ShaRead
//
//  Created by martin on 2016/5/3.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

protocol BookCategoryDelegate: class {
    func categorySaved()
}

class BookCategoryViewController: UIViewController {

    @IBOutlet weak var categoryTableView: UITableView!

    weak var delegate: BookCategoryDelegate?
    weak var book: ShaBook?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categoryTableView.rowHeight = UITableViewAutomaticDimension
        categoryTableView.estimatedRowHeight = 300
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

extension BookCategoryViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier = ""
        
        switch indexPath.row {
        case 0:
            identifier = "BookCategoryCell"
        case 1:
            identifier = "BookCustomCategoryCell"
        case 2:
            identifier = "BookCaseStyleCell"
        default:
            identifier = "BookCaseStyleCell"
            break
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)

        return cell
    }
}
