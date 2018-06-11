//
//  HomeCollectionReusableView.swift
//  MyDogStyle
//
//  Created by Huang Edison on 6/10/18.
//  Copyright © 2018 Huang Edison. All rights reserved.
//

import UIKit

enum HomeContentViewMode {
    case collectionView, tableView
}

protocol HomeMenuHeaderDelegate: class {
    func switchContentView(mode: HomeContentViewMode)
}

class HomeCollectionReusableView: UICollectionReusableView {
    private enum ButtonId: String {
        case collect, table
    }
    private enum Color {
        static let active = UIColor(red: 29/255, green: 202/255, blue: 1, alpha: 1)
        static let idle = UIColor.lightGray
    }
    @IBOutlet weak var collectionButton: UIButton!
    @IBOutlet weak var tableButton: UIButton!
    weak var delegate: HomeMenuHeaderDelegate?
    private var buttonDict = [ButtonId: UIButton]()
    private let scaleFactor: CGFloat = 0.7
    
    @IBAction func onTapCollectionButton(_ sender: UIButton) {
        toggleSelectButton(.collect)
        delegate?.switchContentView(mode: .collectionView)
    }
    
    @IBAction func onTapTableButton(_ sender: UIButton) {
        toggleSelectButton(.table)
        delegate?.switchContentView(mode: .tableView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton(collectionButton, imageId: .collect, color: Color.active)
        setupButton(tableButton, imageId: .table, color: Color.idle)
    }
    
    private func setupButton(_ button: UIButton, imageId: ButtonId, color: UIColor) {
        let resize = CGSize(width: self.frame.size.height * scaleFactor,
                            height: self.frame.size.height * scaleFactor)
        let image = UIImage(named: imageId.rawValue)!.resize(resize).withRenderingMode(.alwaysTemplate)
        buttonDict[imageId] = button
        button.setImage(image, for: .normal)
        button.tintColor = color
        button.imageView?.contentMode = .scaleAspectFit
    }
    
    private func toggleSelectButton(_ id: ButtonId) {
        for (key, button) in buttonDict {
            if key == id {
                button.tintColor = Color.active
            } else {
                button.tintColor = Color.idle
            }
        }
    }
    
}
