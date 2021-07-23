//
//  EditorsVC.swift
//  EditorsVC
//
//  Created by Kostya Bunsberry on 23.07.2021.
//

import UIKit

class EditorsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, InfoDelegate {
    
    var chosenEditors: [Editor] = [Editor(name: "Meduza", imageName: "meduza", info: "", editorId: 0, isAdded: true)]
    let availableEditors: [Editor] = [Editor(name: "Meduza", imageName: "meduza", info: "", editorId: 0, isAdded: false)]
    
    var chosenEditor = Editor(name: "", imageName: "", info: "", editorId: 0, isAdded: true)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("number set")
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Выбранные издатели"
        } else {
            return "Доступные издатели"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return chosenEditors.count
        case 1:
            print("availableEditors.count")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            chosenEditor = chosenEditors[indexPath.row]
        } else {
            chosenEditor = availableEditors[indexPath.row]
        }
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toInfo", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! EditorInfoVC
        vc.delegate = self
        vc.editor = chosenEditor
    }
    
    func infoChanged() {
        // reload arrays
        tableView.reloadData()
    }
    
    @IBAction func edit() {
        if tableView.isEditing {
            editButton.title = "Править"
        } else {
            editButton.title = "Готово"
        }
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
}
