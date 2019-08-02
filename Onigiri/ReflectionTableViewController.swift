//
//  ReflectionTableViewController.swift
//  Onigiri
//
//  Created by Vale-chan on 16.06.19.
//  Copyright © 2019 Vale-chan. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class ReflectionTableViewController: UITableViewController {

    var reflections = [Reflection]()


    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        //Notifications

        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()

        content.title = "Deine tägliche Reflexion"
        content.body = "Hast du dir heute schon Zeit für deine Unterrichtsreflexion genommen?"
        content.sound = UNNotificationSound.default
        content.threadIdentifier = "local-notifications"

        var date = DateComponents()
        date.hour = 17
        date.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "onigiri-notification", content: content, trigger: trigger)

        center.add(request) { (error) in
            if error != nil {
                print (error)
            }
        }

        //Reflections
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
        let delete = UITableViewRowAction(style: .default , title: "\u{267A}") { (action, indexPath) in

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
        
        delete.backgroundColor = UIColor(red: 1, green: 0.4627, blue: 0.5333, alpha: 1)

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
                reflections = reflections.reversed()
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
    
    //Export Data as CVS
    @IBAction func exportBarButtonTapped(_ sender: Any) {
        exportDatabase()
    }
    
    
    func exportDatabase() {
        let exportString = createExportString()
        saveAndExport(exportString: exportString)
    }
    
    func saveAndExport(exportString: String) {
        let exportFilePath = NSTemporaryDirectory() + "Teacher_Reflections.csv"
        let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
        FileManager.default.createFile(atPath: exportFilePath, contents: NSData() as Data, attributes: nil)
        //var fileHandleError: NSError? = nil
        var fileHandle: FileHandle? = nil
        do {
            fileHandle = try FileHandle(forWritingTo: exportFileURL as URL)
        } catch {
            print("Error with fileHandle")
        }
        
        if fileHandle != nil {
            fileHandle!.seekToEndOfFile()
            let csvData = exportString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            fileHandle!.write(csvData!)
            
            fileHandle!.closeFile()
            
            let firstActivityItem = NSURL(fileURLWithPath: exportFilePath)
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem], applicationActivities: nil)
            
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo
            ]
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func createExportString() -> String {
        var answer1: String?
        var answer2: String?
        var answer3: String?
        var answer4: String?
        var date: NSDate?
        
        var export: String = NSLocalizedString("answer1, answer2, answer3, answer4, date", comment: "<#String#>")
        for (index, itemList) in reflections.enumerated() {
            if index <= reflections.count - 1 {
                answer1 = itemList.value(forKey: "answer1") as! String?
                answer2 = itemList.value(forKey: "answer2") as! String?
                answer3 = itemList.value(forKey: "answer3") as! String?
                answer4 = itemList.value(forKey: "answer4") as! String?
                date = itemList.value(forKey: "date") as! NSDate?
                let answer1String = answer1
                let answer2String = answer2
                let answer3String = answer3
                let answer4String = answer4
                let dateString = date

                export += "\(answer1String!),\(answer2String!),\(answer3String!),\(answer4String!),\(dateString) \n"
            }
        }
        print("This is what the app will export: \(export)")
        return export
    }
    


}
