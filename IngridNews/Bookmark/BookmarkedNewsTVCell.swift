//
//  BookmarkedNewsTVCell.swift
//  IngridNews
//
//  Created by Shahnewaz on 15/1/23.
//

import UIKit

class BookmarkedNewsTVCell: UITableViewCell {

    @IBOutlet weak var cellBackgroundView: UIView!
    
    @IBOutlet weak var newsImage: UIImageView!
    
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    
    @IBOutlet weak var newsTime: UILabel!
    
    @IBOutlet weak var newsAuthor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBackgroundView.layer.cornerRadius = 20
        cellBackgroundView.dropShadow()
        newsImage.layer.cornerRadius = 20

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
