//
//  MessageTableViewController.swift
//  ShaRead
//
//  Created by martin on 2016/5/10.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import Firebase

class ShaMessage {
    var send: Bool
    var message: String
    
    init(send: Bool, message: String) {
        self.send = send
        self.message = message
    }
}

class MessageTableViewController: UITableViewController {

    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet var tableFooterView: MessageFooterView!

    var messages: [ShaMessage] = []
    var uid: String?
    var authHandler: FIRAuthStateDidChangeListenerHandle?
    var roomID: String?
    var isAdmin: Bool = false

    weak var targetUser: ShaUser?
    
    deinit {
        if let authHandler = authHandler {
            FIRAuth.auth()?.removeAuthStateDidChangeListener(authHandler)
            self.uid = nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        var navHeight: CGFloat = 0
        let headerHeight: CGFloat = 0
        let footerHeight: CGFloat = 50

        // config table view height

        if let navController = self.navigationController {
            navHeight = navController.navigationBar.frame.height
        }

        if let headerView = tableView.tableHeaderView {
            headerView.frame.size.height = headerHeight
        }

        if let footerVeiw = tableView.tableFooterView {
            footerVeiw.frame.size.height = footerHeight
        }

        tableHeaderView.frame.size.width = screenWidth
        tableHeaderView.frame.size.height = headerHeight
        tableFooterView.frame.size.width = screenWidth
        tableFooterView.frame.size.height = footerHeight
        tableFooterView.delegate = self

        tableView.tableHeaderView?.addSubview(tableHeaderView)
        tableView.tableFooterView?.addSubview(tableFooterView)
        tableView.rowHeight = screenHeight - navHeight - footerHeight
        
        initFirebase()
    }
    
    override func viewWillLayoutSubviews() {
        let screenHeight: CGFloat = UIScreen.mainScreen().bounds.height
        
        if let tabBar = tabBarController?.tabBar {
            // workaround for expanding to tabbar item
            tableView.frame.size.height = screenHeight + tabBar.frame.height
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func navBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - Custom method
    func initFirebase() {

        self.authHandler = FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.uid = user.uid
                self.getRoomID()
            }
            else {
                // redirect to login page
                self.uid = nil
            }
        })
    }
    
    func getRoomID() {

        guard let currentUID = self.uid else {
            return
        }

        guard let targetUser = self.targetUser else {
            return
        }

        let rootRef = FIRDatabase.database().reference()

        let roomKey = isAdmin ? "\(currentUID) - \(targetUser.uid)" : "\(targetUser.uid) - \(currentUID)"

        rootRef
        .child("rooms")
        .queryOrderedByChild("key")
        .queryEqualToValue(roomKey)
        .observeEventType(.Value, withBlock: { snapshot in

            if snapshot.value is NSNull {
                self.createRoom()
            }
            else {
                let dic = snapshot.value as! NSDictionary
                self.roomID = (dic.allKeys as! [String])[0]
                self.observeMessage()
            }
        })
    }

    func createRoom() {

        guard let currentUID = self.uid else {
            return
        }

        guard let targetUser = self.targetUser where !isAdmin else {
            return
        }

        let rootRef = FIRDatabase.database().reference()

        rootRef
        .child("rooms")
        .childByAutoId()
        .setValue([
            "key" : "\(targetUser.uid) - \(currentUID)",
            "admin-uid": "\(targetUser.uid)",
            "uid": "\(currentUID)"
        ])
    }

    func observeMessage() {
        
        guard let roomID = self.roomID else {
            return
        }
        
        let rootRef = FIRDatabase.database().reference()

        rootRef
        .child("messages/\(roomID)")
        .queryOrderedByChild("timestamp")
        .observeEventType(.ChildAdded, withBlock: { snapshot in

            let dic = snapshot.value as! NSDictionary
            
            self.messages.append(ShaMessage(
                send: dic["admin"] as! Bool == self.isAdmin,
                message: dic["message"] as! String))

            self.tableView.reloadData()
        })
    }

    func sendMessage(message: String) {

        guard let roomID = self.roomID else {
            return
        }

        let rootRef = FIRDatabase.database().reference()

        rootRef
        .child("messages/\(roomID)")
        .childByAutoId()
        .setValue([
            "message": message,
            "timestamp": NSDate().timeIntervalSince1970 * 1000,
            "admin": isAdmin
        ])
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView.tag == 0 {
            return 1
        }

        return messages.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.tag == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Message", forIndexPath: indexPath) as! MessageTableViewCell

            if (messages.count > 0) {
                let index = NSIndexPath(forRow: messages.count - 1, inSection: 0)

                cell.messageTableView.reloadData()
                cell.messageTableView.scrollToRowAtIndexPath(index, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                
                dispatch_async(dispatch_get_main_queue(), {
                    // workaround for ios8
                    cell.messageTableView.reloadData()

                    dispatch_after(0, dispatch_get_main_queue(), {
                        cell.messageTableView.scrollToRowAtIndexPath(index, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                    })
                })
            }

            return cell
        }

        let message = messages[indexPath.row]
        
        if message.send {
            let cell = tableView.dequeueReusableCellWithIdentifier("MessageSend", forIndexPath: indexPath) as! MessageSendTableViewCell

            cell.setMessage(message.message)

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("MessageReceive", forIndexPath: indexPath) as! MessageReceiveTableViewCell

            cell.setMessage(message.message)

            return cell
        }
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension MessageTableViewController: MessageFooterDelegate {

    func textFieldFocused() {
        tableView.rowHeight -= 260
        tableView.reloadData()
    }
    
    func textFieldBlurred() {
        tableView.rowHeight += 260
        tableView.reloadData()
    }

    func submitMessage(message: String) {
        sendMessage(message.characters.count > 0 ? message : " ")
    }
}
