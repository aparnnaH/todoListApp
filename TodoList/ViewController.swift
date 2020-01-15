//
//  ViewController.swift
//  TodoList
//
//  Created by Aparnna Hariharan on 2019-12-29.
//  Copyright © 2019 Aparnna Hariharan. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftUI

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ChangeButton {

    var tasks: [Task] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addButton(_ sender: Any) {
        if taskNameOutlet.text != "" {
            addTask(name: taskNameOutlet.text!)
            taskNameOutlet.text = ""
        }
    }
    @IBOutlet weak var dataPicker: UIDatePicker!
    
    @IBOutlet weak var taskNameOutlet: UITextField!
    
    override func viewDidLoad() {
        //tasks.append(Task(name:"Test object"))
        super.viewDidLoad()
        self.taskNameOutlet.delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge] , completionHandler:{didAllow, error in })
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell 
    
        cell.taskNameLabel.text = tasks[indexPath.row].name
  
        if tasks[indexPath.row].checked {
            cell.checkBox.setBackgroundImage(#imageLiteral(resourceName: "checkBoxFILLED"), for: UIControl.State.normal)
        } else {
            cell.checkBox.setBackgroundImage(#imageLiteral(resourceName: "checkBoxOUTLINE "), for: UIControl.State.normal)
        }
        cell.delegate = self
        cell.indexP = indexPath.row
        cell.tasks = tasks
        
        return cell
    }
    
    func addTask(name:String){
        tasks.append(Task(name:name))
        tableView.reloadData()
        
        let content = UNMutableNotificationContent()
        content.title = "name"
        content.body = "Date:"
        content.badge = 1
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        var date = DateComponents()
        date.hour = 6
        date.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        let request = UNNotificationRequest(identifier: "taskReminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    func changeButton(checked: Bool, index: Int) {
        tasks[index].checked = checked
        tableView.reloadData()
    }
    
    //hide keyboard when user touches outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //hides keyboard when user hits the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


class Task {
    var name = ""
    var checked = false
    
    convenience init(name: String){
        self.init()
        self.name = name
    }
    
}

