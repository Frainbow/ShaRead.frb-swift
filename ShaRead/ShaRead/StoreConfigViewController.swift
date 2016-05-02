//
//  StoreConfigViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/24.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import PKHUD
import SDWebImage

class StoreConfig {
    var saved: Bool = false
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

    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var configTableView: UITableView!
    @IBOutlet weak var adminBookContainer: UIView!

    var store: ShaAdminStore?
    var shelf: ShaAdminShelf?
    var configItems: [ShaAdminStoreItem: StoreConfig]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // init config items
        configItems = [
            .ShaAdminStoreDescription: StoreConfig(title: "關於書店", description: "描述一下您書店的特色", identifier: "StoreDescriptionConfig"),
            .ShaAdminStorePosition: StoreConfig(title: "面交地點", description: "請選擇您方便面交的捷運站", identifier: "StorePositionConfig"),
            .ShaAdminStoreCategory: StoreConfig(title: "選擇書櫃類別", description: "為您的書櫃分類吧", identifier: "StoreCategoryConfig"),
            .ShaAdminStoreStyle: StoreConfig(title: "選擇書櫃樣式", description: "為您的書籍選擇適合的書櫃吧", identifier: "StoreStyleConfig")
        ]
        
        if let url = store?.image {
            storeImageView.sd_setImageWithURL(url)
        }

        configItems![.ShaAdminStoreDescription]?.saved = store?.description.characters.count > 0
        configItems![.ShaAdminStorePosition]?.saved = store?.position.address.characters.count > 0
        checkIsFinished()

        if shelf == nil {
            initShelf()
        }

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

    @IBAction func uploadImage(sender: AnyObject) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .SavedPhotosAlbum
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func adminBooks(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    
    func initShelf() {
        
        if let store = self.store {
            
            HUD.show(.Progress)

            ShaManager.sharedInstance.getAdminStoreShelf(store,
                success: { shelfs in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        HUD.hide()

                        if shelfs.count == 0 {
                            self.newShelf()
                        }
                        else {
                            self.shelf = shelfs[0]
                            self.refreshShelf()
                        }
                    })
                },
                failure: {
                    HUD.flash(.Error)
                }
            )
        }
    }
    
    func newShelf() {
        self.shelf = ShaAdminShelf()
        
        if let store = self.store, shelf = self.shelf {

            HUD.show(.Progress)

            ShaManager.sharedInstance.newAdminStoreShelf(store, shelf: shelf,
                success: {
                    dispatch_async(dispatch_get_main_queue(), {
                        HUD.hide()
                        self.refreshShelf()
                    })
                },
                failure: {
                    self.shelf = nil
                    HUD.flash(.Error)
                }
            )
        }
    }

    func refreshShelf() {
        self.configItems![.ShaAdminStoreStyle]?.saved = self.shelf?.style > 0
        self.configItems![.ShaAdminStoreCategory]?.saved = self.shelf?.category.characters.count > 0
        self.configTableView.reloadData()
        checkIsFinished()
    }
    
    func checkIsFinished() {
        
        var finished = true
        
        if let items = self.configItems {

            for (_, item) in items {

                if !item.saved {
                    finished = false
                }
            }   
        }
        
        if store?.image == nil {
            finished = false
        }

        adminBookContainer.hidden = !finished
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

        if let item = ShaAdminStoreItem(rawValue:indexPath.row + 1), config = self.configItems?[item] {

            cell.toggleCheckMark(config.saved)
            cell.titleLabel.text = config.title
            cell.subtitleLabel.text = config.description
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if let item = ShaAdminStoreItem(rawValue:indexPath.row + 1), config = self.configItems?[item],
            controller = self.storyboard?.instantiateViewControllerWithIdentifier(config.identifier) {

            if item == .ShaAdminStoreDescription {

                if let c = controller as? StoreDescriptionViewController {
                    c.delegate = self
                    c.store = store
                }
            }
            else if item == .ShaAdminStorePosition {

                if let c = controller as? StorePositionViewController {
                    c.delegate = self
                    c.store = store
                }
            }
            else if item == .ShaAdminStoreStyle {

                if let c = controller as? StoreStyleViewController {
                    c.delegate = self
                    c.shelf = shelf
                }
            }
            else if item == .ShaAdminStoreCategory {

                if let c = controller as? StoreCategoryViewController {
                    c.delegate = self
                    c.shelf = shelf
                }
            }

            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension StoreConfigViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        if let store = self.store, image = info["UIImagePickerControllerOriginalImage"] as? UIImage {

            self.dismissViewControllerAnimated(true, completion: {
                HUD.show(.Progress)

                ShaManager.sharedInstance.uploadAdminStoreImage(
                    store,
                    image: image,
                    success: { url in
                        HUD.hide()
                        self.storeImageView.sd_setImageWithURL(url)
                    },
                    failure: {
                        HUD.flash(.Error)
                    }
                )
            })
        }
        else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

extension StoreConfigViewController: StoreDescriptionDelegate {

    func descriptionSaved() {

        if let item = configItems?[.ShaAdminStoreDescription] {
            item.saved = store?.description.characters.count > 0
            configTableView.reloadData()
            checkIsFinished()
        }
    }
}

extension StoreConfigViewController: StorePositionDelegate {
    
    func positionSaved() {

        if let item = configItems?[.ShaAdminStorePosition] {
            item.saved = store?.position.address.characters.count > 0
            configTableView.reloadData()
            checkIsFinished()
        }
    }
}

extension StoreConfigViewController: StoreStyleDelegate {

    func styleSaved() {

        if let item = configItems?[.ShaAdminStoreStyle] {
            item.saved = store?.shelfs[0].style > 0
            configTableView.reloadData()
            checkIsFinished()
        }
    }
}

extension StoreConfigViewController: StoreCategoryDelegate {

    func categorySaved() {

        if let item = configItems?[.ShaAdminStoreCategory] {
            item.saved = store?.shelfs[0].category.characters.count > 0
            configTableView.reloadData()
            checkIsFinished()
        }
    }
}
