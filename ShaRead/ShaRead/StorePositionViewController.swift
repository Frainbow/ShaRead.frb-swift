//
//  StorePositionViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/25.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import PKHUD

protocol StorePositionDelegate: class {
    func positionSaved()
}

class StorePositionViewController: UIViewController {

    @IBOutlet weak var positionTableView: UITableView!
    @IBOutlet weak var inputLengthLabel: UILabel!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var positionPickerView: UIPickerView!
    @IBOutlet weak var exitPickerView: UIPickerView!

    weak var delegate: StorePositionDelegate?
    weak var store: ShaAdminStore?
    var station: MRTStation?
    var selectedStation: String?
    var selectedExit: MRTStationExit?

    let maxInputLength: Int = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        initMRTStation()
        inputLengthLabel.text = "(0 / \(maxInputLength))"

        if let headerView = positionTableView.tableHeaderView {
            headerView.frame.size.height = 0
        }
        
        positionTableView.rowHeight = UITableViewAutomaticDimension
        positionTableView.estimatedRowHeight = 20
        
        if let footerView = positionTableView.tableFooterView {
            footerView.frame.size.height = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    func initMRTStation() {
        HUD.show(.Progress)
        ShaManager.sharedInstance.getMRTStation(
            { station in
                dispatch_async(dispatch_get_main_queue(), {
                    self.station = station
                    self.positionPickerView.reloadAllComponents()
                    
                    for (name, exitList) in station.station {
                        for exitItem in exitList {
                            if self.store?.position.address == "\(name)\(exitItem.name)"{
                                self.selectedStation = name
                                self.selectedExit = exitItem
                                self.positionTableView.reloadData()
                                HUD.hide()
                                return
                            }
                        }
                    }

                    HUD.hide()
                })
            },
            failure: {
                HUD.flash(.Error)
            }
        )
    }

    @IBAction func save(sender: AnyObject) {
        if let station = selectedStation, exit = selectedExit, store = self.store {

            let originAddress = store.position.address
            let originLongitude = store.position.longitude
            let originLatitude = store.position.latitude
            
            store.position.address = "\(station)\(exit.name)"
            store.position.longitude = exit.longitude
            store.position.latitude = exit.latitude
            
            HUD.show(.Progress)
            ShaManager.sharedInstance.updateAdminStore(store, column: [.ShaAdminStorePosition],
                success: {
                    HUD.hide()
                    self.delegate?.positionSaved()
                    self.navigationController?.popViewControllerAnimated(true)
                },
                failure: {
                    HUD.flash(.Error)
                    store.position.address = originAddress
                    store.position.longitude = originLongitude
                    store.position.latitude = originLatitude
                }
            )
        }
        else {
            let controller = UIAlertController(title: "錯誤", message: "請選擇地點", preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "確定", style: .Default, handler: nil))
            presentViewController(controller, animated: true, completion: nil)
        }
    }

    @IBAction func endOnExit(sender: AnyObject) {
        self.resignFirstResponder()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func navBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension StorePositionViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(indexPath.row == 0 ? "MRTCell" : "ExitCell", forIndexPath: indexPath)
        
        if indexPath.row == 0 {
            if let station = selectedStation {
                if station.characters.count > 0 {
                    (cell as! StorePositionTableViewCell).positionLabel?.text = station
                    return cell
                }
            }
            
            (cell as! StorePositionTableViewCell).positionLabel?.text = "選擇捷運站"
        }
        
        if indexPath.row == 1 {
            if let exit = selectedExit {
                (cell as! StoreExitPositionTableViewCell).positionLabel?.text = exit.name
                return cell
            }
            
            (cell as! StoreExitPositionTableViewCell).positionLabel?.text = "幾號出口"
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        pickerContainerView.hidden = false
        positionPickerView.reloadAllComponents()
    }
}

extension StorePositionViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if let station = self.station {
            
            if pickerView.tag == 0 {
                return station.station.count
            }

            if let s = selectedStation, exit = station.station[s] {
                return exit.count
            }
        }

        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let station = self.station {

            if pickerView.tag == 0 {
                let arr = Array(station.station.keys)
                return arr[row]
            }

            if let s = selectedStation, exit = station.station[s] {
                return exit[row].name
            }
        }

        return nil
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if let station = self.station {

            if pickerView.tag == 0 {
                let arr = Array(station.station.keys)
                selectedStation = arr[row]
                selectedExit = nil
                exitPickerView.reloadAllComponents()
            } else if let s = selectedStation, exit = station.station[s] {
                selectedExit = exit[row]
                pickerContainerView.hidden = true
                positionTableView.reloadData()
            }
        }
    }

}
