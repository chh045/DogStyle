//
//  HomeTableCollectionViewCell.swift
//  MyDogStyle
//
//  Created by Huang Edison on 6/10/18.
//  Copyright © 2018 Huang Edison. All rights reserved.
//

import UIKit

class HomeTableCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var breedNameLabel: UILabel!
    @IBOutlet weak var dogImageView: UIImageView!
    var dog: Dog! {
        didSet {
            breedNameLabel.text = dog.breed
            if let url = URL(string: dog.imageUrl) {
                dogImageView.setImageWith(url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dogImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        self.dogImageView.image = nil
    }
}
