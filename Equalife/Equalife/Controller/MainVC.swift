//
//  MainVC.swift
//  Equalife
//
//  Created by Kostya Bunsberry on 20.07.2021.
//

import UIKit

var articles: [[Article]] = [
    [Article(title: "Title", contents: "Lorem ipsum shit here should be I guess", imagesURL: [""], author: "Author", date: "2020 20 20", isSaved: false)],
    [Article(title: "Title", contents: "Lorem ipsum shit here should be I guess", imagesURL: [""], author: "Author", date: "2020 20 20", isSaved: false), Article(title: "Title", contents: "Lorem ipsum shit here should be I guess", imagesURL: [""], author: "Author", date: "2020 20 20", isSaved: false),], [], []]


class MainVC: UIViewController {
    
    var chosenEditors: [Editor] = [
        Editor(name: "Global", imageName: "globe", info: "", editorId: 0, isAdded: false),
        Editor(name: "Meduza.io", imageName: "meduza", info: "", editorId: 1, isAdded: false),
        Editor(name: "DTF", imageName: "dtf", info: "", editorId: 2, isAdded: false),
        Editor(name: "TJournal", imageName: "tj", info: "", editorId: 3, isAdded: false)
    ]

    // var articles: [[Article]] = [[]*chosenEditors.count]
    
    var chosenId: Int = 0 {
        didSet {
            for (index, editor) in chosenEditors.enumerated() {
                if editor.editorId == chosenId {
                    chosenIndex = index
                }
            }
        }
    }
    var chosenIndex: Int = 0 {
        didSet {
            articlesCollectionView.reloadData()
        }
    }
    
    
    @IBOutlet weak var topBarCollectionView: UICollectionView!
    @IBOutlet weak var articlesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        GetNews(id: 17)
        self.navigationItem.title = ""
        let logo = UIImageView(image: UIImage(named: "LogoFlat"))
        logo.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logo
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        // add border to tbcv
        // TODO: getting editors from realm
        
        chosenId = chosenEditors[0].editorId
    }
    
}

extension MainVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, EditorDelegate {
    
    func changeDelegate(id: Int) {
        for  (index, editor) in chosenEditors.enumerated() {
            if editor.editorId == chosenId {
                let cell = topBarCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! EditorCell
                cell.anotherChosen()
                chosenId = id
            }
        }
        // reload shit
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // if cv = tbcv
        if collectionView == topBarCollectionView {
            return chosenEditors.count + 1
        } else {
            return articles[chosenIndex].count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topBarCollectionView {
            return CGSize(width: 64, height: 64)
        } else {
            if UIDevice.current.userInterfaceIdiom == .phone {
                if UIDevice.current.orientation.isLandscape {
                    return CGSize(width: (self.view.frame.width - 45)/2.25, height: 140)
                } else {
                    return CGSize(width: self.view.frame.width - 30, height: 140)
                }
            } else {
                return CGSize(width: (self.view.frame.width - 45)/2, height: 140)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        articlesCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == topBarCollectionView {
            if indexPath.item == chosenEditors.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "editCell", for: indexPath) as! EditEditorsCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "editorCell", for: indexPath) as! EditorCell
                cell.editorButton.setImage(UIImage(named: chosenEditors[indexPath.item].imageName), for: .normal)
                cell.delegate = self
                cell.editorButton.imageView?.contentMode = .scaleAspectFit
                cell.editorId = chosenEditors[indexPath.item].editorId
                
                if indexPath.item == 0 {
                    cell.editorButton.setImage(UIImage(named: "globe"), for: .normal)
                    cell.thisChosen()
                }
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! ArticleCell
            cell.titleLabel.text = articles[chosenIndex][indexPath.row].title
            cell.contentTextView.text = articles[chosenIndex][indexPath.row].contents // [1...100]
            cell.articleImageView.image = UIImage(named: "LogoFlat")
//            cell.contentView.layer.borderColor = UIColor.black.cgColor
//            cell.contentView.layer.borderWidth = 1
            
            cell.layer.cornerRadius = 3
            cell.layer.shadowRadius = 5
            cell.layer.shadowOffset = .zero
            cell.layer.shadowOpacity = 0.2
            cell.layer.shadowColor = UIColor.label.cgColor
            cell.layer.shadowPath = UIBezierPath(rect: cell.contentView.bounds).cgPath
            cell.layer.masksToBounds = false
            
//            cell.articleImageView.image = KF.get ...
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == articlesCollectionView {
            performSegue(withIdentifier: "toArticle", sender: nil)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.destination is ArticleVC {
//            // articleVc.article = article
//        }
//    }

}
