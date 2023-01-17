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
        newNews.isBookMarked = false

        do {
            try context.save()
        } catch {
            print(error)
        }
       
    }
    
    func saveNews(index: Int){
        
        let newSavedNews = SavedNewsModel(context: context)
        
        newSavedNews.newsId = NewsModel.newsList[index].url
        newSavedNews.title = NewsModel.newsList[index].title
        newSavedNews.author = NewsModel.newsList[index].author
        newSavedNews.newsDescription = NewsModel.newsList[index].newsDescription
        newSavedNews.url = NewsModel.newsList[index].url
        newSavedNews.urlToImage = NewsModel.newsList[index].urlToImage
        newSavedNews.publishedAt = NewsModel.newsList[index].publishedAt
        newSavedNews.content = NewsModel.newsList[index].content
        newSavedNews.catagoryName = NewsModel.newsList[index].catagoryName

        do {
            try context.save()
            getAllSavedNews()
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
            updateBookmarkInfo()
            
        } catch {
            print(error)
        }
    }
    
    func updateBookmarkInfo(){
        for savedNews in SavedNewsModel.savedNewsList{
            for news in NewsModel.newsList {
                if savedNews.newsId == news.newsId {
                    news.isBookMarked = true
                }
            }
        }
    }
    
    func getAllSavedNews() {
        let fetchRequest = NSFetchRequest<SavedNewsModel>(entityName: "SavedNewsModel")
        do {
            SavedNewsModel.savedNewsList = try context.fetch(fetchRequest)
            SavedNewsModel.savedNewsList.reverse()
            NotificationCenter.default.post(name: Constants.refreshBookmarkListNotificationName, object: nil)
        } catch {
            print(error)
        }
    }
    
    func getNewsWithId(id: String) -> [NewsModel]
    {
        //var news = [NewsModel(context: context)]
        let fetchRequest = NSFetchRequest<NewsModel>(entityName: "NewsModel")
        let format = "newsId = %@"
        let predicate = NSPredicate(format: format,id)
        fetchRequest.predicate = predicate
        
        do {
            let news = try context.fetch(fetchRequest)
            return news
        } catch {
            print(error)
            return [NewsModel]()
        }

    }
    
    
    func searchNews(catagory: String, searchText: String) {
        let fetchRequest = NSFetchRequest<NewsModel>(entityName: "NewsModel")
        let format = "catagoryName = %@ && title CONTAINS[c] %@"
        let predicate = NSPredicate(format: format,catagory,searchText)
        fetchRequest.predicate = predicate
        
        do {
            NewsModel.newsList = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
    
    func searchSavedNews(searchText: String) {
        let fetchRequest = NSFetchRequest<SavedNewsModel>(entityName: "SavedNewsModel")
        let format = "title CONTAINS [c] %@"
        let predicate = NSPredicate(format: format,searchText)
        fetchRequest.predicate = predicate
        
        do {
            SavedNewsModel.savedNewsList = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
    
    
    func deleteSavedNews(index: Int) {
        let item = SavedNewsModel.savedNewsList[index]
        let news = getNewsWithId(id: item.newsId ?? "")
        if news.count > 0 {
            news[0].isBookMarked = false
        }
        context.delete(item)
        do {
            try context.save()
            SavedNewsModel.savedNewsList.remove(at: index)
        } catch {
            print("Delete Error: ", error)
        }
    }
    
    func clearOldNews(catagory: String)
    {
        let fetchRequest = NSFetchRequest<NewsModel>(entityName: "NewsModel")
        let format = "catagoryName = %@"
        let predicate = NSPredicate(format: format,catagory)
        fetchRequest.predicate = predicate
        
        do {
            let newsList = try context.fetch(fetchRequest)
            for news in newsList {
                context.delete(news)
            }
        } catch let error as NSError {
            print("Delete Error: ", error)
        }
        
        do {
            try context.save()
        } catch {
            print("Delete Error: ", error)
        }
        
        getAllNews(catagory: catagory)

    }
    
    func clearAllData(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsModel")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)
        } catch let error as NSError {
            print("Error while deleting all data from Core Data: \(error)")
        }
    }
}
