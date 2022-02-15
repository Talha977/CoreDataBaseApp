//
//  MainViewController.swift
//  BaseAppStoryboard
//
//  Created by Mnet on 15/02/2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    // MARK: - IBOUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBACTIONS
    
    @IBAction func actionSave(_ sender: Any) {
        self.showAlertForSavePerson()
    }
    
    // MARK: - VARIABLES
    var people = [NSManagedObject]()
    
    // MARK: - LIFE CYCLE
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getDataForPersonEntity()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    func getDataForPersonEntity() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            people = try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError{
            print("Error is found to be\(error)")
        }
    }
    
    func savePersonEntity(name:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKey: "name")
        do {
            try managedContext.save()
            people.append(person)
        }
        
        catch let error as NSError {
            print("Could not find error because :\(error)")
        }
        
        
    }
    
    func showAlertForSavePerson() {
        let alert = UIAlertController(title: "Save Person", message: "Please enter name for saving peron.", preferredStyle: .alert)
        alert.addTextField()
        let saveAction = UIAlertAction(title: "Save", style: .default) { alertAct in
            guard let textfield = alert.textFields?.first,let name = textfield.text else{
                return
            }
            print("Person to be saved is \(name)")
            self.savePersonEntity(name: name)
            self.tableView.reloadData()
            
        }
        
        alert.addAction(saveAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}


// MARK: - TABLE VIEW DELEGATE HANDLERS

extension MainViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = person.value(forKey: "name") as? String
        return cell
    }
    
    
    
    
}

