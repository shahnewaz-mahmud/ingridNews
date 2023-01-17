//
//  ViewController.swift
//  IngridNews
//
//  Created by BJIT on 1/12/23.
//

import UIKit
import SDWebImage


class ViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var catagoryCollectionView: UICollectionView!
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tabBarBackground: UIView!
    @IBOutlet weak var headerViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var filterListView: UIView!
    
    var selectedIndex = 0
    var selectedCatagoryIndex = 0
    var selectedCatagory = "All"
    var deSelectedCatagoryIndex = 1
    let refreshControl = UIRefreshControl()
    var isFilterexpanded = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catagoryCollectionView.tag = 0
        newsCollectionView.tag = 1
        
        configureHeaderSection()
        configureCatagoryCell()
        configureNewsCell()
       
        
        catagoryCollectionView.dataSource = self
        catagoryCollectionView.delegate = self
        
        newsCollectionView.dataSource = self
        newsCollectionView.delegate = self
        
        fetchNews(catagory: selectedCatagory)
        
        searchField.addTarget(self, action: #selector(searchNews), for: .editingChanged)
        
        newsCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(handlePullRefresh(_:)), for: .valueChanged)
        
        autoSyncNews()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        autoSyncNews()
        filterListView.isHidden = true
        
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNewsList), name: Constants.refreshNewsListNotificationName, object: nil)
    }

    func configureHeaderSection(){
        
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 25
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        headerView.dropShadow()
        searchField.padding = 30
        tabBarBackground.layer.cornerRadius = 25
    
    }
    
    func configureCatagoryCell(){
        let catagoryCollectionCellNib = UINib(nibName: Constants.CatagoryCVCellId, bundle: nil)
        catagoryCollectionView.register(catagoryCollectionCellNib, forCellWithReuseIdentifier: Constants.CatagoryCVCellId)

        let collectionViewCellLayout = UICollectionViewFlowLayout()
        collectionViewCellLayout.itemSize = CGSize(width: 130, height: 130)
        collectionViewCellLayout.scrollDirection = .horizontal
        catagoryCollectionView.collectionViewLayout = collectionViewCellLayout
    }
    
    func configureNewsCell(){
        let newsCollectionCellNib = UINib(nibName: Constants.newsCVCellId, bundle: nil)
        newsCollectionView.register(newsCollectionCellNib, forCellWithReuseIdentifier: Constants.newsCVCellId)

        let collectionViewCellLayout = UICollectionViewFlowLayout()
        collectionViewCellLayout.itemSize = CGSize(width: 130, height: 130)
        collectionViewCellLayout.scrollDirection = .vertical
        newsCollectionView.collectionViewLayout = collectionViewCellLayout
    }
    
    @IBAction func filterBtnAction(_ sender: Any) {
        
        if isFilterexpanded == false{
            isFilterexpanded = true
            UIView.animate(withDuration: 0.5, delay: 0, animations: { [weak self] in
                self?.headerViewHeightConstant.constant = 170
                self?.view.layoutIfNeeded()
                self?.filterListView.isHidden = false
            })
        } else {
            isFilterexpanded = false
            self.filterListView.isHidden = true
            UIView.animate(withDuration: 1, delay: 0, animations: { [weak self] in
                self?.headerViewHeightConstant.constant = 90
                self?.view.layoutIfNeeded()
                
            })
        }
    }

    
    @objc func refreshNewsList(){
        DispatchQueue.main.async {
            self.newsCollectionView.performBatchUpdates({
                self.newsCollectionView.reloadSections([0])
            }, completion: nil)
            
            
        }
    }
    
    @objc func handlePullRefresh(_ refreshControl: UIRefreshControl) {
        CoreDataHelper.shared.clearOldNews(catagory: selectedCatagory)
        refreshNewsList()
        syncNews(catagory: selectedCatagory)
        refreshControl.endRefreshing()
    }
    
    func fetchNews(catagory: String) {
        CoreDataHelper.shared.getAllNews(catagory: catagory)
        self.refreshNewsList()
        if NewsModel.newsList.count == 0 {
            syncNews(catagory: catagory)
        }
    }
    
    
    func syncNews(catagory: String){
        guard let url = URL(string: API.apiDomain+"&category=\(catagory != "All" ? catagory : "" )&apiKey=\(API.apiKey)") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
            } else {
                let newsList = try! JSONDecoder().decode(NewsList.self, from: data!)
                
                if let articles = newsList.articles {
                    for i in 0...articles.count-1{
                        CoreDataHelper.shared.addNews(news: articles[i], catagory: catagory)
                    }
                }
                
                CoreDataHelper.shared.getAllNews(catagory: catagory)
                self.refreshNewsList()
            }

        }.resume()
    }
    
    func autoSyncNews(){
        let currentTime = Date()
        
        let userInfo = UserDefaultsHelper.shared.getSavedData(key: Constants.userDefaultsUser)
        
        guard var userInfo = userInfo else {
            let newUser = User(theme: "A", isDarkmode: false, lastSync: currentTime)
            UserDefaultsHelper.shared.saveData(userInfo: newUser, key: Constants.userDefaultsUser)
            return
            
        }

        let timeInterval = (currentTime - userInfo.lastSync)/60
            print("mins", timeInterval)
            
            if timeInterval > 30 {
                
                CoreDataHelper.shared.clearAllData()
                for category in Catagory.catagoryList
                {
                    syncNews(catagory: category.name!)
                }
                
                userInfo.lastSync = currentTime
                UserDefaultsHelper.shared.saveData(userInfo: userInfo, key: Constants.userDefaultsUser)
            }
    }
    
    @objc func searchNews()
    {
        if let searchText = searchField.text {
            if searchText == ""{
                CoreDataHelper.shared.getAllNews(catagory: selectedCatagory)
                refreshNewsList()
            } else {
                CoreDataHelper.shared.searchNews(catagory: selectedCatagory, searchText: searchText)
                refreshNewsList()
            }
            
        }
        
       
    }


}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView.tag {
                case 0:
                    return Catagory.catagoryList.count
                case 1:
                    print("Total News",NewsModel.newsList.count)
                    return NewsModel.newsList.count
                default:
                    return 0
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag {
            case 0:
                let catagoryCollectionViewCell = catagoryCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.CatagoryCVCellId, for: indexPath) as! CatagoryCVCell
            catagoryCollectionViewCell.catagoryTitle.text = Catagory.catagoryList[indexPath.row].name
            catagoryCollectionViewCell.catagoryImage.image = UIImage(systemName: Catagory.catagoryList[indexPath.row].img!)
            
            if indexPath.row == selectedCatagoryIndex {
                catagoryCollectionViewCell.catagoryTitle.font = UIFont.boldSystemFont(ofSize: 13.0)
                catagoryCollectionViewCell.iconBackground.backgroundColor = UIColor(hex: 0x082650)
                catagoryCollectionViewCell.catagoryImage.tintColor = .white
            } else {
                catagoryCollectionViewCell.catagoryTitle.font = UIFont.systemFont(ofSize: 13)
                catagoryCollectionViewCell.iconBackground.backgroundColor = UIColor(hex: 0xE5E5E9)
                catagoryCollectionViewCell.catagoryImage.tintColor = UIColor(hex: 0x082650)
                
            }
                return catagoryCollectionViewCell
                
            case 1:
                let newsCollectionViewCell = newsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.newsCVCellId, for: indexPath) as! NewsCVCell
            newsCollectionViewCell.addBookmarkBtn.addTarget(newsCollectionViewCell, action: #selector(newsCollectionViewCell.addBookmarkBtnAction(_:)), for: .touchUpInside)

            newsCollectionViewCell.newsTitle.text = NewsModel.newsList[indexPath.row].title
            newsCollectionViewCell.newsDescription.text = NewsModel.newsList[indexPath.row].newsDescription
            newsCollectionViewCell.newsAuthor.text = NewsModel.newsList[indexPath.row].author
            let time = Shared().getReadableDataTime(data: NewsModel.newsList[indexPath.row].publishedAt ?? "")
            newsCollectionViewCell.newsDate.text = time.0
            if(NewsModel.newsList[indexPath.row].isBookMarked == true)
            {
                newsCollectionViewCell.addBookmarkBtn.tintColor = UIColor.systemGreen
            } else {
                newsCollectionViewCell.addBookmarkBtn.tintColor = UIColor.systemGray5
            }
            
            //newsCollectionViewCell.newsImage.sd_setImage(with: URL(string: NewsModel.newsList[indexPath.row].urlToImage ?? ""))
            newsCollectionViewCell.newsImage.sd_setImage(with: URL(string: NewsModel.newsList[indexPath.row].urlToImage ?? ""), placeholderImage: UIImage(named: "placeHolder"))
                
                return newsCollectionViewCell
                
            default:
                return UICollectionViewCell()
        }

        
    }
}

extension ViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            if collectionView == catagoryCollectionView {
                
                
                
                if let selectedCell = catagoryCollectionView.cellForItem(at: indexPath) as? CatagoryCVCell {
                    selectedCell.catagoryTitle.font = UIFont.boldSystemFont(ofSize: 13.0)
                    selectedCell.iconBackground.backgroundColor = UIColor(hex: 0x082650)
                    selectedCell.catagoryImage.tintColor = .white
                    
                    selectedCatagory = Catagory.catagoryList[indexPath.row].name!
                    deSelectedCatagoryIndex = selectedCatagoryIndex
                    selectedCatagoryIndex = indexPath.row
                    
                    fetchNews(catagory: selectedCatagory)
                }
                
                let deselectedIndexPath = IndexPath(item: deSelectedCatagoryIndex, section: 0)
                
                if let deselectedCell = catagoryCollectionView.cellForItem(at: deselectedIndexPath) as? CatagoryCVCell {
                    deselectedCell.catagoryTitle.font = UIFont.systemFont(ofSize: 13)
                    deselectedCell.iconBackground.backgroundColor = UIColor(hex: 0xE5E5E9)
                    deselectedCell.catagoryImage.tintColor = UIColor(hex: 0x082650)
                }
                
                
                
            } else {
                    selectedIndex = indexPath.row
                    performSegue(withIdentifier: Constants.segueToNewsDetailsId, sender: nil)
            }
        }
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.segueToNewsDetailsId{
            if let destination = segue.destination as? NewsDetailsVC {
                destination.newsTitleTxt = NewsModel.newsList[selectedIndex].title ?? ""
                let dateTime = Shared().getReadableDataTime(data: NewsModel.newsList[selectedIndex].publishedAt ?? "")
                destination.newsDateTxt = dateTime.0 + " " + dateTime.1
                destination.newsAuthorTxt = NewsModel.newsList[selectedIndex].author ?? ""
                destination.newsDescriptionTxt = NewsModel.newsList[selectedIndex].newsDescription ?? ""
                destination.newsContentTxt = NewsModel.newsList[selectedIndex].content ?? ""
                destination.imageLink = NewsModel.newsList[selectedIndex].urlToImage ?? ""
                destination.siteLink = NewsModel.newsList[selectedIndex].url ?? ""
                destination.isBookMarked = NewsModel.newsList[selectedIndex].isBookMarked
                destination.catagoryTxt = NewsModel.newsList[selectedIndex].catagoryName ?? ""
                destination.newsIndex = selectedIndex
                destination.webURL = NewsModel.newsList[selectedIndex].url ?? ""
            }
        }
    }
    
}


extension ViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
                case 0:
                    return CGSize(width: 130, height: 130)
                case 1:
                    return CGSize(width: 400, height: 200)
                default:
                    return CGSize(width: 130, height: 130)
            }
        
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
