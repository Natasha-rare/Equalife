//
//  ArticleVC.swift
//  Equalife
//
//  Created by Kostya Bunsberry on 20.07.2021.
//

import UIKit
import SwiftUI
import RealmSwift

class ArticleVC: UIViewController, ScrollDelegate {
    
    var article: Article!
    var articleView: ArticleView!
    
    var isSaved = false
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleView = ArticleView(article: self.article)
        articleView.delegate = self
        
        let contentView = UIHostingController(rootView: articleView)
        
        addChild(contentView)
        view.addSubview(contentView.view)
        
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let realmObjects = realm.objects(RealmArticle.self)
        for object in realmObjects {
            if object.title == article.title {
                isSaved = true
                break
            }
        }
        
//        self.navigationController?.view.add
        if !isSaved {
            let button = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(ArticleVC.addToMarked))
            self.navigationItem.rightBarButtonItem = button
        } else {
            let button = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"), style: .plain, target: self, action: #selector(ArticleVC.addToMarked))
            self.navigationItem.rightBarButtonItem = button
        }
    }
    
    @objc func addToMarked(_ sender: UIBarButtonItem) {
        isSaved = !isSaved
        if isSaved {
            sender.image = UIImage(systemName: "bookmark.fill")
            try! realm.write {
                realm.add(RealmArticle(title: article.title, contents: article.contents, imagesURL: article.imagesURL, author: article.author, date: article.date, isSaved: isSaved))
            }
        } else {
            sender.image = UIImage(systemName: "bookmark")
            let realmObjects = realm.objects(RealmArticle.self)
            for object in realmObjects {
                if object.title == article.title {
                    try! realm.write {
                        realm.delete(object)
                    }
                    break
                }
            }
        }
    }
    
    func didScroll() {
        self.navigationController?.view.backgroundColor = UIColor.systemBackground
        self.navigationController?.navigationBar.isTranslucent = false
    }
}
