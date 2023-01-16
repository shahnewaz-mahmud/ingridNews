//
//  BookmarkedNewsVC.swift
//  IngridNews
//
//  Created by Shahnewaz on 15/1/23.
//

import UIKit
import SDWebImage

class BookmarkedNewsVC: UIViewController {
   
   var selectedIndex = 0
    
    @IBOutlet weak var headerViewBackground: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tabBarBackground: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderSection()
        
        CoreDataHelper.shared.getAllSavedNews()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let bookmarkedNewsNib = UINib(nibName: Constants.bookmarkedNewsTVCellId, bundle: nil)
        tableView.register(bookmarkedNewsNib, forCellReuseIdentifier: Constants.bookmarkedNewsTVCellId)
        
        searchField.addTarget(self, action: #selector(searchNews), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshBookmarkList), name: Constants.refreshBookmarkListNotificationName, object: nil)
        
        

        

    }
    
    @objc func refreshBookmarkList() {
        tableView.reloadSections([0], with: .fade)
    }
    
    func configureHeaderSection(){
        
        headerViewBackground.clipsToBounds = true
        headerViewBackground.layer.cornerRadius = 25
        headerViewBackground.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        headerViewBackground.dropShadow()
        searchField.padding = 30
        tabBarBackground.layer.cornerRadius = 25
    
    }
    
    @objc func searchNews()
    {
        if let searchText = searchField.text {
            if searchText == ""{
                CoreDataHelper.shared.getAllSavedNews()
                refreshBookmarkList()
            } else {
                CoreDataHelper.shared.searchSavedNews(searchText: searchText)
                refreshBookmarkList()
            }
            
        }
    }


}

extension BookmarkedNewsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SavedNewsModel.savedNewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let bookmarkedNewsCell = tableView.dequeueReusableCell(withIdentifier: Constants.bookmarkedNewsTVCellId, for: indexPath) as! BookmarkedNewsTVCell
        
        bookmarkedNewsCell.newsTitle.text = SavedNewsModel.savedNewsList[indexPath.row].title
        bookmarkedNewsCell.newsDescription.text = SavedNewsModel.savedNewsList[indexPath.row].newsDescription ?? ""
        bookmarkedNewsCell.newsAuthor.text = SavedNewsModel.savedNewsList[indexPath.row].author
        let time = Shared().getReadableDataTime(data: SavedNewsModel.savedNewsList[indexPath.row].publishedAt ?? "")
        bookmarkedNewsCell.newsTime.text = time.0
        bookmarkedNewsCell.newsImage.sd_setImage(with: URL(string: SavedNewsModel.savedNewsList[indexPath.row].urlToImage ?? ""), placeholderImage: UIImage(named: "placeHolder"))

        return bookmarkedNewsCell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteTaskAction = UIContextualAction(style: .destructive, title: nil) {
            [weak self] _,_,_ in
            
            guard let self = self else {return}
            self.handleBookmarkDeleteAction(indexPath: indexPath)
            
        }
        
        deleteTaskAction.image = UIImage(systemName: "trash")
        deleteTaskAction.backgroundColor = .systemRed
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteTaskAction])
        
        return swipeAction
    }
    
    //Function for delete a Bookmark item
    func handleBookmarkDeleteAction(indexPath: IndexPath){
        CoreDataHelper.shared.deleteSavedNews(index: indexPath.row)
        tableView.reloadSections([0], with: .fade)
        NotificationCenter.default.post(name: Constants.refreshNewsListNotificationName, object: nil)
    }
}

extension BookmarkedNewsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.segueToNewsDetailsFromBookmarkId, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueToNewsDetailsFromBookmarkId {
            if let destination = segue.destination as? NewsDetailsVC {
                destination.newsTitleTxt = SavedNewsModel.savedNewsList[selectedIndex].title ?? ""
                let dateTime = Shared().getReadableDataTime(data: SavedNewsModel.savedNewsList[selectedIndex].publishedAt ?? "")
                destination.newsDateTxt = dateTime.0 + " " + dateTime.1
                destination.newsAuthorTxt = SavedNewsModel.savedNewsList[selectedIndex].author ?? ""
                destination.newsDescriptionTxt = SavedNewsModel.savedNewsList[selectedIndex].newsDescription ?? ""
                destination.newsContentTxt = SavedNewsModel.savedNewsList[selectedIndex].content ?? ""
                destination.imageLink = SavedNewsModel.savedNewsList[selectedIndex].urlToImage ?? ""
                destination.siteLink = SavedNewsModel.savedNewsList[selectedIndex].url ?? ""
                destination.catagoryTxt = SavedNewsModel.savedNewsList[selectedIndex].catagoryName ?? ""
                destination.isBookMarked = true
            }
        }
    }
    
    /*
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
        if offsetY > 1 {
                navigationController?.setNavigationBarHidden(true, animated: false)
                tabBarController?.tabBar.barTintColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.0)
            
            } else {
                navigationController?.setNavigationBarHidden(false, animated: false)

            }
        }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
     
     */
    
}
