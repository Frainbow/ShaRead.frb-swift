//
//  StoreCategoryViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/25.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import PKHUD

protocol StoreCategoryDelegate: class {
    func categorySaved()
}

enum StoreCategoryTemplate: Int {
    case StoreCategoryTemplateDefault = 1
    case StoreCategoryTemplateCustom
}

class StoreCategoryViewController: UIViewController {

    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var customTextField: UITextField!
    @IBOutlet weak var inputLengthLabel: UILabel!
    @IBOutlet weak var customContainerView: UIView!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var categoryPickerView: UIPickerView!

    weak var delegate: StoreCategoryDelegate?
    weak var shelf: ShaAdminShelf?
    var template: StoreCategoryTemplate = .StoreCategoryTemplateDefault {

        didSet {
            customContainerView.hidden = (template != .StoreCategoryTemplateCustom)
        }
    }
    
    var categoryItems: [StoreCategoryTemplate: String] = [
        .StoreCategoryTemplateDefault: "不分類",
        .StoreCategoryTemplateCustom: "自訂"
    ]
    
    let maxInputLength: Int = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let category = shelf?.category {
            
            if category.characters.count > 0 {
                
                self.template = .StoreCategoryTemplateCustom
                self.customTextField.text = category
                
                for (template, templateString) in categoryItems {

                    if category == templateString && template != .StoreCategoryTemplateCustom {
                        self.template = template
                        self.customTextField.text = ""
                        break
                    }
                }
            }
        }

        inputLengthLabel.text = "(\(self.customTextField.text?.characters.count ?? 0) / \(maxInputLength))"

        if let headerView = categoryTableView.tableHeaderView {
            headerView.frame.size.height = 0
        }
        
        categoryTableView.rowHeight = UITableViewAutomaticDimension
        categoryTableView.estimatedRowHeight = 20
        
        if let footerView = categoryTableView.tableFooterView {
            footerView.frame.size.height = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func save(sender: AnyObject) {

        if let shelf = self.shelf {
            let originalCategory = shelf.category

            if self.template != .StoreCategoryTemplateCustom {
                // Default category
                shelf.category = categoryItems[self.template]!
            } else {
                // Custom category
                if self.customTextField.text?.characters.count > 0 {
                    shelf.category = self.customTextField.text!
                } else {
                    let controller = UIAlertController(title: "錯誤", message: "請輸入類別名稱", preferredStyle: .Alert)
                    controller.addAction(UIAlertAction(title: "確定", style: .Default, handler: nil))
                    presentViewController(controller, animated: true, completion: nil)
                    return
                }
            }

            HUD.show(.Progress)
            ShaManager.sharedInstance.updateAdminStoreShelf(shelf,
                success: {
                    HUD.hide()
                    self.delegate?.categorySaved()
                    self.navigationController?.popViewControllerAnimated(true)
                },
                failure: {
                    self.shelf?.category = originalCategory
                    HUD.flash(.Error)
                }
            )
        }
    }

    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }

    @IBAction func endOnExit(sender: AnyObject) {
        self.resignFirstResponder()
    }

    @IBAction func inputEditingChanged(sender: AnyObject) {

        if let textField = sender as? UITextField, text = textField.text {
            let length = text.characters.count
            
            if length <= maxInputLength {
                inputLengthLabel.text = "(\(length) / \(maxInputLength))"
            } else {
                textField.text = String(text.characters.dropLast())
            }
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

extension StoreCategoryViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)

        if let categoryCell = cell as? StoreCategoryTableViewCell {
            categoryCell.categoryLabel.text = categoryItems[template]
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        pickerContainerView.hidden = false
    }
}

extension StoreCategoryViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryItems.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let template = StoreCategoryTemplate(rawValue: row + 1) {
            return categoryItems[template]
        }

        return nil
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if let template = StoreCategoryTemplate(rawValue: row + 1) {
            self.template = template
            self.categoryTableView.reloadData()
        }

        pickerContainerView.hidden = true
    }
}

