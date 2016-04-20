//
//  ShelfTableViewCell.swift
//  ShaRead
//
//  Created by martin on 2016/4/19.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class ShelfTableViewCell: UITableViewCell {

    @IBOutlet weak var shelfCollectionView: UICollectionView!
    @IBOutlet weak var shelfFlowLayout: UICollectionViewFlowLayout!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        shelfCollectionView.registerNib(UINib(nibName: "ShelfCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShelfCollectionViewCell")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
