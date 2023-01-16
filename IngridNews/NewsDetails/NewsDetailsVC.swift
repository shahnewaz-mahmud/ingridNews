//
//  NewsDetailsVC.swift
//  IngridNews
//
//  Created by Shahnewaz on 14/1/23.
//

import UIKit
import SDWebImage

class NewsDetailsVC: UIViewController {
    
    @IBOutlet weak var catagoryBoxBackground: UIView!
    @IBOutlet weak var newsAreaBackground: UIView!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsAuthor: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var newsContent: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var newsCatagory: UILabel!
    
    @IBOutlet weak var addBookmarkBtn: UIButton!
    
    var newsTitleTxt = ""
    var newsDateTxt = ""
    var newsAuthorTxt = ""
    var newsDescriptionTxt = ""
    var newsContentTxt = ""
    var imageLink = ""
    var siteLink = ""
    var isBookMarked = false
    var catagoryTxt = ""
    var newsIndex = 0
    var webURL = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsAreaBackground.layer.cornerRadius = 40
        scrollView.layer.cornerRadius = 40
        catagoryBoxBackground.layer.cornerRadius = 15
        
        newsTitle.text = newsTitleTxt
        newsDate.text = newsDateTxt
        newsAuthor.text = newsAuthorTxt
        newsDescription.text = newsDescriptionTxt
        newsContent.text = newsContentTxt
        newsImage.sd_setImage(with: URL(string: imageLink), placeholderImage: UIImage(named: "placeHolder"))
        newsCatagory.text = catagoryTxt
        
        if isBookMarked == true {
            addBookmarkBtn.tintColor = UIColor.systemGreen
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueToNewsWebId {
            if let destination = segue.destination as? NewsWebVC {
                destination.webURL = webURL
            }
        }
    }
    
    
    @IBAction func addBookmarkAction(_ sender: Any) {
        if isBookMarked == false {
            NewsModel.newsList[newsIndex].isBookMarked = true
            CoreDataHelper.shared.saveNews(index: newsIndex)
            addBookmarkBtn.tintColor = UIColor.systemGreen
            NotificationCenter.default.post(name: Constants.refreshNewsListNotificationName, object: nil)
        }
        
    }
    
    
    @IBAction func continueReadingBtnAction(_ sender: Any) {
        performSegue(withIdentifier: Constants.segueToNewsWebId, sender: nil)
    }
    
    
    

}
