//
//  BookCaseStyleViewController.swift
//  ShaRead
//
//  Created by martin on 2016/5/4.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import PKHUD

enum BookCaseStyleTemplate: String {
    case BookCaseStyleGray = "灰色書櫃"
    case BookCaseStyleOrange = "橘色書櫃"
    case BookCaseStyleGreen = "綠色書櫃"
}

protocol BookCaseStyleDelegate: class {
    func styleSaved()
}

class BookCaseStyleViewController: UIViewController {
    
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var styleCollectionView: UICollectionView!
    @IBOutlet weak var styleFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    weak var delegate: BookCaseStyleDelegate?
    weak var book: ShaBook?

    var styleItems: [BookCaseStyleTemplate: String] = [
        .BookCaseStyleGray: "bookshelf-gray",
        .BookCaseStyleOrange: "bookshelf-orange",
        .BookCaseStyleGreen: "bookshelf-green"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // default value
        let tplArray = Array(styleItems.keys)

        styleLabel.text = tplArray[0].rawValue
        styleFlowLayout.itemSize = CGSizeMake(240, 240)

        if let template = BookCaseStyleTemplate(rawValue: book!.style),
            row = tplArray.indexOf({ $0 == template }) {

            self.backButton.hidden = tplArray[0] == template
            self.forwardButton.hidden = tplArray[tplArray.count - 1] == template
            self.styleLabel.text = template.rawValue

            dispatch_async(dispatch_get_main_queue(), {
                var frame: CGRect = self.styleCollectionView.frame
                
                frame.origin.x = frame.size.width * (CGFloat(row))
                frame.origin.y = 0

                self.styleCollectionView.scrollRectToVisible(frame, animated: false)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(sender: AnyObject) {

        let tplArray = Array(styleItems.keys)

        if let indexPath = getCurrentIndexPath(),
            book = self.book {

            let template = tplArray[indexPath.row]
            let originalStyle = book.style

            book.style = template.rawValue

            HUD.show(.Progress)
            ShaManager.sharedInstance.updateAdminBook(book, column: [.ShaBookStyle],
                success: {
                    HUD.hide()
                    self.delegate?.styleSaved()
                    self.navigationController?.popViewControllerAnimated(true)
                },
                failure: {
                    self.book?.style = originalStyle
                    HUD.flash(.Error)
                }
            )
        }
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

extension BookCaseStyleViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return styleItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("StyleCell", forIndexPath: indexPath) as! BookCaseStyleCollectionViewCell
        let tplArray = Array(styleItems.keys)
        let template = tplArray[indexPath.row]

        if let imageName = styleItems[template] {

            cell.styleImageView.image = nil
            cell.styleImageView.image = UIImage(named: imageName)
        }

        return cell
    }
    
    func getCurrentIndexPath() -> NSIndexPath? {

        var indexPath: NSIndexPath? = nil

        for cell in styleCollectionView.visibleCells() {
            indexPath = styleCollectionView.indexPathForCell(cell)
        }
        
        return indexPath
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {

        dispatch_async(dispatch_get_main_queue(), {

            if let indexPath = self.getCurrentIndexPath() {
                let tplArray = Array(self.styleItems.keys)
                let template = tplArray[indexPath.row]
                
                self.backButton.hidden = (indexPath.row == 0)
                self.forwardButton.hidden = (indexPath.row == self.styleItems.count - 1)
                self.styleLabel.text = template.rawValue
            }
        })

    }
}