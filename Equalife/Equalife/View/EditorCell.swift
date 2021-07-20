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
    
    var editorId: Int!
    var delegate: EditorDelegate?
    
    @IBAction func editorChosen() {
        delegate?.changeDelegate(id: editorId)
        bgView.addBorders(edges: .bottom, color: .label, inset: 0, thickness: 2)
    }
}
