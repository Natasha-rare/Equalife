//
//  CategoriesVC.swift
//  CategoriesVC
//
//  Created by Kostya Bunsberry on 31.07.2021.
//

import UIKit
import RealmSwift

fileprivate struct Category {
    var name: String = ""
    var category: EditorCategory = .politics
}

class CategoriesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    let realm = try! Realm()
    
    private var chosenCategories: [Category] = []
    private var availableCategories: [Category] = [
        Category(name: "😬 Политика", category: .politics),
        Category(name: "👾 Игры", category: .games),
        Category(name: "🤖 Технологии", category: .tech),
        Category(name: "🤠 Фильмы", category: .movies),
        Category(name: "🌈 Дизайн", category: .design),
        Category(name: "🤡 Медиа", category: .media),
        Category(name: "🤑 Финансы", category: .finance),
        Category(name: "🤓 Образование", category: .education),
        Category(name: "👽 Дзен", category: .dzen)
    ]
    
    var delegateCategories: [EditorCategory] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesTableView.isEditing = true
        
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
                Editor(name: "vc.ru - Разработка", imageName: "vc", info: "Интернет-издание о бизнесе, стартапах, инновациях, маркетинге и технологиях.", editorId: 18, isAdded: false, category: [.tech]),
                Editor(name: "vc.ru - Финансы", imageName: "vc", info: "Интернет-издание о бизнесе, стартапах, инновациях, маркетинге и технологиях.", editorId: 19, isAdded: false, category: [.finance]),
                Editor(name: "vc.ru - Медиа", imageName: "vc", info: "Интернет-издание о бизнесе, стартапах, инновациях, маркетинге и технологиях.", editorId: 20, isAdded: false, category: [.media]),
                Editor(name: "vc.ru - Образование", imageName: "vc", info: "Интернет-издание о бизнесе, стартапах, инновациях, маркетинге и технологиях.", editorId: 21, isAdded: false, category: [.education]),
                Editor(name: "vc.ru - Дзен", imageName: "vc", info: "Интернет-издание о бизнесе, стартапах, инновациях, маркетинге и технологиях.", editorId: 22, isAdded: false, category: [.dzen]),
                Editor(name: "TJournal - Дзен", imageName: "tj", info: "Российское интернет-издание и агрегатор новостей. Основано 20 июня 2011 года. С 2014 года входит в Издательский дом «Комитет». Тематика новостей — социальные сети, блоги, законодательство и гаджеты.", editorId: 23, isAdded: false, category: [.dzen]),
                Editor(name: "TJournal - Игры", imageName: "tj", info: "Российское интернет-издание и агрегатор новостей. Основано 20 июня 2011 года. С 2014 года входит в Издательский дом «Комитет». Тематика новостей — социальные сети, блоги, законодательство и гаджеты.", editorId: 24, isAdded: false, category: [.games]),
                Editor(name: "DTF - Новости", imageName: "dtf", info: "Русскоязычный интернет-ресурс о компьютерных играх. До 2016 года был посвящён преимущественно разработке видеоигр.", editorId: 25, isAdded: false, category: [.tech, .games]),
                Editor(name: "DTF - Дизайн", imageName: "dtf", info: "Русскоязычный интернет-ресурс о компьютерных играх. До 2016 года был посвящён преимущественно разработке видеоигр.", editorId: 26, isAdded: false, category: [.design])
            ]
            
            try! realm.write {
                for editor in startEditors {
                    realm.add(RealmEditor(name: editor.name, imageName: editor.imageName, info: editor.info, editorId: editor.editorId, isAdded: editor.isAdded, category: editor.category))
                }
            }
            
            UsersData.shared.haveAlreadyLaunched = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Выбранные категории"
        } else {
            return "Доступные категории"
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 {
            if chosenCategories.isEmpty {
                return .none
            }
            return .delete
        } else {
            return .insert
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .insert {
            chosenCategories.append(availableCategories[indexPath.row])
            availableCategories.remove(at: indexPath.row)
            if chosenCategories.count == 1 {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            } else {
                tableView.moveRow(at: indexPath, to: IndexPath(row: tableView.numberOfRows(inSection: 0), section: 0))
            }
        } else {
            availableCategories.insert(chosenCategories[indexPath.row], at: 0)
            chosenCategories.remove(at: indexPath.row)
            if chosenCategories.isEmpty {
                tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
                tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            } else {
                tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 1))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if chosenCategories.isEmpty { return 1 }
            return chosenCategories.count
        } else {
            return availableCategories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && chosenCategories.isEmpty {
            let cell = categoriesTableView.dequeueReusableCell(withIdentifier: "noChosenCell")!
            return cell
        }
        
        if indexPath.section == 0 {
            let cell = categoriesTableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryCell
            cell.titleLabel.text = chosenCategories[indexPath.row].name
            return cell
        } else {
            let cell = categoriesTableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryCell
            cell.titleLabel.text = availableCategories[indexPath.row].name
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ProposedVC
        
        delegateCategories.removeAll()
        for category in chosenCategories {
            delegateCategories.append(category.category)
        }
        
        vc.chosenCategories = delegateCategories
    }
    
}
