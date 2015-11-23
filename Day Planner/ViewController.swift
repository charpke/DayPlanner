//
//  ViewController.swift
//  Day Planner
//
//  Created by Chuck Harpke on 11/15/15.
//  Copyright © 2015 Chuck Harpke. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var todaysPercentageLabel: UILabel!
    @IBOutlet weak var totalPercentageLabel: UILabel!
    
    var appDel: AppDelegate = AppDelegate()
    var context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appDel.managedObjectContext
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let today = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        
        let request = NSFetchRequest(entityName: "Tasks")
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        
        var results: [AnyObject]?
        
        do {
            results = try context.executeFetchRequest(request)
        }catch _ {
            let alertController = UIAlertController(title: "Error", message: "Error Fetching Data", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        let total = results?.count
        
        request.predicate = NSPredicate(format: "taskStatus = %@", "Complete")
        do {
            results = try context.executeFetchRequest(request)
        }catch _ {
            let alertController = UIAlertController(title: "Error", message: "Error Fetching Data", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        let totalComplete = results?.count
        
        request.predicate = NSPredicate(format: "taskDate = %@", "\(formatter.stringFromDate(today))")
        do {
            results = try context.executeFetchRequest(request)
        }catch _ {
            let alertController = UIAlertController(title: "Error", message: "Error Fetching Data", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        let todaysTotal = results?.count
        
        
        request.predicate = NSPredicate(format: "taskStatus = %@ && taskDate = %@", "Complete", "\(formatter.stringFromDate(today))")
        do {
            results = try context.executeFetchRequest(request)
        }catch _ {
            let alertController = UIAlertController(title: "Error", message: "Error Fetching Data", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        let todaysComplete = results?.count
        
        let todaysPercentage = todaysTotal! > 0 ? Int(Float(todaysComplete!) / Float(todaysTotal!) * 100) : 0
        
        let totalPercentage = total! > 0 ? Int(Float(totalComplete!) / Float(total!) * 100) : 0
        
        todaysPercentageLabel.text = "\(todaysPercentage)%"
        totalPercentageLabel.text = "\(totalPercentage)%"
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

