//
//  MailAdminViewController.swift
//  ShaRead
//
//  Created by martin on 2016/5/14.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import Firebase

class MailAdminViewController: UIViewController {
    
    @IBOutlet weak var userTableView: UITableView!

    var users: [ShaUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initFirebase()
    }
    
    override func viewWillAppear(animated: Bool) {
        // deselect row on appear
        if let indexPath = userTableView.indexPathForSelectedRow {
            userTableView.deselectRowAtIndexPath(indexPath, animated: false)
        }
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
    
    // MARK: - Custom method
    func initFirebase() {
        getRoomList()
    }
    
    func getRoomList() {
        
        let rootRef = Firebase(url: ShaManager.sharedInstance.firebaseUrl)
        
        rootRef
        .childByAppendingPath("rooms")
        .queryOrderedByChild("admin-uid")
        .queryEqualToValue("\(rootRef.authData.uid)")
        .observeEventType(.ChildAdded, withBlock: { snapshot in

            let instance = ShaManager.sharedInstance
            let dic = snapshot.value as! NSDictionary
            let key = dic["key"] as! String
            let uid = key.componentsSeparatedByString(" - ")[1]

            if instance.users[uid] == nil {

                instance.getUserByUid(uid,
                    success: {
                        self.users.append(instance.users[uid]!)
                        self.userTableView.reloadData()
                    },
                    failure: {

                    }
                )
            }
            else {
                self.users.append(instance.users[uid]!)
                self.userTableView.reloadData()
            }
        })
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

}

extension MailAdminViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count > 0 ? users.count : 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as! MailAdminTableViewCell
        
        if users.count == 0 {
            cell.nameLabel.text = "系統管理員：無信件"
            return cell
        }

        cell.avatarImageView.image = nil
        cell.nameLabel.text = users[indexPath.row].name

        if let url = NSURL(string: users[indexPath.row].avatar) {
            cell.avatarImageView.sd_setImageWithURL(url, placeholderImage: ShaDefault.defaultAvatar)
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if users.count == 0 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("MessageController") as! MessageTableViewController
        
        controller.isAdmin = true
        controller.targetUser = users[indexPath.row]
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
