//
//  StoreStyleViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/25.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import PKHUD

protocol StoreStyleDelegate: class {
    func styleSaved()
}

enum StoreStyleTemplate: Int {
    case StoreStyleTemplateDefault = 1
}

class StoreStyleViewController: UIViewController {

    @IBOutlet weak var styleCollectionView: UICollectionView!
    @IBOutlet weak var styleFlowLayout: UICollectionViewFlowLayout!

    weak var delegate: StoreStyleDelegate?
    weak var shelf: ShaAdminShelf?
    var template: StoreStyleTemplate = .StoreStyleTemplateDefault

    var styleItems: [StoreStyleTemplate: String] = [
        .StoreStyleTemplateDefault: "ShelfCollectionViewCell"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        if let shelf = self.shelf, template = StoreStyleTemplate(rawValue: shelf.style) {
            self.template = template
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func save(sender: AnyObject) {
        
        if let shelf = self.shelf {
            let originalStyle = shelf.style
            
            self.shelf?.style = self.template.rawValue
            
            HUD.show(.Progress)
            ShaManager.sharedInstance.updateAdminStoreShelf(shelf,
                success: {
                    HUD.hide()
                    self.delegate?.styleSaved()
                    self.navigationController?.popViewControllerAnimated(true)
                },
                failure: {
                    self.shelf?.style = originalStyle
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

extension StoreStyleViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return styleItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("StyleCell", forIndexPath: indexPath) as! StyleCollectionViewCell

        if let template = StoreStyleTemplate(rawValue: indexPath.row + 1), nibName = styleItems[template] {
            cell.registerNib(nibName)
        }

        return cell
    }
}
