//
//  EditorsVC.swift
//  EditorsVC
//
//  Created by Kostya Bunsberry on 23.07.2021.
//

import UIKit

class EditorsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, InfoDelegate {
    
    var chosenEditors: [Editor] = [Editor(name: "Meduza", imageName: "meduza", info: "Новостной журнал, с основной целевой аудиторией из левых взглядов", editorId: 0, isAdded: true)]
    var availableEditors: [Editor] = [Editor(name: "DTF", imageName: "dtf", info: "", editorId: 1, isAdded: false),
                                      Editor(name: "TJournal", imageName: "tj", info: "", editorId: 2, isAdded: false)]
    
    var chosenEditor = Editor(name: "", imageName: "", info: "", editorId: 0, isAdded: true)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 {
            return .delete
        } else {
            return .insert
        }
    }
    
    // when insert or delete is tapped
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // TODO: move to another array and row
        if editingStyle == .insert {
            chosenEditors.append(availableEditors[indexPath.row])
            availableEditors.remove(at: indexPath.row)
            tableView.moveRow(at: indexPath, to: IndexPath(row: tableView.numberOfRows(inSection: 0), section: 0))
        } else {
            //TODO: while sorted by id
            availableEditors.append(chosenEditors[indexPath.row])
            chosenEditors.remove(at: indexPath.row)
            tableView.moveRow(at: indexPath, to: IndexPath(row: tableView.numberOfRows(inSection: 1), section: 1))
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == 0 {
            let element = chosenEditors.remove(at: sourceIndexPath.row)
            chosenEditors.insert(element, at: destinationIndexPath.row)
        } else {
            let element = availableEditors.remove(at: sourceIndexPath.row)
            availableEditors.insert(element, at: destinationIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
            }
            return IndexPath(row: row, section: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
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
