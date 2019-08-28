//
//  NotesTableViewController.swift
//  Yandex49
//
//  Created by Victor Doshchenko on 20/07/2019.
//  Copyright © 2019 Victor Doshchenko. All rights reserved.
//

import UIKit

protocol testDelegateProtocol {
    func updateUI()
}

class NotesTableViewController: UITableViewController, testDelegateProtocol {
    let notebook = FileNotebook()
    let backendQueue = OperationQueue()
    let dbQueue = OperationQueue()
    let commonQueue = OperationQueue()

    func updateUI() {
        print("Update UI ! ", Date())
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //Операция загрузки списка заметок LoadNotesOperation, вызывается при отображении списка заметок
        let loadNotesOperation = LoadNotesOperation(
            notebook: notebook,
            backendQueue: backendQueue,
            dbQueue: dbQueue
        )
        let adapterOp = BlockOperation(block: {
            self.updateUI()
        })
        
        adapterOp.addDependency(loadNotesOperation)
        commonQueue.addOperation(loadNotesOperation)
        OperationQueue.main.addOperation(adapterOp)
    }

    @IBAction func editTable(_ sender: UIBarButtonItem) {
        tableView.isEditing = !tableView.isEditing
    }
    @IBAction func addNote(_ sender: UIBarButtonItem) {
        print("Add Note!")
        notebook.notes.append(Note(title: "Новая заметка", content: "Текст",  importance: .normal))
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        let note = notebook.notes[notebook.notes.count - 1]
        let noteDetails = NoteDetails(notebook: notebook, note: note)
        noteDetails.delegate = self
        navigationController?.pushViewController(noteDetails, animated: true)
    }
}

extension NotesTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebook.notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let note = notebook.notes[indexPath.row]

        let myTitleString = NSMutableAttributedString(string: "█ " + note.title, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 25)])
        myTitleString.addAttribute(NSAttributedString.Key.foregroundColor, value: note.color, range: NSRange(location:0,length:1))
        cell.textLabel?.attributedText = myTitleString
        
        let myContentString = NSMutableAttributedString(string: note.content, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 22)])
        myContentString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray , range: NSRange(location:0,length: note.content.count))

        cell.detailTextLabel?.attributedText = myContentString
        cell.detailTextLabel?.numberOfLines = 5
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notebook.notes[indexPath.row]
        let noteDetails = NoteDetails(notebook: notebook, note: note)
        noteDetails.delegate = self
        navigationController?.pushViewController(noteDetails, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            let note = notebook.notes[indexPath.row]

            //Операция удаления заметки RemoveNoteOperation, вызывается из UI по событию удаления заметки
            let removeNoteOperation = RemoveNoteOperation(
                note: note,
                notebook: notebook,
                backendQueue: backendQueue,
                dbQueue: dbQueue
            )

            let adapterOp = BlockOperation {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            adapterOp.addDependency(removeNoteOperation)
            commonQueue.addOperation(removeNoteOperation)
            OperationQueue.main.addOperation(adapterOp)

        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 }
