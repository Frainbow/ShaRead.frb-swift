//
//  StoreTableViewCell.swift
//  ShaRead
//
//  Created by martin on 2016/4/20.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class StoreTableViewCell: UITableViewCell {

    @IBOutlet weak var storeCollectionView: UICollectionView!
    @IBOutlet weak var storeFlowLayout: UICollectionViewFlowLayout!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        storeCollectionView.registerNib(UINib(nibName: "StoreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StoreCollectionViewCell")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadCollectionViewData() {
        storeCollectionView.reloadData()
    }

}
