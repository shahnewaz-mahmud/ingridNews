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
    
    @IBOutlet weak var tabBarBackground: UIView!
    
    
    
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
        
        //syncNews(catagory: "All")
        CoreDataHelper.shared.getAllNews(catagory: "All")
        
        
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
    
    func refreshNewsList(){
        
    }
    
    
    func syncNews(catagory: String){
        guard let url = URL(string: API.apiDomain) else { return }
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
            }

        }.resume()
    }


}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView.tag {
                case 0:
                    return 5
                case 1:
                    print("Total News",NewsModel.newsList.count)
                    return NewsModel.newsList.count
                        //return 5
                default:
                    return 0
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag {
            case 0:
                let catagoryCollectionViewCell = catagoryCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.CatagoryCVCellId, for: indexPath)
                return catagoryCollectionViewCell
                
            case 1:
            let newsCollectionViewCell = newsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.newsCVCellId, for: indexPath)
                return newsCollectionViewCell
                
            default:
                return UICollectionViewCell()
        }

        
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
