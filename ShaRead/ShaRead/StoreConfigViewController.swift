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

    var configItems: [ShaAdminStoreItem: StoreConfig]?

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
            .ShaAdminStoreDescription: StoreConfig(title: "關於書店", description: "描述一下您書店的特色", identifier: "StoreDescriptionConfig"),
            .ShaAdminStorePosition: StoreConfig(title: "面交地點", description: "請選擇您方便面交的捷運站", identifier: "StorePositionConfig")
        ]
        
        let stores = ShaManager.sharedInstance.adminStores
        
        if stores.count != 0 {
        
            if let url = stores[0].image {
                storeImageView.sd_setImageWithURL(url, placeholderImage: ShaImage.defaultBanner)
            }

            configItems![.ShaAdminStoreDescription]?.saved = stores[0].description.characters.count > 0
            configItems![.ShaAdminStorePosition]?.saved = stores[0].position.address.characters.count > 0
            checkIsFinished()
        }

        // config table view height

        if let navController = self.navigationController {
            navHeight = navController.navigationBar.frame.height
        }

        if let headerVeiw = configTableView.tableHeaderView {
            headerHeight = 200
            headerVeiw.frame.size.height = headerHeight
        }

        configTableView.registerNib(UINib(nibName: "StoreConfigTableViewCell", bundle: nil), forCellReuseIdentifier: "StoreConfigCell")
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
    
    // MARK: - IBAction

    @IBAction func uploadImage(sender: AnyObject) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .SavedPhotosAlbum
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func adminBooks(sender: AnyObject) {
        
        if let controller = self.navigationController?.viewControllers[0] as? StoreAdminViewController {
            controller.uploadBook = true
            self.navigationController?.popToRootViewControllerAnimated(false)
        }
    }

    // MARK: - Custom method

    func checkIsFinished() {

        var finished = true

        if let items = self.configItems {

            for (_, item) in items {

                if !item.saved {
                    finished = false
                }
            }   
        }

        let stores = ShaManager.sharedInstance.adminStores

        if stores[0].image == nil {
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
                }
            }
            else if item == .ShaAdminStorePosition {

                if let c = controller as? StorePositionViewController {
                    c.delegate = self
                }
            }

            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension StoreConfigViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        let instance = ShaManager.sharedInstance
        let store = instance.adminStores[0]
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {

            self.dismissViewControllerAnimated(true, completion: {
                HUD.show(.Progress)

                instance.uploadAdminStoreImage(
                    store,
                    image: image,
                    success: { url in
                        dispatch_async(dispatch_get_main_queue(), {
                            HUD.hide()
                            store.image = url
                            self.storeImageView.sd_setImageWithURL(url, placeholderImage: ShaImage.defaultBanner)
                            self.checkIsFinished()
                        })
                    },
                    failure: {
                        HUD.flash(.Error)
                    }
                )
            })
            
            return
        }

        // Error handling
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension StoreConfigViewController: StoreDescriptionDelegate {

    func descriptionSaved() {

        if ShaManager.sharedInstance.adminStores.count > 0 {
            let store = ShaManager.sharedInstance.adminStores[0]

            if let item = configItems?[.ShaAdminStoreDescription] {
                item.saved = store.description.characters.count > 0
                configTableView.reloadData()
                checkIsFinished()
            }
        }
    }
}

extension StoreConfigViewController: StorePositionDelegate {
    
    func positionSaved() {

        if ShaManager.sharedInstance.adminStores.count > 0 {
            let store = ShaManager.sharedInstance.adminStores[0]

            if let item = configItems?[.ShaAdminStorePosition] {
                item.saved = store.position.address.characters.count > 0
                configTableView.reloadData()
                checkIsFinished()
            }
        }
    }
}
