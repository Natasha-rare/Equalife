//
//  MainVC.swift
//  Equalife
//
//  Created by Kostya Bunsberry on 20.07.2021.
//

import UIKit

class MainVC: UIViewController {
    
    var chosenEditors: [Editor] = [
        Editor(name: "Global", imageName: "globe", editorId: 0, isAdded: false),
        Editor(name: "Meduza.io", imageName: "meduza", editorId: 1, isAdded: false),
        Editor(name: "DTF", imageName: "dtf", editorId: 2, isAdded: false),
        Editor(name: "TJournal", imageName: "tj", editorId: 3, isAdded: false)
    ]
    
    var articles: [[Article]] = [
        [Article(title: "Title", imagesURL: [""], author: "Author", date: "2020 20 20", isSaved: false)],
        [Article(title: "Title", imagesURL: [""], author: "Author", date: "2020 20 20", isSaved: false), Article(title: "Title", imagesURL: [""], author: "Author", date: "2020 20 20", isSaved: false),]]
    
    var chosenId: Int = 0
    
    @IBOutlet weak var topBarCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, EditorDelegate {
    
    func changeDelegate(id: Int) {
        for  (index, editor) in chosenEditors.enumerated() {
            if editor.editorId == chosenId {
                let cell = topBarCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! EditorCell
                cell.bgView.addBorders(edges: .bottom, color: .systemBackground, inset: 0, thickness: 2)
                
                chosenId = id
            }
        }
        // reload shit
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // if cv = tbcv
        return chosenEditors.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // for another cv
//        if collectionView == topBarCollectionView {
        
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
                    cell.editorButton.setImage(UIImage(systemName: "globe"), for: .normal)
                    cell.bgView.addBorders(edges: .bottom, color: .label, inset: 0, thickness: 2)
                }
                return cell
            }
//        }else {
            
//        }
    }

}
