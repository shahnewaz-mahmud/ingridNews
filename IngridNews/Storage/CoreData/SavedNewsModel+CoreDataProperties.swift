//
//  SavedNewsModel+CoreDataProperties.swift
//  IngridNews
//
//  Created by BJIT on 1/13/23.
//
//

import Foundation
import CoreData


extension SavedNewsModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedNewsModel> {
        return NSFetchRequest<SavedNewsModel>(entityName: "SavedNewsModel")
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
    
    static var savedNewsList = [SavedNewsModel]()

}

extension SavedNewsModel : Identifiable {

}
