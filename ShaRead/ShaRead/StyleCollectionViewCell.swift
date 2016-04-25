//
//  StyleCollectionViewCell.swift
//  ShaRead
//
//  Created by martin on 2016/4/25.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class StyleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var itemFlowLayout: UICollectionViewFlowLayout!
    
    override func awakeFromNib() {
        itemCollectionView.dataSource = self
        itemCollectionView.delegate = self
    }

    func registerNib(filename: String) {
        itemCollectionView.registerNib(UINib(nibName: filename, bundle: nil), forCellWithReuseIdentifier: "StyleItemCell")
        itemCollectionView.reloadData()
    }
}

extension StyleCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("StyleItemCell", forIndexPath: indexPath)
        
        return cell
    }
}
