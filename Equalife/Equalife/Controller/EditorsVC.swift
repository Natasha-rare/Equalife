//
//  EditorsVC.swift
//  EditorsVC
//
//  Created by Kostya Bunsberry on 23.07.2021.
//

import UIKit
import RealmSwift

class EditorsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, InfoDelegate {
    
    var chosenEditors: [Editor] = []
    var availableEditors: [Editor] = []
    
    var chosenEditor = Editor()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarItem!
    
    var delegate: EditorChange?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let realmEditors = realm.objects(RealmEditor.self)
        for editor in realmEditors {
            if editor.isAdded {
                chosenEditors.append(Editor(name: editor.name, imageName: editor.imageName, info: editor.info, editorId: editor.editorId, isAdded: editor.isAdded))
            } else {
                availableEditors.append(Editor(name: editor.name, imageName: editor.imageName, info: editor.info, editorId: editor.editorId, isAdded: editor.isAdded))
            }
        }
        
        chosenEditors.sort { $0.sortId > $1.sortId }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            delegate?.editorsChanged()
        }
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
            chosenEditors[chosenEditors.count - 1].isAdded = true
            chosenEditors[chosenEditors.count - 1].sortId = chosenEditors.count
            availableEditors.remove(at: indexPath.row)
            tableView.moveRow(at: indexPath, to: IndexPath(row: tableView.numberOfRows(inSection: 0), section: 0))
            
            let realmEditors = realm.objects(RealmEditor.self)
            for editor in realmEditors {
                if editor.editorId == chosenEditors[chosenEditors.count - 1].editorId {
                    try! realm.write {
                        editor.isAdded = true
                        editor.sortId = chosenEditors[chosenEditors.count - 1].sortId
                    }
                }
            }
        } else {
            //TODO: while sorted by id
            availableEditors.insert(chosenEditors[indexPath.row], at: 0)
            availableEditors[0].isAdded = false
            chosenEditors.remove(at: indexPath.row)
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 1))
            
            let realmEditors = realm.objects(RealmEditor.self)
            for editor in realmEditors {
                if editor.editorId == availableEditors[0].editorId {
                    try! realm.write {
                        editor.isAdded = false
                        editor.sortId = chosenEditors[0].sortId
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == 0 {
            let element = chosenEditors.remove(at: sourceIndexPath.row)
            chosenEditors.insert(element, at: destinationIndexPath.row)
            // TODO: realm reordering
//            let realmEditors = realm.objects(RealmEditor.self)
//
//            for (index, editor) in chosenEditors.enumerated() {
//                chosenEditors[index].sortId = index + 1
//
//                for realmEditor in realmEditors {
//                    if editor.editorId == realmEditor.editorId {
//                        try! realm.write {
//                            print("X! index of \(realmEditor.name) changed to \(index)")
//                            realmEditor.sortId = index + 1
//                        }
//                    }
//                }
//            }
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
    
    func infoChanged(editor: Editor) {
        // reload arrays
        var found = false
        
        for (index, ae) in availableEditors.enumerated() {
            if ae.editorId == editor.editorId {
                chosenEditors.append(availableEditors[index])
                chosenEditors[chosenEditors.count - 1].isAdded = true
                availableEditors.remove(at: index)
                tableView.moveRow(at: IndexPath(row: index, section: 1), to: IndexPath(row: tableView.numberOfRows(inSection: 0), section: 0))
                found = true
            }
        }
        
        if !found {
            for (index, ce) in chosenEditors.enumerated() {
                if ce.editorId == editor.editorId {
                    //TODO: while sorted by id
                    availableEditors.append(chosenEditors[index])
                    availableEditors[availableEditors.count - 1].isAdded = false
                    chosenEditors.remove(at: index)
                    tableView.moveRow(at: IndexPath(row: index, section: 0), to: IndexPath(row: tableView.numberOfRows(inSection: 1), section: 1))
                }
            }
        }
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
