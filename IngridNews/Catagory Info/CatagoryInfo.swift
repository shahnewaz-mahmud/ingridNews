//
//  CatagoryInfo.swift
//  IngridNews
//
//  Created by Shahnewaz on 14/1/23.
//

import Foundation

struct Catagory {
    let name: String?
    let img: String?
}

extension Catagory {
    static let catagoryList = [ Catagory(name: "All", img: "newspaper"),
                                Catagory(name: "Business", img: "dollarsign.square"),
                                Catagory(name: "General", img: "books.vertical"),
                                Catagory(name: "Health", img: "stethoscope"),
                                Catagory(name: "Science", img: "brain.head.profile"),
                                Catagory(name: "Sports", img: "sportscourt"),
                                Catagory(name: "Technology", img: "pc")
    ]
}
