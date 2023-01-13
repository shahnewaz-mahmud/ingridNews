//
//  NewsModel+CoreDataProperties.swift
//  IngridNews
//
//  Created by BJIT on 1/13/23.
//
//

import Foundation
import CoreData


extension NewsModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsModel> {
        return NSFetchRequest<NewsModel>(entityName: "NewsModel")
    }

    @NSManaged public var newsId: String?
    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var newsDescription: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var content: String?
    @NSManaged public var catagoryName: String?
    @NSManaged public var isBookMarked: Bool
    
    static var newsList = [NewsModel]()

}

extension NewsModel : Identifiable {

}
