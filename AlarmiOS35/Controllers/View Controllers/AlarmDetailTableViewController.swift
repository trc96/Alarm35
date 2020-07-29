//
//  AlarmDetailTableViewController.swift
//  AlarmiOS35
//
//  Created by Todd Crandall on 7/27/20.
//  Copyright © 2020 Todd Crandall. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var alarmNameTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var enableButtonTapped: UIButton!
    
    //MARK: - Properties
    var receivedAlarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            self.updateView()
        }
    }
    
    var alarmIsOn: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEnableButton()
    }
    
    func updateView() {
        guard let receivedAlarm = receivedAlarm else { return }
        datePicker.date = receivedAlarm.timeLabel
        alarmNameTextField.text = receivedAlarm.nameLabel
        alarmIsOn = receivedAlarm.alarmSwitch
        setUpEnableButton()
    }
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let nameLabel = alarmNameTextField.text else { return }
        if let alarm = receivedAlarm {
            AlarmController.sharedInstance.update(alarm: alarm, timeLabel: datePicker.date, nameLabel: nameLabel, alarmSwitch: alarmIsOn)
        } else {
            AlarmController.sharedInstance.create(alarmWithTimeLabel: datePicker.date, alarmWithNameLabel: nameLabel, alarmWithAlarmSwitch: alarmIsOn)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func alarmDatePicker(_ sender: Any) {
        guard let nameLabel = alarmNameTextField.text else { return }
        if let alarm = receivedAlarm {
            AlarmController.sharedInstance.update(alarm: alarm, timeLabel: datePicker.date, nameLabel: nameLabel, alarmSwitch: alarmIsOn)
        }
    }
    
    func setUpEnableButton() {
        switch alarmIsOn {
        case true:
            enableButtonTapped.setTitle("Enabled", for: .normal)
        case false:
            enableButtonTapped.setTitle("Disabled", for: .normal)
        }
    }
    
    @IBAction func enableButtonTapped(_ sender: Any) {
        if let alarm = receivedAlarm {
            AlarmController.sharedInstance.toggleIsOn(for: alarm)
            alarmIsOn = alarm.alarmSwitch
        } else {
            alarmIsOn.toggle()
        }
        setUpEnableButton()
    }
}
