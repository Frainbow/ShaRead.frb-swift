//
//  BookCategoryViewController.swift
//  ShaRead
//
//  Created by martin on 2016/5/3.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import PKHUD

protocol BookCategoryDelegate: class {
    func categorySaved()
}

enum BookCategoryTemplate: Int {
    case BookCategoryTemplateDefault = 1
    case BookCategoryTemplateCustom
}

class BookCategoryViewController: UIViewController {

    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var pickerContainerView: UIView!

    weak var delegate: BookCategoryDelegate?
    weak var book: ShaBook?
    
    var customCategory: String = ""
    
    var template: BookCategoryTemplate = .BookCategoryTemplateDefault {
        
        didSet {
            categoryTableView.reloadData()
        }
    }

    var categoryItems: [BookCategoryTemplate: String] = [
        .BookCategoryTemplateDefault: "不分類",
        .BookCategoryTemplateCustom: "自訂"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categoryTableView.rowHeight = UITableViewAutomaticDimension
        categoryTableView.estimatedRowHeight = 300
        
        if let category = book?.category {
            
            if category.characters.count > 0 {
                
                self.template = .BookCategoryTemplateCustom
                self.customCategory = category
                
                for (template, templateString) in categoryItems {
                    
                    if category == templateString && template != .BookCategoryTemplateCustom {
                        self.template = template
                        self.customCategory = ""
                        break
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {

        // deselect row on appear
        if let indexPath = categoryTableView.indexPathForSelectedRow {
            categoryTableView.deselectRowAtIndexPath(indexPath, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(sender: AnyObject) {

        if let book = self.book {
            let originalCategory = book.category
            
            if self.template != .BookCategoryTemplateCustom {
                // Default category
                book.category = categoryItems[self.template]!
            } else {
                // Custom category
                if customCategory.characters.count > 0 {
                    book.category = customCategory
                } else {
                    let controller = UIAlertController(title: "錯誤", message: "請輸入類別名稱", preferredStyle: .Alert)
                    controller.addAction(UIAlertAction(title: "確定", style: .Default, handler: nil))
                    presentViewController(controller, animated: true, completion: nil)
                    return
                }
            }
            
            HUD.show(.Progress)
            ShaManager.sharedInstance.updateAdminBook(book, column: [.ShaBookCategory],
                success: {
                    HUD.hide()
                    self.delegate?.categorySaved()
                    self.navigationController?.popViewControllerAnimated(true)
                },
                failure: {
                    self.book?.category = originalCategory
                    HUD.flash(.Error)
                }
            )
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let contoller = segue.destinationViewController as? BookCaseStyleViewController {
            contoller.delegate = self
            contoller.book = book
        }
    }

    @IBAction func navBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension BookCategoryViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 - ((template == .BookCategoryTemplateCustom) ? 0 : 1)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier = ""
        
        switch indexPath.row {
        case 0:
            identifier = "BookCategoryCell"
        case 1:
            identifier = (template == .BookCategoryTemplateCustom) ? "BookCustomCategoryCell" : "BookCaseStyleCell"
        case 2:
            identifier = "BookCaseStyleCell"
        default:
            identifier = "BookCaseStyleCell"
            break
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        if let c = cell as? BookCategoryTableViewCell {
            c.categoryLabel.text = categoryItems[template]
        }
        else if let c = cell as? BookCustomCategoryTableViewCell {
            c.delegate = self
            c.category = customCategory
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            pickerContainerView.hidden = false
        }
    }
}

extension BookCategoryViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryItems.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let template = BookCategoryTemplate(rawValue: row + 1) {
            return categoryItems[template]
        }
        
        return nil
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let template = BookCategoryTemplate(rawValue: row + 1) {
            self.template = template
        }
        
        pickerContainerView.hidden = true
    }
}

extension BookCategoryViewController: BookCustomCategoryDelegate {

    func customCategoryChanged(category: String) {
        customCategory = category
    }
}

extension BookCategoryViewController: BookCaseStyleDelegate {

    func styleSaved() {

    }
}
