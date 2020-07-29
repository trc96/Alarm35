//
//  AlarmTableViewCell.swift
//  AlarmiOS35
//
//  Created by Todd Crandall on 7/27/20.
//  Copyright © 2020 Todd Crandall. All rights reserved.
//

import UIKit

protocol AlarmCellDelegate: class {
    func alarmSwitchTapped(for cell: AlarmTableViewCell)
}//End of Protocol

class AlarmTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var timeLabelView: UILabel!
    @IBOutlet weak var nameLabelView: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    //MARK: - Properties
    weak var delegate: AlarmCellDelegate?
    
    var alarm: Alarm? {
        didSet{
            updateViews()
        }
    }
    
    //MARK: - Actions
    @IBAction func alarmSwitchTapped(_ sender: Any) {
        delegate?.alarmSwitchTapped(for: self)
        AlarmController.sharedInstance.saveToPersistentStore()
    }
    
    //MARK: - Class Methods
    func updateViews() {
        guard let alarm = alarm else { return }
        timeLabelView.text = alarm.fireTimeAsString
        nameLabelView.text = alarm.nameLabel
        alarmSwitch.isOn = alarm.alarmSwitch
    }
}
