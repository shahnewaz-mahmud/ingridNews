//
//  NewsWebVC.swift
//  IngridNews
//
//  Created by BJIT on 1/16/23.
//

import UIKit
import WebKit

class NewsWebVC: UIViewController {
    

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var newsWebView: WKWebView!
    
    var webURL = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 25
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        headerView.dropShadow()
        
        let url = URL(string: webURL)
        
        if let url = url {
            newsWebView.load(URLRequest(url: url))
        }
        
       
        
        

    }

}
