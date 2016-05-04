//
//  StoreMemberViewController.swift
//  ShaRead
//
//  Created by martin on 2016/5/4.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class StoreMemberViewController: UIViewController {

    @IBOutlet weak var sideContainerView: UIView!
    
    var previousTab: Int?
    var centerX: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        previousTab = self.tabBarController?.selectedIndex
        centerX = sideContainerView.center.x
        sideContainerView.center.x += sideContainerView.frame.width
    }
    
    override func viewWillDisappear(animated: Bool) {
//        setTabBarVisible(false, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
//        setTabBarVisible(true, animated: false)
        
        UIView.animateWithDuration(0.3, animations: {
            self.sideContainerView.center.x = self.centerX!
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeMode(sender: AnyObject) {
        (UIApplication.sharedApplication().delegate as! AppDelegate).toggleAdminMode()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func navPreviousTab(sender: AnyObject) {
        
        if let index = previousTab {
            self.tabBarController?.selectedIndex = index
        }
    }

}
