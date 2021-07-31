//
//  ProposedVC.swift
//  ProposedVC
//
//  Created by Kostya Bunsberry on 31.07.2021.
//

import UIKit
import RealmSwift

class ProposedVC: UIViewController, ProposedDelegate {
    
    var chosenCategories: [EditorCategory]!
    var editors: [Editor] = []
    
    let realm = try! Realm()
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        editors.removeAll()
        
        // filetering needed editors
        let realmEditors = realm.objects(RealmEditor.self)
        for realmEditor in realmEditors {
            let editorCategories = realmEditor.category.components(separatedBy: "|")
            var categories: [EditorCategory] = []
            
            for category in editorCategories {
                categories.append(EditorCategory(rawValue: category)!)
            }
            if !chosenCategories.isEmpty {
                for chosenCategory in chosenCategories {
                    if categories.contains(chosenCategory) {
                        if editors.contains(where: { $0.editorId == realmEditor.editorId }) {
                            print("Z! found a duplicate")
                        } else {
                            editors.append(Editor(name: realmEditor.name, imageName: realmEditor.imageName, info: realmEditor.info, editorId: realmEditor.editorId, isAdded: realmEditor.isAdded, category: categories))
                        }
                        continue
                    }
                }
            } else {
                editors.append(Editor(name: realmEditor.name, imageName: realmEditor.imageName, info: realmEditor.info, editorId: realmEditor.editorId, isAdded: realmEditor.isAdded, category: categories))
            }
        }
        
        collectionView.reloadData()
    }
    
    @IBAction func toMain() {
        let realmEditors = realm.objects(RealmEditor.self)
        for realmEditor in realmEditors {
            if editors.contains(where: { $0.editorId == realmEditor.editorId && $0.isAdded == true }) {
                try! realm.write {
                    realmEditor.isAdded = true
                }
            }
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        vc.modalPresentationStyle = .fullScreen
        
        UsersData.shared.didAlreadyGoToMain = true
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func addedRemoved(id: Int) {
        for (index, editor) in editors.enumerated() {
            if editor.editorId == id {
                editors[index].isAdded = true
            }
        }
    }
    
}

extension ProposedVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return editors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "editorCell", for: indexPath) as! ProposedCell
        cell.delegate = self
        cell.editorId = editors[indexPath.item].editorId
        
        cell.titleLabel.text = editors[indexPath.item].name
        cell.logoImageView.image = UIImage(named: editors[indexPath.item].imageName)
        
        cell.button.backgroundColor = .systemGreen
        cell.button.setImage(UIImage(systemName: "plus"), for: .normal)
        
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.label.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if UIDevice.current.orientation.isLandscape {
                return CGSize(width: (self.view.frame.width - 60)/3.25, height: (self.view.frame.width - 45)/3.25)
            } else {
                return CGSize(width: (self.view.frame.width - 45)/2, height: (self.view.frame.width - 45)/2.25)
            }
        } else {
            return CGSize(width: (self.view.frame.width - 60)/3.25, height: (self.view.frame.width - 45)/3.25)
        }
    }
    
}
