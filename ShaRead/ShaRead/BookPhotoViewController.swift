//
//  BookPhotoViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/26.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit
import PKHUD

class BookPhotoViewController: UIViewController {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var photoFlowLayout: UICollectionViewFlowLayout!

    weak var book: ShaBook?
    let maxImage: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let rowItemCount: CGFloat = 3
        let itemWidth: CGFloat = (screenWidth - 10 * (rowItemCount + 1)) / rowItemCount

        photoFlowLayout.itemSize = CGSizeMake(itemWidth, itemWidth / 3 * 2)

        // init banner image

        bannerLabel.text = "( \(book!.images.count) / \(maxImage) )"

        if book!.images.count > 0 {
            if let url = book!.images[0].image {
                bannerImageView.sd_setImageWithURL(url)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadBanner() {
        bannerImageView.sd_setImageWithURL(book!.images[book!.images.count - 1].image)
        bannerLabel.text = "( \(book!.images.count) / \(maxImage) )"
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

extension BookPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if book!.images.count == maxImage {
            return maxImage
        }

        return book!.images.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.row < book!.images.count {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BookPhotoCell", forIndexPath: indexPath) as! BookPhotoCollectionViewCell
            
            cell.bookImageView.sd_setImageWithURL(book!.images[indexPath.row].image)

            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AddPhotoCell", forIndexPath: indexPath)
            
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        if indexPath.row < book!.images.count {
            bannerImageView.sd_setImageWithURL(book!.images[indexPath.row].image)
        }
        else {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .Camera
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
    }
}

extension BookPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let instance = ShaManager.sharedInstance
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            self.dismissViewControllerAnimated(true, completion: {
                HUD.show(.Progress)
                
                instance.uploadBookImage(
                    self.book!,
                    image: image,
                    success: {
                        dispatch_async(dispatch_get_main_queue(), {
                            HUD.hide()
                            self.reloadBanner()
                            self.photoCollectionView.reloadData()
                        })
                    },
                    failure: {
                        HUD.flash(.Error)
                    }
                )
            })
            
            return
        }
        
        // Error handling
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

