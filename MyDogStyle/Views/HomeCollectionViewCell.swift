//
//  HomeCollectionViewCell.swift
//  MyDogStyle
//
//  Created by Huang Edison on 6/4/18.
//  Copyright © 2018 Huang Edison. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dogImageView: UIImageView!
    var dog: Dog! {
        didSet {
            if let url = URL(string: dog.imageUrl) {
                dogImageView.setImageWith(url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        self.dogImageView.image = nil
    }
}
