//
//  BookPhotoViewController.swift
//  ShaRead
//
//  Created by martin on 2016/4/26.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class BookPhotoViewController: UIViewController {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var photoFlowLayout: UICollectionViewFlowLayout!

    weak var book: ShaBook?

    var photo: [String] = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let rowItemCount: CGFloat = 3
        let itemWidth: CGFloat = (screenWidth - 10 * (rowItemCount + 1)) / rowItemCount

        photoFlowLayout.itemSize = CGSizeMake(itemWidth, itemWidth / 3 * 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return photo.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.row < photo.count {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BookPhotoCell", forIndexPath: indexPath) as! BookPhotoCollectionViewCell

            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AddPhotoCell", forIndexPath: indexPath)
            
            return cell
        }
    }
}
