//
//  GlobalNewsCell.swift
//  Equalife
//
//  Created by Kostya Bunsberry on 21.07.2021.
//

import UIKit

class GlobalNewsCell: UICollectionViewCell {
    @IBOutlet weak var editorButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    var editorId: Int = -1
    var delegate: EditorDelegate?
    
    @IBAction func editorChosen() {
        delegate?.changeDelegate(id: editorId)
        bgView.addBorders(edges: .bottom, color: .label, inset: 0, thickness: 2)
    }
}
