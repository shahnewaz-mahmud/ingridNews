//
//  ViewController.swift
//  IngridNews
//
//  Created by BJIT on 1/12/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var catagoryCollectionView: UICollectionView!
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderSection()
        configureCatagoryCollectionView()
        
        catagoryCollectionView.dataSource = self
        catagoryCollectionView.delegate = self
        
        newsCollectionView.dataSource = self
        newsCollectionView.delegate = self
    }
    
    func configureHeaderSection(){
        
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 25
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        searchField.padding = 30
    }
    
    func configureCatagoryCollectionView(){
        let catagoryCollectionCellNib = UINib(nibName: Constants.CatagoryCVCellId, bundle: nil)
        catagoryCollectionView.register(catagoryCollectionCellNib, forCellWithReuseIdentifier: Constants.CatagoryCVCellId)

        let collectionViewCellLayout = UICollectionViewFlowLayout()
        collectionViewCellLayout.itemSize = CGSize(width: 130, height: 130)
        collectionViewCellLayout.scrollDirection = .horizontal
        catagoryCollectionView.collectionViewLayout = collectionViewCellLayout
    }


}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let catagoryCollectionViewCell = catagoryCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.CatagoryCVCellId, for: indexPath)
        return catagoryCollectionViewCell
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let selectedCell = catagoryCollectionView.cellForItem(at: indexPath) as? CatagoryCVCell {
                selectedCell.catagoryTitle.font = UIFont.boldSystemFont(ofSize: 13.0)
                selectedCell.iconBackground.backgroundColor = UIColor(hex: 0x082650)
                selectedCell.catagoryImage.tintColor = .white
                
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            print(indexPath)
        if let selectedCell = catagoryCollectionView.cellForItem(at: indexPath) as? CatagoryCVCell {
            selectedCell.catagoryTitle.font = UIFont.systemFont(ofSize: 13)
            selectedCell.iconBackground.backgroundColor = UIColor(hex: 0xE5E5E9)
            selectedCell.catagoryImage.tintColor = UIColor(hex: 0x082650)
            
        }
    }
    
}


extension ViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 130, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}

extension UIColor {
    convenience init(hex: Int) {
        let red = (hex >> 16) & 0xff
        let green = (hex >> 8) & 0xff
        let blue = hex & 0xff
        self.init(red: CGFloat(red) / 0xff, green: CGFloat(green) / 0xff, blue: CGFloat(blue) / 0xff, alpha: 1)
    }
}

extension UITextField {
    @IBInspectable var padding: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
}
