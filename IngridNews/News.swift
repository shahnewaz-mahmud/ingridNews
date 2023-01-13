//
//  News.swift
//  IngridNews
//
//  Created by BJIT on 1/13/23.
//

import Foundation

struct News: Encodable, Decodable {
    let title: String?
    let author: String?
    let description: String?
    let url: String?
    var urlToImage: String?
    let publishedAt: String?
    var content: String?
}


