//
//  News.swift
//  Equalife
//
//  Created by Kostya Bunsberry on 20.07.2021.
//

import Foundation
import RealmSwift

// Структура статьи
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

class RealmArticle: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var contents: String = ""
    @objc dynamic var imagesURL: String = ""
    @objc dynamic var author: String? = ""
    @objc dynamic var date: String = ""
    @objc dynamic var isSaved: Bool = false
    
    convenience init(title: String, contents: String, imagesURL: [String], author: String?, date: String, isSaved: Bool) {
        self.init()
        self.title = title
        self.contents = contents
        
        if let author = author {
            self.author = author
        }
        
        self.date = date
        self.isSaved = isSaved
        
        for imageURL in imagesURL {
//            self.imagesURL.append(imageURL)
            self.imagesURL += "\(imageURL)|"
            self.imagesURL.removeLast()
        }
    }
}

enum EditorCategory: String {
    case politics
    case games
    case tech
    case movies
    case design
    case finance
    case dzen
    case education
    case media
}

// Структура издания (может что-то добавлю)
struct Editor {
    var name: String = ""
    var imageName: String = ""
    var info: String = ""
    var editorId: Int = 0
    var sortId: Int = 0
    var isAdded: Bool = false
    var category: [EditorCategory] = [.politics]
    
    init() {}
    
    init(name: String, imageName: String, info: String, editorId: Int, isAdded: Bool, category: [EditorCategory]) {
        self.name = name
        self.imageName = imageName
        self.info = info
        self.editorId = editorId
        self.isAdded = isAdded
        self.category = category
    }
}

class RealmEditor: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var imageName: String = ""
    @objc dynamic var info: String = ""
    @objc dynamic var editorId: Int = 0
    @objc dynamic var sortId: Int = 0
    @objc dynamic var isAdded: Bool = false
    @objc dynamic var category: String = ""
    
    convenience init(name: String, imageName: String, info: String, editorId: Int, isAdded: Bool, category: [EditorCategory]) {
        self.init()
        self.name = name
        self.imageName = imageName
        self.info = info
        self.editorId = editorId
        self.isAdded = isAdded
        for category in category {
            self.category += "\(category.rawValue)|"
        }
        self.category.removeLast()
    }
}
