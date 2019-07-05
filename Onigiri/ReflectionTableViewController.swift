//
//  ReflectionTableViewController.swift
//  Onigiri
//
//  Created by Vale-chan on 16.06.19.
//  Copyright © 2019 Vale-chan. All rights reserved.
//

import UIKit
import CoreData

class ReflectionTableViewController: UITableViewController {
    
    var reflections = [Reflection]()
    
    
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveReflections()
        
        // Styles
        self.tableView.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        retrieveReflections()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reflections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReflectionTableViewCell", for: indexPath) as! ReflectionTableViewCell
        
        let reflection: Reflection = reflections[indexPath.row]
        cell.configureCell(reflection: reflection)
        cell.backgroundColor = UIColor.clear
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "                    ") { (action, indexPath) in
            
            let reflection = self.reflections[indexPath.row]
            context.delete(reflection)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                self.reflections = try context.fetch(Reflection.fetchRequest())
            } catch {
                print("Failed to delete note.")
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
        
        delete.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        return [delete]
    }
    
    // MARK: NSCoding
    func retrieveReflections() {
        managedObjectContext?.perform {
            self.fetchReflectionsFromCoreData { (reflections) in
                if let reflections = reflections {
                    self.reflections = reflections
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func fetchReflectionsFromCoreData(completion: @escaping ([Reflection]?)->Void){
        managedObjectContext?.perform {
            var reflections = [Reflection]()
            let request: NSFetchRequest<Reflection> = Reflection.fetchRequest()
            
            do {
                reflections = try  self.managedObjectContext!.fetch(request)
                completion(reflections)
            } catch {
                print("Could not fetch reflections from CoreData:\(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowReflection" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let reflectionDetailsViewController = segue.destination as! ReflectionDetailViewController
                let selectedReflection: Reflection = reflections[indexPath.row]
                
                reflectionDetailsViewController.indexPath = indexPath.row
                reflectionDetailsViewController.isExsisting = false
                reflectionDetailsViewController.reflection = selectedReflection
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .full
                dateFormatter.locale = Locale(identifier: "de_DE")
                reflectionDetailsViewController.navigationItem.title = "Meine Reflexion"
            }
        }
        
        else if segue.identifier == "AddReflection" {
            print("User added a new reflection.")
        }
    }

    
}
