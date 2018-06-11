//
//  ImageView+.swift
//  MyDogStyle
//
//  Created by Huang Edison on 6/4/18.
//  Copyright © 2018 Huang Edison. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking

extension UIImageView {
    func setImageColor(_ color: UIColor) {
        if image != nil {
            image = image!.withRenderingMode(.alwaysTemplate)
            tintColor = color
        }
        
    }
}
