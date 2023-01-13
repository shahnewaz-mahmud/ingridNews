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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        newsBackground.layer.cornerRadius = 20
        newsBackground.dropShadow()
        newsImage.layer.cornerRadius = 15
        
        
        // Initialization code
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
