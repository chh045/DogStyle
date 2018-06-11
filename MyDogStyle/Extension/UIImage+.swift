//
//  UIImage+.swift
//  MyDogStyle
//
//  Created by Huang Edison on 6/10/18.
//  Copyright © 2018 Huang Edison. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func resize(_ toSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(toSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: toSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
}
