//
//  LoadMoreCell.swift
//  LoadMoreCell
//
//  Created by Kostya Bunsberry on 30.07.2021.
//

import UIKit

protocol LoadMoreDelegate {
    func loadNextPage()
}

class LoadMoreCell: UICollectionViewCell {
    @IBOutlet weak var loadButton: UIButton!
    
    var delegate: LoadMoreDelegate?
    
    @IBAction func loadMore() {
        delegate?.loadNextPage()
    }
}
