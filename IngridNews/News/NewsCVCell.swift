//
//  NewsCVCell.swift
//  IngridNews
//
//  Created by BJIT on 1/12/23.
//

import UIKit

class NewsCVCell: UICollectionViewCell {

    @IBOutlet weak var newsBackground: UIView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsAuthor: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    @IBOutlet weak var addBookmarkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsBackground.layer.cornerRadius = 20
        newsBackground.dropShadow()
        newsImage.layer.cornerRadius = 15
        
        
        // Initialization code
    }
    
    @IBAction func addBookmarkBtnAction(_ sender: Any) {
        guard let collectionView = self.superview as? UICollectionView else { return }
        if let indexPath = collectionView.indexPath(for: self) {
            
            if NewsModel.newsList[indexPath.row].isBookMarked == false {
                NewsModel.newsList[indexPath.row].isBookMarked = true
                CoreDataHelper.shared.saveNews(index: indexPath.row)
                addBookmarkBtn.tintColor = UIColor.systemGreen
            }
            
        }
    }
    

}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 10
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1

    }
}
