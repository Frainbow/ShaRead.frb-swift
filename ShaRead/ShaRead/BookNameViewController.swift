//
//  BookNameViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/26.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import PKHUD

class BookNameViewController: UIViewController {
    @IBOutlet weak var inputTextField: UITextField!

    var book: ShaBook?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }

    @IBAction func endOnExit(sender: AnyObject) {
        self.resignFirstResponder()
        
        newShaBook("9789864340729")
    }

    @IBAction func showScanner(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("SearchScannerController") as! ScannerViewController
        
        controller.delegate = self
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func newShaBook(code: String) {

        let instance = ShaManager.sharedInstance
        
        HUD.show(.Progress)
        instance.newAdminBook(code,
            success: {
                dispatch_async(dispatch_get_main_queue(), {
                    HUD.hide()
                    self.book = instance.adminBooks[instance.adminBooks.count - 1]

                    // Change UI Flow
                    //self.performSegueWithIdentifier("ShowBookConfig", sender: nil)

                    self.navigationController?.popViewControllerAnimated(true)
                })
            },
            failure: {
                HUD.flash(.Error)
            }
        )
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
        
        if let controller = segue.destinationViewController as? BookConfigViewController {
            controller.book = self.book
        }
    }

    @IBAction func navBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension BookNameViewController: ScannerDelegate {
    
    func captureCode(code: String) {
        self.navigationController?.popViewControllerAnimated(true)
        inputTextField.text = code
        newShaBook(code)
    }
}
