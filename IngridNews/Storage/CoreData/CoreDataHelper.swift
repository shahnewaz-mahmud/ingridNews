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

    
    /**
     Add news to the News Coredata table. it takes a news object and category name as parameter.
     First it'll check null attribute and then create a newsModel object and assign each attribute, then save the context
     it calls
     */
    func addNews(news: News, catagory: String){
        guard let id = news.url, let title = news.title, let author = news.author, let description = news.description, let url = news.url, let urlToImage = news.urlToImage, let publishedAt = news.publishedAt, let content = news.content else { return }
                
            let newNews = NewsModel(context: context)
            newNews.newsId = id
            newNews.title = title
            newNews.author = author
            newNews.newsDescription = description
            newNews.url = url
            newNews.urlToImage = urlToImage
            newNews.publishedAt = publishedAt
            newNews.content = content
            newNews.catagoryName = catagory
            newNews.isBookMarked = false
        
        do {
            try context.save()
            getAllSavedNews()
        } catch {
            print(error)
        }
    }
    
    /**
     Save news to the Bookmark/SavedNews Coredata table. it takes the index number as parameter.
     it creates an object of SavedNewsModel and assign each attribute of the news from the newsList using the indexNumber. Then save the context.
     it calls getAllSavedNews() at the last to fetch the new saved news
     */
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
    
    /**
     Get all news from coreData of specific category. It takes category and lastIndex as parameter. It'll fetch data adding 10 with the lastIndex as fetchlimit. This is used while paging the collectionView
     */
    func getAllNews(catagory: String, lastIndex: Int) {
        let fetchRequest = NSFetchRequest<NewsModel>(entityName: "NewsModel")
        let format = "catagoryName = %@"
        let predicate = NSPredicate(format: format,catagory)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = lastIndex + 10
        
        do {
            NewsModel.newsList = try context.fetch(fetchRequest)
            updateBookmarkInfo()
            
        } catch {
            print(error)
        }
    }
    
    /**
     update the bookmarkFlag for the news in NewsModel. This is used when new news are fetched from API, it checks each news if it is already in the bookmark table or not. if true it'll update the flag.
     */
    func updateBookmarkInfo(){
        for savedNews in SavedNewsModel.savedNewsList{
            for news in NewsModel.newsList {
                if savedNews.newsId == news.newsId {
                    news.isBookMarked = true
                }
            }
        }
    }
    
    /**
     Get all saved news from SavedNewsModel in coreData
     */
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
    
    /**
     get specific news from NewsModel in coreData using newsId.
     It is used to get the specific news to make the bookMark flag false while deleting any saved news.
     */
    func getNewsWithId(id: String) -> [NewsModel]
    {
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
    
    /**
     Search any news in specific category with filter. it takes category name, searchtext and an array of filter String.
     it first prepare the query using the filterList, category and searchText and put the results in the news array.
     if the firlter list is empty, it prepare a query to search in title.
     */
    func searchNews(catagory: String, searchText: String, filterList: [String]) {
        
        let fetchRequest = NSFetchRequest<NewsModel>(entityName: "NewsModel")
        var format = "catagoryName = %@ && "
        
        if filterList.count == 0 {
            format += "title CONTAINS[c] '\(searchText)'"
            
        } else {
            for i in 0...filterList.count - 1 {
                if (i == filterList.count - 1){
                    format += "\(filterList[i]) CONTAINS[c] '\(searchText)'"
                } else {
                    format += "\(filterList[i]) CONTAINS[c] '\(searchText)' || "
                }
            }
        }

        print(format)
        
        
        let predicate = NSPredicate(format: format,catagory)
        fetchRequest.predicate = predicate
        
        do {
            NewsModel.newsList = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
    
    /**
     Search any saved news using title.
     */
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
    
    /**
     Delete a saved news from SavedNewsModel. It calls the getNewsWithId() to update the bookmark flag in News Table.
     */
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
    
    /**
     Delete all news of a specific category from News Table. This is used when user pulls the news collection view.
     */
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
        
        getAllNews(catagory: catagory, lastIndex: 0)
    }
    
    /**
     Delete all data from the News Table. This is used when autoSync happens.
     */
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
