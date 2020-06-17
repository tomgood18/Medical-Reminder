//
//  ViewController.swift
//  ios-dev-ass3
//
//  Created by Thomas Good on 9/6/20.
//  Copyright © 2020 Thomas Good. All rights reserved.
//

import UIKit
import UserNotifications
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var table: UITableView!
    var medicineList: [String] = []
    var dosageList: [String] = []
    var timeList: [String] = []
    var boolList: [String] = []
    var notificationTimeList: [String] = []
    let userDefaults = UserDefaults.standard
    var deleteBool : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        checkBool()
        loadLists()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        checkBool()
        loadLists()
    }
    
    func checkBool(){
        
        if (deleteBool == true){
            print("True")
        }
        else {
            print("False")
        }
    }
    
    
    
    func loadLists() {
        
        
        if PresentInUserDefaults(key: "medication") {
            medicineList = userDefaults.stringArray(forKey: "medication")!
        }
        if PresentInUserDefaults(key: "dosage") {
            dosageList = userDefaults.stringArray(forKey: "dosage")!
        }
        if PresentInUserDefaults(key: "interval"){
            timeList = userDefaults.stringArray(forKey: "interval")!
        }
        if PresentInUserDefaults(key: "food"){
            boolList = userDefaults.stringArray(forKey: "food")!
        }
        if PresentInUserDefaults(key: "time"){
            notificationTimeList = userDefaults.stringArray(forKey: "time")!
        }
        self.table.reloadData()
    }
    
    
    
    func PresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.stringArray(forKey: key) != nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(medicineList.count)
        return medicineList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let medicationCell = self.table.dequeueReusableCell(withIdentifier: "cell")! as! cell
        medicationCell.nameLabel.text = self.medicineList[indexPath.row]
        medicationCell.dosageLabel.text = (self.dosageList[indexPath.row] + " time/s a day")
        medicationCell.dosageTime.text = (self.timeList[indexPath.row] + " hour interval/s")
        medicationCell.foodSwitchLabel.text = ("With food?: " + self.boolList[indexPath.row])
        medicationCell.notificationTime.text = self.notificationTimeList[indexPath.row]
        return medicationCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        print("Deleted")
        let medicine = medicineList[indexPath.row]
        medicineList.remove(at: indexPath.row)
        self.table.deleteRows(at: [indexPath], with: .automatic)
        self.table.reloadData()
        userDefaults.set(medicineList, forKey: "medication")
        userDefaults.synchronize()
        deleteNotifications(identifier: medicine)
      }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editViewController = segue.destination as? EditViewController {
            if let indexPath = table.indexPathForSelectedRow {
                let medicine = medicineList[indexPath.row]
                let dosage = dosageList[indexPath.row]
                let dosageTime = timeList[indexPath.row]
                let foodBool = boolList[indexPath.row]
                let time = notificationTimeList[indexPath.row]
                editViewController.name = medicine
                editViewController.dosageAmount = Int(dosage)
                editViewController.dosageTime = Int(dosageTime)
                editViewController.food = foodBool
                editViewController.time = DateFormatter().date(from: time)
                editViewController.index = indexPath.row
                
            }
        }
    }
        
//this function is used for deleting all notifications
    func deleteNotifications(identifier: String){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}



//need to connect a notification to a medicine
//for each medication there is a notification (maybe userdefaults?)
//need to display medicine information in notification

//what I have done so far, created button that deletes all notifications
//created a date formatter
//



/*
 
 extension Date {
     func adding(days: Int) -> Date? {
         var dateComponents = DateComponents()
         dateComponents.day = days

         return NSCalendar.current.date(byAdding: dateComponents, to: self)
     }
 }
 Then you could just create new notifications for dates specified, in this example 2, 4, 6 days from now

 let date = Date()
 for i in [2, 4, 6] {
     if let date = date.adding(days: i) {
         scheduleNotification(withDate: date)
     }
 }

 func scheduleNotification(withDate date: Date) {
     let notificationContent = UNMutableNotificationContent()
     notificationContent.title = "Title"
     notificationContent.subtitle = "Subtitle"
     notificationContent.body = "Body"

     let identifier = "Make up identifiers here"
     let dateComponents = Calendar.autoupdatingCurrent.dateComponents([.day, .month, .year, .hour, .minute, .second], from: date)

     let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

     let notificationReques = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)

     UNUserNotificationCenter.current().add(notificationReques) { error in
         if let e = error {
             print("Error \(e.localizedDescription)")
         }
     }
 }
 */
