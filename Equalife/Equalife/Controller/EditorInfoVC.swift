//
//  EditorInfoVC.swift
//  EditorInfoVC
//
//  Created by Kostya Bunsberry on 23.07.2021.
//

import UIKit

protocol InfoDelegate {
    func infoChanged()
}

class EditorInfoVC: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var addButton: UIButton!
    
    var editor: Editor!
    var delegate: InfoDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        logoImageView.image = UIImage(named: editor.imageName)
        titleLabel.text = editor.name
        infoTextView.text = editor.info
        buttonSetup()
    }
    
    func buttonSetup() {
        if editor.isAdded {
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
        buttonSetup()
    }

}
