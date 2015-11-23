//
//  EditTaskViewController.swift
//  Day Planner
//
//  Created by Chuck Harpke on 11/21/15.
//  Copyright © 2015 Chuck Harpke. All rights reserved.
//

import UIKit
import CoreData

class EditTaskViewController: UIViewController, UITextFieldDelegate {
    
    var newTask: Bool = true
    var taskItem: AnyObject? = nil
    
    var appDel: AppDelegate = AppDelegate()
    var context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
    
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var taskStatusLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appDel.managedObjectContext
        
        taskTextField.delegate = self
        
        if newTask == true {
            saveButton.setTitle("Save", forState: UIControlState.Normal)
        }else{
            saveButton.setTitle("Update", forState: UIControlState.Normal)
        }
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func statusSwitchChanged(sender: UISwitch) {
        
        if sender.on {
            taskStatusLabel.text = "Complete"
        }else{
            taskStatusLabel.text = "Open"
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let task: AnyObject = self.taskItem {
            
            
            taskTextField.text = task.valueForKey("taskDescription")!.description
            
            let dateString = task.valueForKey("taskDate")!.description
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy"
            var date = formatter.dateFromString(dateString)
            date = date?.dateByAddingTimeInterval(18000)
            
            datePicker.setDate(date!, animated: true)
            
            if task.valueForKey("taskStatus")!.description == "Complete" {
                statusSwitch.on = true
                taskStatusLabel.text = "Complete"
            }else {
                statusSwitch.on = false
                taskStatusLabel.text = "Open"
            }
            
            
            
        }
        
        
        
    }
    
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        if taskTextField.text == "" {
            
            let alertController = UIAlertController(title: "Error", message: "You must provide a task to save/edit", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            
            if saveButton.titleLabel?.text == "Save" {
                
                let date = datePicker.date
                let formatter = NSDateFormatter()
                formatter.dateFormat = "dd-MMM-yyyy"
                
                let newTask = NSEntityDescription.insertNewObjectForEntityForName("Tasks", inManagedObjectContext: context) as NSManagedObject
                
                newTask.setValue(taskTextField.text, forKey: "taskDescription")
                newTask.setValue(formatter.stringFromDate(date), forKey: "taskDate")
                newTask.setValue(taskStatusLabel.text, forKey: "taskStatus")
                newTask.setValue(date, forKey: "taskDateStamp")
                
                do {
                    
                    try context.save()
                    
                    self.view.endEditing(true)
                    
                    let alertController = UIAlertController(title: "Success", message: "Record Saved Successfully", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    
                    
                } catch _ {
                    
                    let alertController = UIAlertController(title: "Error", message: "Error in Saving the Record", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
                
                
            } else {
                
                if let task: AnyObject = self.taskItem {
                    
                    let date = datePicker.date
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "dd-MMM-yyyy"
                    
                    task.setValue(taskTextField.text, forKey: "taskDescription")
                    task.setValue(taskStatusLabel.text, forKey: "taskStatus")
                    
                    task.setValue(formatter.stringFromDate(date), forKey: "taskDate")
                    task.setValue(date, forKey: "taskDateStamp")
                    
                    do {
                        try context.save()
                        
                        self.view.endEditing(true)
                        
                        let alertController = UIAlertController(title: "Success", message: "Record Updated Successfully", preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                        
                        
                    } catch _ {
                        
                        let alertController = UIAlertController(title: "Error", message: "Error in updating the record", preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                    }
                    
                }
                
                
            }
            
        }
        
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
