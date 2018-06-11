//
//  HomeViewController.swift
//  MyDogStyle
//
//  Created by Huang Edison on 6/4/18.
//  Copyright © 2018 Huang Edison. All rights reserved.
//

import UIKit

private let collectionViewCellID = "CollectionViewCell"
private let tableViewCellID      = "TableViewCell"
private let headerID = "HomeHeader"
class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    private enum CellType: String {
        case CollectionViewCell, TableViewCell
    }
    private enum NavItem {
        case left, right
    }
    private enum ButtonID: String {
        case add, history
    }
    
    @IBOutlet weak var dogContentCollectionView: UICollectionView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    private let API = MyDogAPI.shared
    private var mode: HomeContentViewMode = .collectionView
    private var imageArray = [String]()
    private var breedArray: [Breed]!
    private var dogArray = [Dog]()
    private var cellInteritemSpace: CGFloat = 1
    private var cellLineSpace: CGFloat = 1
    private var cellWidth: CGFloat {
        switch mode {
        case .collectionView:
            return (UIScreen.main.bounds.size.width - 2 * 1) / 3.0
        case .tableView:
            return UIScreen.main.bounds.size.width
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        dogContentCollectionView.delegate = self
        dogContentCollectionView.dataSource = self
        loadIndicator.startAnimating()
        
        API.getAllDogs { [unowned self] dogs in
            self.dogArray = dogs
            self.dogArray.shuffle()
            self.loadIndicator.stopAnimating()
            self.dogContentCollectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupNavigationBarItems() {
//        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Chuanqiao"
        setupNavButton(.add, side: .left)
        setupNavButton(.history, side: .right)
    }
    
    private func setupNavButton(_ id: ButtonID, side: NavItem) {
        let button = UIButton(type: .system)
        let image = UIImage(named: id.rawValue)!.resize(CGSize(width: 34, height: 34))
        button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .lightGray
        button.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentMode = .scaleAspectFit
        switch side {
        case .left:
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        case .right:
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID, for: indexPath) as! HomeCollectionReusableView
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch mode {
        case .collectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID, for: indexPath) as! HomeCollectionViewCell
            cell.imageUrl = URL(string: dogArray[indexPath.row].imageUrl)
            return cell
        case .tableView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tableViewCellID, for: indexPath) as! HomeTableCollectionViewCell
            cell.dog = dogArray[indexPath.row]
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellInteritemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellLineSpace
    }
}

extension HomeViewController: HomeMenuHeaderDelegate {
    func switchContentView(mode: HomeContentViewMode) {
        self.mode = mode
        self.dogContentCollectionView.reloadData()
    }
    
    
}
