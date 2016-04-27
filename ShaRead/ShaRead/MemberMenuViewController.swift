//
//  MemberMenuViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/27.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class MemberMenuViewController: UIViewController {

    @IBOutlet weak var changeModeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeMode(sender: AnyObject) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.toggleRootViewMode()
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
