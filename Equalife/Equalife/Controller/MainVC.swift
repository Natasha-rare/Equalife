//
//  MainVC.swift
//  Equalife
//
//  Created by Kostya Bunsberry on 20.07.2021.
//

import UIKit
import Kingfisher
import RealmSwift
import CloudKit

protocol EditorChange {
    func editorsChanged()
}

class MainVC: UIViewController, EditorChange {
    
    var chosenEditors: [Editor] = [Editor(name: "Global", imageName: "globe", info: "", editorId: -1, isAdded: true, category: [])]
    
    var articles: [[Article]] = []
    fileprivate var isLoading = false
    fileprivate var hasConnection = true
    
    var chosenId: Int = -1 {
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
            if articles[chosenIndex].isEmpty {
                if Reachability.isConnectedToNetwork(){
                    getNews(id: chosenId, page: page)
                } else{
                    hasConnection = false
                    articlesCollectionView.reloadData()
                }
            } else {
                articlesCollectionView.reloadData()
            }
        }
    }
    
    var page: Int {
        get {
            return articles[chosenIndex].count / 8
        }
    }
    
    @IBOutlet weak var topBarCollectionView: UICollectionView!
    @IBOutlet weak var articlesCollectionView: UICollectionView!
    
    let api = APIService()
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // starting stuff
        
        if UsersData.shared.haveAlreadyLaunched == nil || UsersData.shared.haveAlreadyLaunched == false {
            let startEditors = [
                Editor(name: "Meduza - Новости", imageName: "meduza", info: "Латвийское интернет-издание, созданное бывшим главным редактором Lenta.ru Галиной Тимченко в 2014 году", editorId: 0, isAdded: false, category: [.politics]),
                Editor(name: "Meduza - Истории", imageName: "meduza", info: "Латвийское интернет-издание, созданное бывшим главным редактором Lenta.ru Галиной Тимченко в 2014 году", editorId: 1, isAdded: false, category: [.politics]),
                Editor(name: "DTF", imageName: "dtf", info: "Русскоязычный интернет-ресурс о компьютерных играх. До 2016 года был посвящён преимущественно разработке видеоигр.", editorId: 9, isAdded: false, category: [.games, .tech, .movies]),
                Editor(name: "DTF - Игры", imageName: "dtf", info: "Русскоязычный интернет-ресурс о компьютерных играх. До 2016 года был посвящён преимущественно разработке видеоигр.", editorId: 5, isAdded: false, category: [.games]),
                Editor(name: "DTF - Игровая индустрия", imageName: "dtf", info: "Русскоязычный интернет-ресурс о компьютерных играх. До 2016 года был посвящён преимущественно разработке видеоигр.", editorId: 6, isAdded: false, category: [.games]),
                Editor(name: "DTF - Разработка", imageName: "dtf", info: "Русскоязычный интернет-ресурс о компьютерных играх. До 2016 года был посвящён преимущественно разработке видеоигр.", editorId: 7, isAdded: false, category: [.tech]),
                Editor(name: "DTF - Кино", imageName: "dtf", info: "Русскоязычный интернет-ресурс о компьютерных играх. До 2016 года был посвящён преимущественно разработке видеоигр.", editorId: 8, isAdded: false, category: [.movies]),
                Editor(name: "TJournal", imageName: "tj", info: "Российское интернет-издание и агрегатор новостей. Основано 20 июня 2011 года. С 2014 года входит в Издательский дом «Комитет». Тематика новостей — социальные сети, блоги, законодательство и гаджеты.", editorId: 14, isAdded: false, category: [.politics, .tech]),
                Editor(name: "TJournal - Новости", imageName: "tj", info: "Российское интернет-издание и агрегатор новостей. Основано 20 июня 2011 года. С 2014 года входит в Издательский дом «Комитет». Тематика новостей — социальные сети, блоги, законодательство и гаджеты.", editorId: 10, isAdded: false, category: [.politics]),
                Editor(name: "TJournal - Истории", imageName: "tj", info: "Российское интернет-издание и агрегатор новостей. Основано 20 июня 2011 года. С 2014 года входит в Издательский дом «Комитет». Тематика новостей — социальные сети, блоги, законодательство и гаджеты.", editorId: 11, isAdded: false, category: [.politics]),
                Editor(name: "TJournal - Технологии", imageName: "tj", info: "Российское интернет-издание и агрегатор новостей. Основано 20 июня 2011 года. С 2014 года входит в Издательский дом «Комитет». Тематика новостей — социальные сети, блоги, законодательство и гаджеты.", editorId: 12, isAdded: false, category: [.tech]),
                Editor(name: "TJournal - разработка", imageName: "tj", info: "Российское интернет-издание и агрегатор новостей. Основано 20 июня 2011 года. С 2014 года входит в Издательский дом «Комитет». Тематика новостей — социальные сети, блоги, законодательство и гаджеты.", editorId: 13, isAdded: false, category: [.tech]),
                Editor(name: "vc.ru", imageName: "vc", info: "Интернет-издание о бизнесе, стартапах, инновациях, маркетинге и технологиях.", editorId: 15, isAdded: false, category: [.design, .tech]),
                Editor(name: "vc.ru - Дизайн", imageName: "vc", info: "Интернет-издание о бизнесе, стартапах, инновациях, маркетинге и технологиях.", editorId: 16, isAdded: false, category: [.design]),
                Editor(name: "vc.ru - Технологии", imageName: "vc", info: "Интернет-издание о бизнесе, стартапах, инновациях, маркетинге и технологиях.", editorId: 17, isAdded: false, category: [.tech]),
                Editor(name: "vc.ru - Разработка", imageName: "vc", info: "Интернет-издание о бизнесе, стартапах, инновациях, маркетинге и технологиях.", editorId: 18, isAdded: false, category: [.tech])
            ]
            
            try! realm.write {
                for editor in startEditors {
                    realm.add(RealmEditor(name: editor.name, imageName: editor.imageName, info: editor.info, editorId: editor.editorId, isAdded: editor.isAdded, category: editor.category))
                }
            }
            
            UsersData.shared.haveAlreadyLaunched = true
        }
        
        self.navigationItem.title = ""
        let logo = UIImageView(image: UIImage(named: "LogoFlat"))
        logo.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logo
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        updateEditors()
    }
    
    func updateEditors() {
        chosenEditors.removeAll()
        chosenEditors.append(Editor(name: "Global", imageName: "globe", info: "", editorId: -1, isAdded: true, category: []))
        
        let realmEditors = realm.objects(RealmEditor.self)
        for editor in realmEditors {
            let categoriesString: [String] = editor.category.components(separatedBy: "|")
            var categories: [EditorCategory] = []
            for categoryString in categoriesString {
                categories.append(EditorCategory(rawValue: categoryString)!)
            }
            if editor.isAdded {
                chosenEditors.append(Editor(name: editor.name, imageName: editor.imageName, info: editor.info, editorId: editor.editorId, isAdded: editor.isAdded, category: categories))
            }
        }
        
        chosenEditors.sort(by: { $0.sortId > $1.sortId })
        
        articles.removeAll()
        for _ in 0..<chosenEditors.count {
            articles.append([])
        }
        
        topBarCollectionView.reloadData()
        chosenId = -1
    }
    
    func editorsChanged() {
        updateEditors()
    }
    
    func getNews(id: Int, page: Int) {
        // showing indicator
        isLoading = true
        articlesCollectionView.reloadData()
        
        // MARK: here start animating
        
        api.GetNews(id: id, page: page, completion: { articlesRes in
            self.articles[self.chosenIndex].append(contentsOf: articlesRes)
            self.isLoading = false
            self.articlesCollectionView.reloadData()
        })
    }
    
}

extension MainVC: LoadMoreDelegate {
    func loadNextPage() {
        getNews(id: chosenId, page: page)
        let cell = collectionView(articlesCollectionView, cellForItemAt: IndexPath(item: articles[chosenIndex].count, section: 0)) as! LoadMoreCell
        cell.loadButton.isEnabled = false
//        cell.loadButton.tintColor = .link
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
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topBarCollectionView {
            return chosenEditors.count + 1
        } else {
            if articles[chosenIndex].isEmpty {
                return 1
            }
            return articles[chosenIndex].count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topBarCollectionView {
            return CGSize(width: 64, height: 64)
        } else {
            if !hasConnection {
                return CGSize(width: self.view.frame.width, height: collectionView.frame.height)
            }
            
            if articles[chosenIndex].isEmpty {
                return CGSize(width: self.view.frame.width, height: collectionView.frame.height)
            }
            
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
                } else {
                    cell.anotherChosen()
                }
                return cell
            }
        } else {
            // Articles Collection View
            
            if !hasConnection {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noConnectionCell", for: indexPath)
                return cell
            }
            
            if articles[chosenIndex].isEmpty {
                switch isLoading {
                case true:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath) as! LoadingArticlesCell
                    cell.loadingIndicator.startAnimating()
                    return cell
                case false:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noArticlesCell", for: indexPath) as! NoArticlesCell
                    return cell
                }
            }
            
            if indexPath.row == articles[chosenIndex].count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadMoreCell", for: indexPath) as! LoadMoreCell
                cell.delegate = self
                cell.loadButton.isEnabled = true
                cell.loadButton.tintColor = .systemBlue
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! ArticleCell
            cell.titleLabel.text = articles[chosenIndex][indexPath.row].title
            if articles[chosenIndex][indexPath.row].title.isEmpty {
                cell.titleLabel.text = "Картинка"
            }
            
            if articles[chosenIndex][indexPath.row].imagesURL.isEmpty {
                cell.articleImageView.image = UIImage(named: "imagePlaceholder")
            } else {
                let url = URL(string: articles[chosenIndex][indexPath.row].imagesURL[0])
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
            cell.layer.shadowPath = UIBezierPath(rect: cell.contentView.bounds).cgPath
            cell.layer.masksToBounds = false
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == articlesCollectionView {
            performSegue(withIdentifier: "toArticle", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditing" {
            let vc = segue.destination as! EditorsVC
            vc.delegate = self
        }
    }
}
