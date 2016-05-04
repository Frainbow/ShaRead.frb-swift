//
//  StoreNameViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/24.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import PKHUD

class StoreNameViewController: UIViewController {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var inputLengthLabel: UILabel!

    let maxInputLength: Int = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stores = ShaManager.sharedInstance.adminStores
        
        if stores.count == 0 {
            self.navigationItem.leftBarButtonItems?.removeAll()
            self.navigationItem.setHidesBackButton(true, animated: false)
        }
        else {
            inputTextField.text = stores[0].name
        }

        inputTextField.becomeFirstResponder()
        inputLengthLabel.text = "(\(inputTextField.text?.characters.count ?? 0) / \(maxInputLength))"
    }
    
    override func viewDidAppear(animated: Bool) {
        setTabBarVisible(true, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        setTabBarVisible(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction

    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }

    @IBAction func endOnExit(sender: AnyObject) {
        self.resignFirstResponder()
        
        let instance = ShaManager.sharedInstance

        if inputTextField.text?.characters.count > 0 {
            
            if instance.adminStores.count == 0 {
                let store = ShaAdminStore()

                store.name = inputTextField.text ?? ""

                HUD.show(.Progress)
                instance.newAdminStore(store,
                    success: {
                        HUD.hide()
                        // Go to next step
                        self.performSegueWithIdentifier("ShowStoreConfig", sender: sender)
                    },
                    failure: {
                        HUD.flash(.Error)
                    }
                )
            } else {
                let store = instance.adminStores[0]
                let originName = store.name

                store.name = inputTextField.text ?? ""

                HUD.show(.Progress)
                instance.updateAdminStore(store, column: [.ShaAdminStoreName],
                    success: {
                        HUD.hide()
                        // Go to next step
                        self.performSegueWithIdentifier("ShowStoreConfig", sender: sender)
                    },
                    failure: {
                        HUD.flash(.Error)
                        // Recover value
                        store.description = originName
                    }
                )
            }
            
            return
        }
        
        // Error handling
        let controller = UIAlertController(title: "錯誤", message: "請輸入您的店名", preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "確定", style: .Default, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
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
    
    // MARK: - TabBar
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animateWithDuration(duration) {
                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, offsetY!)
                return
            }
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

    @IBAction func navBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
