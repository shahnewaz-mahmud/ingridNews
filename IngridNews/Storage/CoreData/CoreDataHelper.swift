//
//  CoreDataHelper.swift
//  IngridNews
//
//  Created by BJIT on 1/13/23.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static let shared = CoreDataHelper()

    
    func addNews(news: News, catagory: String){
        
        let newNews = NewsModel(context: context)
        
        newNews.newsId = news.url
        newNews.title = news.title
        newNews.author = news.author
        newNews.newsDescription = news.description
        newNews.url = news.url
        newNews.urlToImage = news.urlToImage
        newNews.publishedAt = news.publishedAt
        newNews.content = news.content
        newNews.catagoryName = catagory

        do {
            try context.save()
        } catch {
            print(error)
        }
       
    }
    
    
    func getAllNews(catagory: String) {
        let fetchRequest = NSFetchRequest<NewsModel>(entityName: "NewsModel")
        let format = "catagoryName = %@"
        let predicate = NSPredicate(format: format,catagory)
        fetchRequest.predicate = predicate
        
        do {
            NewsModel.newsList = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
}
