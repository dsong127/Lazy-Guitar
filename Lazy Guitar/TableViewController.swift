//
//  TableViewController.swift
//  Lazy Guitar
//
//  Created by Daniel Song on 10/21/16.
//  Copyright © 2016 Daniel Song. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var moc:NSManagedObjectContext!
    var noteTitles = [Title]()
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loadData()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setEditing(false, animated: false)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteTitles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "TableCell")!

        tableCell.backgroundView = UIImageView(image: UIImage(named: "background"))
        tableCell.textLabel!.text = noteTitles[indexPath.row].titleName
        return tableCell
    }
    
    @IBAction func addButtonPressed(_ sender: AnyObject) {
        selectedIndex = noteTitles.count
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        let title = CoreDataHelper.insertManagedObject(entity: "Title", managedObjectContext: self.moc) as! Title
                                        
                                        let chord = CoreDataHelper.insertManagedObject(entity: "ChordView", managedObjectContext: self.moc) as! ChordView
                                        
                                        chord.chordName = [String]()
                                    
                                        title.titleName = textField?.text
                                        
                                        do{
                                            try self.moc.save()
                                        } catch let error as NSError {
                                            print("could not save \(error), \(error.userInfo)")

                                        }
                                        self.loadData()
                                        self.tableView.reloadData()

                                        self.performSegue(withIdentifier: "ShowEditorSegue", sender: nil)

        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default) { (action: UIAlertAction) -> Void in
        }
        
        
        alert.addTextField {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert,
                animated: true,
                completion: nil)
        
    }
       /*
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        print(noteTitles)
        guard !noteTitles.isEmpty else {
            print("Guard: Note Title Data is empty")
            return
        }
        
        if let isEditing = self.tableView?.isEditing {
            self.tableView?.setEditing(!isEditing, animated: true)
        }
    }
 */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.row
        
        performSegue(withIdentifier: "ShowEditorSegue", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let managedObject:NSManagedObject = noteTitles[indexPath.row]
        
        if editingStyle == .delete {
            self.moc.delete(managedObject)
            loadData()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.tableView.reloadData()

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let itemToMove = noteTitles[fromIndexPath.row]
        noteTitles.remove(at: fromIndexPath.row)
        noteTitles.insert(itemToMove, at: fromIndexPath.row)
        do {
            try self.moc.save()
        } catch let error as NSError {
            print("could not save \(error), \(error.userInfo)")
        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEditorSegue" {
            let chordsVC = segue.destination as! ChordsViewController
                    chordsVC.noteIndexPath = selectedIndex
                    chordsVC.headerTitle = noteTitles[selectedIndex].titleName!
                }
    }
    
    func loadData() {
        noteTitles = []
        noteTitles = CoreDataHelper.fetchEntities(entity: "Title", managedObjectContext: self.moc, predicate: nil) as! [Title]
        
        
    }
    
    func initUI() {
        isEditing = false
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView?.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background"))
        self.navigationController?.hidesBarsOnSwipe = false
    }
 

}
