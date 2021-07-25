//
//  News.swift
//  Equalife
//
//  Created by Kostya Bunsberry on 20.07.2021.
//

import Foundation

// Структура статьи (просто для начала)
struct Article {
    var title: String = ""
    var contents: String = ""
    var imagesURL: [String] = []
    var author: String? = ""
    var date: String = ""
    var isSaved: Bool = false
    init(){
    }
    
    init(title: String, contents: String, imagesURL: [String], author: String?, date: String, isSaved: Bool) {
        self.title = title
        self.contents = contents
        
        if let author = author {
            self.author = author
        }
        
        self.date = date
        self.isSaved = isSaved
        
        for imageURL in imagesURL {
            self.imagesURL.append(imageURL)
        }
    }
}

// Структура издания (может что-то добавлю)
struct Editor {
    var name: String = ""
    var imageName: String = ""
    var info: String = ""
    var editorId: Int = 0
    var isAdded: Bool = false
    init(){
    }
    
    init(name: String, imageName: String, info: String, editorId: Int, isAdded: Bool) {
        self.name = name
        self.imageName = imageName
        self.info = info
        self.editorId = editorId
        self.isAdded = isAdded
    }
}

// TODO: Здесь будут все добавленные издания, сохраненные в кэше, но это все потом
