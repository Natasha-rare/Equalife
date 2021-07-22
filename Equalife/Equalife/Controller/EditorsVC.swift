//
//  EditorsVC.swift
//  EditorsVC
//
//  Created by Kostya Bunsberry on 23.07.2021.
//

import UIKit

class EditorsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var chosenEditors: [Editor] = []
    let availableEditors: [Editor] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func finish() {
        // delegate - reload editors
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return chosenEditors.count
        case 1:
            return availableEditors.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "publisherCell") as! PublisherCell
        
        if indexPath.section == 0 {
            cell.titleLabel.text = chosenEditors[indexPath.row].name
            cell.logoImageView.image = UIImage(named: chosenEditors[indexPath.row].imageName)
        } else {
            cell.titleLabel.text = availableEditors[indexPath.row].name
            cell.logoImageView.image = UIImage(named: availableEditors[indexPath.row].imageName)
        }
        
        return cell
    }
    
    @IBAction func edit() {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
}
