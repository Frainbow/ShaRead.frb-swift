//
//  MainTableViewCell.swift
//  ShaRead
//
//  Created by martin on 2016/4/19.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var mainFlowLayout: UICollectionViewFlowLayout!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        mainCollectionView.registerNib(UINib(nibName: "MainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MainCollectionViewCell")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
