//
//  MainTableViewCell.swift
//  ShaRead
//
//  Created by martin on 2016/4/19.
//  Copyright © 2016年 Frainbow. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var bookCollectionView: UICollectionView!
    @IBOutlet weak var bookFlowLayout: UICollectionViewFlowLayout!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        bookCollectionView.registerNib(UINib(nibName: "BookCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BookCollectionViewCell")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadCollectionViewData() {
        bookCollectionView.reloadData()
    }

}
