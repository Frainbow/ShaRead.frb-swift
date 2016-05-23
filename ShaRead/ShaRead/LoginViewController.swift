//
//  LoginViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/16.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import PKHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var FBLoginButton: FBSDKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // nav bar transparent
        let bar = self.navigationController?.navigationBar
        
        bar?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        bar?.shadowImage = UIImage()
        
        // Facebook login
        
        FBLoginButton.readPermissions = ["public_profile", "email"]
        FBLoginButton.delegate = self

        dispatch_async(dispatch_get_main_queue()) { 
            let token = FBSDKAccessToken.currentAccessToken()

            if token != nil {
                self.loginFireBase(token.tokenString)
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
            let token = FBSDKAccessToken.currentAccessToken()
            
            if token != nil {
                loginFireBase(token.tokenString)
            }
        }
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {

    }

    func loginShaRead(facebook_token: String, firebase_uid: String) {

        HUD.show(.Progress)

        ShaManager.sharedInstance.login(facebook_token, firebase_uid: firebase_uid,
            success: {
                HUD.hide()
                (UIApplication.sharedApplication().delegate as! AppDelegate).toggleUserMode()
            },
            failure: {
                HUD.flash(.Error)
                FBSDKLoginManager().logOut()
            }
        )
    }

    func loginFireBase(facebook_token: String) {
        
        HUD.show(.Progress)

        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(facebook_token)
        
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in

            guard error == nil else {
                print("login firebase failed. \(error)")
                HUD.flash(.Error)
                return
            }
            
            guard let user = user else {
                print("login firebase failed. user is nil")
                HUD.flash(.Error)
                return
            }

            self.loginShaRead(facebook_token, firebase_uid: user.uid)
        }
    }
}
