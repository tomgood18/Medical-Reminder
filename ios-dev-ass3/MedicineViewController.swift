//
//  MedicineViewController.swift
//  ios-dev-ass3
//
//  Created by Thomas Good on 9/6/20.
//  Copyright © 2020 Thomas Good. All rights reserved.
//

import UIKit

class MedicineViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var dosageTimeLabel: UILabel!
    
    @IBOutlet weak var dosageSlider: UISlider!
    @IBOutlet weak var dosageTimeSlider: UISlider!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var foodState: Bool = true
    
    @IBOutlet weak var foodSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
      
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func PresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.stringArray(forKey: key) != nil
        
    }
    
    
    
    
    @IBAction func dosageSlider(_ sender: Any) {
        dosageLabel.text = String(Int(dosageSlider.value))
    }
    
    @IBAction func dosageTimeSlider(_ sender: Any) {
        dosageTimeLabel.text = String(Int(dosageTimeSlider.value))
    }
    
    
    
    @IBAction func foodSwitchButton(_ sender: UISwitch) {
        if (foodSwitch.isOn) {
            foodState = true
        } else {
            foodState = false
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        print("Medication saved to table")
        let medication = nameTextField.text
        let targetDate = datePicker.date
        let dosage = dosageLabel.text
        let dosageTime = dosageTimeLabel.text
        let foodBool : String
        let notificationTime = DateFormatter().string(from: datePicker.date)
        
        if (foodSwitch.isOn){
            foodBool = "true"
        }
        else {
            foodBool = "false"
        }

        var medicationList = [medication]
        var dosageList = [dosage]
        var dosageTimeList = [dosageTime]
        var foodBoolList = [foodBool]
        var timeList = [notificationTime]
        
        if PresentInUserDefaults(key: "medication") {
            let tempMedicationNames = UserDefaults.standard.stringArray(forKey: "medication")
            for n in tempMedicationNames! {
                medicationList.append(n)
            }
            
        }
        else {
            medicationList.append(medication)
        }
        if PresentInUserDefaults(key: "dosage") {
            let tempDosage = UserDefaults.standard.stringArray(forKey: "dosage")
            
            for n in tempDosage! {
                dosageList.append(n)
            }
        }
        else {
            dosageList.append(dosage)
        }
        
        if PresentInUserDefaults(key: "interval") {
            let tempInterval = UserDefaults.standard.stringArray(forKey: "interval")
            for n in tempInterval! {
                dosageTimeList.append(n)
            }
        }
        else {
            dosageTimeList.append(dosageTime)
        }
        if PresentInUserDefaults(key: "food") {
           let tempBool = UserDefaults.standard.stringArray(forKey: "food")
           for n in tempBool! {
               foodBoolList.append(n)
           }
        }
        else {
            foodBoolList.append(foodBool)
        }
        if PresentInUserDefaults(key: "time") {
           let tempTime = UserDefaults.standard.stringArray(forKey: "time")
           for n in tempTime! {
               timeList.append(n)
           }
        }
        else {
            timeList.append(notificationTime)
        }
        
        
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(medicationList, forKey: "medication")
        userDefaults.set(dosageList, forKey: "dosage")
        userDefaults.set(dosageTimeList, forKey: "interval")
        userDefaults.set(foodBoolList, forKey: "food")
        userDefaults.set(timeList, forKey: "time")
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                self.createNotification(name: medication!, time: targetDate)
                if (Int(self.dosageSlider.value) > 1){
                    var tempDate = targetDate
                    for _ in 2...Int(self.dosageSlider.value) {
                        tempDate = tempDate.addingTimeInterval(TimeInterval(Int(self.dosageTimeSlider.value) * 60 * 60))
                        // - vvv Creates interval notifications - TO-DO vvv
                        //self.createNotification(name: medication!, time: tempDate)
                    }
                }
            }
            else if error != nil{
                print("error occured")
            }
        })
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    func textFieldShouldReturn(_ nameTextField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    func createNotification(name: String, time: Date){
        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.sound = .default
        if (foodState == true){
            content.body = ("It's time to take " + name + " with food")
        } else if (foodState == false){
            content.body = ("It's time to take " + name)
        }
        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        var dateComponents = DateComponents()
        dateComponents.hour = components.hour
        dateComponents.minute = components.minute
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let notificationRequest = UNNotificationRequest(identifier: name, content: content, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error
            {
                let errorString = String(format: NSLocalizedString("Unable to Add Notification Request %@, %@", comment: ""), error as CVarArg, error.localizedDescription)
                print(errorString)
            }
        }
        
            
            
    }

    
    
}







/*
 
 Step 1: User
 
 lets create a notification using medicine information
 
 */
