//
//  EditViewController.swift
//  ios-dev-ass3
//
//  Created by Thomas Good on 9/6/20.
//  Copyright © 2020 Thomas Good. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    var name : String?
    var dosageAmount : Int?
    var dosageTime : Int?
    var food : String?
    var time : Date?
    var oldName : String?
    var foodState: Bool = true
    var deleteBool: Bool = false
    var index: Int?
    let userDefaults = UserDefaults()
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var dosageSlider: UISlider!
    
    @IBOutlet weak var hoursSlider: UISlider!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var foodSwitch: UISwitch!
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = name
        oldName = name
        dosageSlider.value = Float(dosageAmount!)
        hoursSlider.value = Float(dosageTime!)
        dosageLabel.text = String(Int(dosageSlider.value))
        hoursLabel.text = String(Int(hoursSlider.value))
        
        //timePicker.date = time!
        timePicker.setDate(time!, animated: false)
        if (food == "true"){
            foodSwitch.setOn(true, animated: false)
        }
        else {
            foodSwitch.setOn(false, animated: false)
        }
    }
    
    @IBAction func dosageChanged(_ sender: Any) {
        dosageLabel.text = String(Int(dosageSlider.value))
    }
    @IBAction func hoursChanged(_ sender: Any) {
        hoursLabel.text = String(Int(hoursSlider.value))
    }
    
    
    @IBAction func foodSwitcher(_ sender: Any) {
        if (foodSwitch.isOn) {
            foodState = true
        } else {
            foodState = false
        }
    }
    
    func PresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.stringArray(forKey: key) != nil
        
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        let medication = nameTextField.text
        let targetDate = timePicker.date
        let dosage = dosageLabel.text
        let dosageTime = hoursLabel.text
        let foodBool : String
        let notificationTime = DateFormatter().string(from: timePicker.date)
        
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
                self.editNotification(name: medication!, time: targetDate)
                if (Int(self.dosageSlider.value) > 1){
                    var tempDate = targetDate
                    for _ in 2...Int(self.dosageSlider.value) {
                        tempDate = tempDate.addingTimeInterval(TimeInterval(Int(self.dosageSlider.value) * 60 * 60))
                    }
                }
            }
            else if error != nil{
                print("error occured")
            }
        })
        deleteArrayValue()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func editNotification(name: String, time: Date){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [oldName!])
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
    
    func deleteArrayValue() {
        var medicineList = userDefaults.stringArray(forKey: "medication")!
        var dosageList = userDefaults.stringArray(forKey: "dosage")!
        var timeList = userDefaults.stringArray(forKey: "interval")!
        var boolList = userDefaults.stringArray(forKey: "food")!
        var notificationTimeList = userDefaults.stringArray(forKey: "time")!
        medicineList.remove(at: index! + 1)
        dosageList.remove(at: index! + 1)
        timeList.remove(at: index! + 1)
        boolList.remove(at: index! + 1)
        notificationTimeList.remove(at: index! + 1)
        userDefaults.set(medicineList, forKey: "medication")
        userDefaults.set(dosageList, forKey: "dosage")
        userDefaults.set(timeList, forKey: "interval")
        userDefaults.set(boolList, forKey: "food")
        userDefaults.set(notificationTimeList, forKey: "time")
        userDefaults.synchronize()
        
    }
    
    
}
