//
//  MailViewController.swift
//  ShaRead
//
//  Created by martin on 2016/5/4.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import Firebase

class MailViewController: UIViewController {

    @IBOutlet weak var userTableView: UITableView!
    
    var users: [ShaUser] = []
    var uid: String?
    var authHandler: FIRAuthStateDidChangeListenerHandle?
    
    deinit {
        if let authHandler = authHandler {
            FIRAuth.auth()?.removeAuthStateDidChangeListener(authHandler)
            self.uid = nil
        }
    }

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

        self.authHandler = FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.uid = user.uid
                self.getRoomList()
            }
            else {
                // redirect to login page
                self.uid = nil
            }
        })
    }
    
    func getRoomList() {

        guard let currentUID = self.uid else {
            return
        }

        let rootRef = FIRDatabase.database().reference()

        rootRef
        .child("rooms")
        .queryOrderedByChild("uid")
        .queryEqualToValue("\(currentUID)")
        .observeEventType(.ChildAdded, withBlock: { snapshot in
            
            let instance = ShaManager.sharedInstance
            let dic = snapshot.value as! NSDictionary
            let key = dic["key"] as! String
            let uid = key.componentsSeparatedByString(" - ")[0]
            
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

extension MailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count > 0 ? users.count : 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as! MailTableViewCell
        
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

        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MessageController") as? MessageTableViewController {

            controller.isAdmin = false
            controller.targetUser = users[indexPath.row]

            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
