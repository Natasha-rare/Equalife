//
//  ProposedCell.swift
//  ProposedCell
//
//  Created by Kostya Bunsberry on 31.07.2021.
//

import UIKit

protocol ProposedDelegate {
    func addedRemoved(id: Int)
}

class ProposedCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    var delegate: ProposedDelegate?
    var editorId: Int!
    var isAdded = false
    
    @IBAction func addRemove() {
        if !isAdded {
            button.backgroundColor = .systemRed
            button.setImage(UIImage(systemName: "minus"), for: .normal)
        } else {
            button.backgroundColor = .systemGreen
            button.setImage(UIImage(systemName: "plus"), for: .normal)
        }
        print("X! \(isAdded) to \(!isAdded)")
        isAdded = !isAdded
        delegate?.addedRemoved(id: editorId)
    }
}
