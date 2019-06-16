//
//  ReflectionDetailViewController.swift
//  Onigiri
//
//  Created by Vale-chan on 16.06.19.
//  Copyright © 2019 Vale-chan. All rights reserved.
//

import UIKit
import CoreData

class ReflectionDetailViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var part1View: UIView!
    @IBOutlet weak var part2View: UIView!
    @IBOutlet weak var part3View: UIView!
    @IBOutlet weak var part4View: UIView!
    
    @IBOutlet weak var question1Label: UILabel!
    @IBOutlet weak var question2Label: UILabel!
    @IBOutlet weak var question3Label: UILabel!
    @IBOutlet weak var question4Label: UILabel!
    
    @IBOutlet weak var answer1TextView: UITextView!
    @IBOutlet weak var answer2TextView: UITextView!
    @IBOutlet weak var answer3TextView: UITextView!
    @IBOutlet weak var answer4TextView: UITextView!
    
    let question1 = "erstens"
    let question2 = "zweitens"
    let question3 = "drittens"
    let question4 = "viertens"
    
    
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    var reflectionsFetchedResultsController: NSFetchedResultsController<Reflection>!
    var reflections = [Reflection]()
    var reflection: Reflection?
    var isExsisting = false
    var indexPath: Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set questions
        question1Label.text = question1
        question2Label.text = question2
        question3Label.text = question3
        question4Label.text = question4
        
        // Load data
        if let reflection = reflection {
            answer1TextView.text = reflection.answer1
            answer2TextView.text = reflection.answer2
            answer3TextView.text = reflection.answer3
            answer4TextView.text = reflection.answer4
        }
        
        if question1Label.text != "" {
            isExsisting = true
        }
        
        
        // Delegates
        answer1TextView.delegate = self
        
        
        // Styles
        part1View.layer.shadowColor =  UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).cgColor
        part1View.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        part1View.layer.shadowRadius = 1.5
        part1View.layer.shadowOpacity = 0.2
        part1View.layer.cornerRadius = 2
        
        part2View.layer.shadowColor =  UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).cgColor
        part2View.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        part2View.layer.shadowRadius = 1.5
        part2View.layer.shadowOpacity = 0.2
        part2View.layer.cornerRadius = 2
        
        part3View.layer.shadowColor =  UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).cgColor
        part3View.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        part3View.layer.shadowRadius = 1.5
        part3View.layer.shadowOpacity = 0.2
        part3View.layer.cornerRadius = 2
        
        part4View.layer.shadowColor =  UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).cgColor
        part4View.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        part4View.layer.shadowRadius = 1.5
        part4View.layer.shadowOpacity = 0.2
        part4View.layer.cornerRadius = 2
    }
    
    
    // Core data
    func saveToCoreData(completion: @escaping ()->Void){
        managedObjectContext!.perform {
            do {
                try self.managedObjectContext?.save()
                completion()
                print("Note saved to CoreData.")
                
            } catch let error {
                print("Could not save note to CoreData: \(error.localizedDescription)")
            }
        }
    }
    
    // Saving Data
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if answer1TextView.text == "" {
            let alertController = UIAlertController(title: "Fehlende Information", message: "Bitte beantworte die erste Reflektionsfrage. Die restlichen Reflektionsfragen müssen nicht ausgefüllt werden.", preferredStyle: UIAlertController.Style.alert)
            let OKAction = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil)
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            if (isExsisting == false) {
                let answer1 = answer1TextView.text
                let answer2 = answer2TextView.text
                let answer3 = answer3TextView.text
                let answer4 = answer4TextView.text
                
                if let moc = managedObjectContext {
                    let reflection = Reflection(context: moc)
                }
                
                reflection?.answer1 = answer1
                reflection?.answer2 = answer2
                reflection?.answer3 = answer3
                reflection?.answer4 = answer4
                
                saveToCoreData() {
                    
                    let isPresentingInAddFluidPatientMode = self.presentingViewController is UINavigationController
                        if isPresentingInAddFluidPatientMode {
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            self.navigationController!.popViewController(animated: true)
                        }
                    }
                } else if (isExsisting == true) {
                    let reflection = self.reflection
                    
                    let managedObject = reflection
                    managedObject!.setValue(answer1TextView.text, forKey: "answer1")
                    managedObject!.setValue(answer2TextView.text, forKey: "answer2")
                    managedObject!.setValue(answer3TextView.text, forKey: "answer3")
                    managedObject!.setValue(answer4TextView.text, forKey: "answer4")
                
                do {
                    try context.save()
                    let isPresentingInAddFluidPatientMode = self.presentingViewController is UINavigationController
                    if isPresentingInAddFluidPatientMode {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.navigationController!.popViewController(animated: true)
                    }
                } catch {
                    print("Failed to update existing note.")
                }
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddFluidPatientMode = presentingViewController is UINavigationController
        
        if isPresentingInAddFluidPatientMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }

    
    
    

/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
