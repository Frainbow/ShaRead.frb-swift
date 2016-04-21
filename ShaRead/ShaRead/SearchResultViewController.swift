//
//  SearchResultViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/20.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController {

    @IBOutlet weak var bookTableView: UITableView!
    
    var bookSectionView: BookItemView?
    var bookIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.bookTableView.rowHeight = UITableViewAutomaticDimension
        self.bookTableView.estimatedRowHeight = 200

        self.bookTableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.bookTableView.estimatedSectionHeaderHeight = 200

        self.bookTableView.registerNib(UINib(nibName: "BookItemView", bundle: nil), forCellReuseIdentifier: "BookItemCell")
        self.bookTableView.registerNib(UINib(nibName: "StoreItemView", bundle: nil), forCellReuseIdentifier: "StoreItemCell")
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

extension SearchResultViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        guard bookIndex != nil else {
            return 0
        }

        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard bookIndex != nil else {
            return nil
        }

        if bookSectionView == nil {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(SearchResultViewController.tapBookSectionView))

            bookSectionView = UINib(nibName: "BookItemView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? BookItemView
            bookSectionView?.addGestureRecognizer(gesture)
        }
        
        // TODO: set book info

        return bookSectionView
    }

    func tapBookSectionView() {
        bookIndex = nil
        bookTableView.reloadData()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if bookIndex == nil {
            let cell = tableView.dequeueReusableCellWithIdentifier("BookItemCell", forIndexPath: indexPath)

            // TODO: set book info
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("StoreItemCell", forIndexPath: indexPath)

            // TODO: set store info

            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if bookIndex == nil {
            bookIndex = indexPath.row
            tableView.reloadData()
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
