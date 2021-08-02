//
//  SavedVC.swift
//  Equalife
//
//  Created by Kostya Bunsberry on 20.07.2021.
//

import UIKit
import RealmSwift
import Kingfisher

protocol SavedChanges {
    func savingChanged(to state: Bool)
}

class SavedVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, SavedChanges {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var articles: [Article] = []
    var chosenArticle = Article()
    
    var deletedIndex = 0
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadArticles()
        collectionView.reloadData()
    }
    
    func reloadArticles() {
        let realmArticles = realm.objects(RealmArticle.self)
        
        for article in realmArticles {
            let images = article.imagesURL.components(separatedBy: "|")
            
            articles.append(Article(title: article.title,
                                         contents: article.contents,
                                         imagesURL: images,
                                         author: article.author,
                                         date: article.date,
                                         isSaved: true))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if articles.isEmpty {
            return 1
        }
        
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenArticle = articles[indexPath.row]
        performSegue(withIdentifier: "toArticle", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if articles.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noArticlesCell", for: indexPath) as! NoArticlesCell
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! ArticleCell
        cell.titleLabel.text = articles[indexPath.row].title
        if articles[indexPath.row].title.isEmpty {
            cell.titleLabel.text = "Картинка"
        }
        
        if articles[indexPath.row].imagesURL.isEmpty {
            cell.articleImageView.image = UIImage(named: "imagePlaceholder")
        } else {
            let url = URL(string: articles[indexPath.row].imagesURL[0])
            let processor = DownsamplingImageProcessor(size: cell.articleImageView.bounds.size)
            cell.articleImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "imagePlaceholder"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.5)),
                    .cacheOriginalImage
                ])
        }
        cell.layer.cornerRadius = 3
        cell.layer.shadowRadius = 5
        cell.layer.shadowOffset = .zero
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowColor = UIColor.label.cgColor
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if articles.isEmpty {
            return CGSize(width: self.view.frame.width, height: collectionView.frame.height)
        }

        if UIDevice.current.userInterfaceIdiom == .phone {
            if UIDevice.current.orientation.isLandscape {
                // return CGSize(width: (self.view.frame.width - 45)/2.25, height: 140)
                return CGSize(width: (self.view.frame.width - 30) / 1.5, height: 140)
            } else {
                return CGSize(width: self.view.frame.width - 30, height: 140)
            }
        } else {
            if indexPath.item == articles.count {
                return CGSize(width: self.view.frame.width, height: 140)
            }
                
            return CGSize(width: (self.view.frame.width - 45)/2, height: 140)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ArticleVC
//        vc.delegate = self
        vc.article = chosenArticle
    }
    
    func savingChanged(to state: Bool) {
        reloadArticles()
        collectionView.reloadData()
    }

}
