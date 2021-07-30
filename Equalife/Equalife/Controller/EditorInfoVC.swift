//
//  EditorInfoVC.swift
//  EditorInfoVC
//
//  Created by Kostya Bunsberry on 23.07.2021.
//

import UIKit

protocol InfoDelegate {
    func infoChanged(editor: Editor)
}

class EditorInfoVC: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var editor: Editor!
    var delegate: InfoDelegate?
    var startAdded: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        logoImageView.image = UIImage(named: editor.imageName)
        titleLabel.text = editor.name
        infoLabel.text = editor.info
        buttonSetup()
        
        startAdded = editor.isAdded
        
        var labelCategories = ""
        for category in editor.category {
            switch category {
            case .politics:
                labelCategories += " Политика,"
            case .games:
                labelCategories += " Игры,"
            case .tech:
                labelCategories += " Технологии,"
            case .movies:
                labelCategories += " Фильмы,"
            case .design:
                labelCategories += " Дизайн,"
            }
        }
        labelCategories.removeLast()
        
        categoryLabel.text = "Категории:\(labelCategories)"
    }
    
    func buttonSetup() {
        if !editor.isAdded {
            addButton.setTitle("Добавить", for: .normal)
            addButton.setImage(UIImage(systemName: "plus"), for: .normal)
            addButton.backgroundColor = UIColor.systemGreen
        } else {
            addButton.setTitle("Убрать", for: .normal)
            addButton.setImage(UIImage(systemName: "minus"), for: .normal)
            addButton.backgroundColor = UIColor.systemRed
        }
    }
    
    @IBAction func add() {
        // realm id change added and delegate
        editor.isAdded = !editor.isAdded
        delegate?.infoChanged(editor: editor)
        buttonSetup()
    }

}
