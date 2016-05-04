//
//  LoginViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/16.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import PKHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var FBLoginButton: FBSDKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        FBLoginButton.readPermissions = ["public_profile", "email"]
        FBLoginButton.delegate = self

        dispatch_async(dispatch_get_main_queue()) { 
            let token = FBSDKAccessToken.currentAccessToken()

            if token != nil {
                self.login(token.tokenString)
            }
        }
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

extension LoginViewController: FBSDKLoginButtonDelegate {

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

        if !result.isCancelled {
            login(FBSDKAccessToken.currentAccessToken().tokenString)
        }
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {

    }

    func login(facebook_token: String) {

        HUD.show(.Progress)

        ShaManager.sharedInstance.login(facebook_token,
            success: {
                HUD.hide()
                (UIApplication.sharedApplication().delegate as! AppDelegate).toggleRootViewMode()
            },
            failure: {
                HUD.flash(.Error)
                FBSDKLoginManager().logOut()
            }
        )
    }
}
