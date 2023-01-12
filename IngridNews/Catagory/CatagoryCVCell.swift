//
//  CatagoryCVCell.swift
//  IngridNews
//
//  Created by BJIT on 1/12/23.
//

import UIKit

class CatagoryCVCell: UICollectionViewCell {

    @IBOutlet weak var iconBackground: UIView!
    @IBOutlet weak var catagoryTitle: UILabel!
    @IBOutlet weak var catagoryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconBackground.layer.cornerRadius = 30
        // Initialization code
    }

}
