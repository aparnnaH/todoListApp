//
//  TaskCell.swift
//  TodoList
//
//  Created by Aparnna Hariharan on 2019-12-29.
//  Copyright © 2019 Aparnna Hariharan. All rights reserved.
//

import UIKit

protocol ChangeButton {
    func changeButton(checked: Bool, index: Int)
}

class TaskCell: UITableViewCell {

    @IBAction func checkBoxAction(_ sender: Any) {
        if tasks![indexP!].checked {
            delegate?.changeButton(checked: false, index: indexP!) //unchecking the button
        } else {
            delegate?.changeButton(checked: true, index: indexP!) 
        }
    }
    
    @IBOutlet weak var checkBox: UIButton!
    
    @IBOutlet weak var taskNameLabel: UILabel!
    
    var delegate: ChangeButton?
    var indexP: Int?
    var tasks: [Task]?
    
    
}
