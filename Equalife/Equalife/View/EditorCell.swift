//
//  EditorCell.swift
//  Equalife
//
//  Created by Kostya Bunsberry on 21.07.2021.
//

import UIKit

protocol EditorDelegate {
    func changeDelegate(id: Int)
}

class EditorCell: UICollectionViewCell {
    @IBOutlet weak var editorButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var choiceView: UIView!
    @IBOutlet weak var choiceHeightConstraint: NSLayoutConstraint!
    
    var editorId: Int!
    var delegate: EditorDelegate?
    
    func anotherChosen() {
        UIView.animate(withDuration: 0.5, animations: {
            self.choiceView.backgroundColor = .systemBackground
            self.choiceHeightConstraint.constant = 1
        }, completion: { _ in
            self.choiceView.backgroundColor = .systemBackground
            self.choiceHeightConstraint.constant = 1
        })
    }
    
    func thisChosen() {
        UIView.animate(withDuration: 0.25, animations: {
            self.choiceView.backgroundColor = .label
            self.choiceHeightConstraint.constant = 2
        }, completion: { _ in
            self.choiceView.backgroundColor = .label
            self.choiceHeightConstraint.constant = 2
        })
    }
    
    @IBAction func editorChosen() {
        delegate?.changeDelegate(id: editorId)
        thisChosen()
    }
}
