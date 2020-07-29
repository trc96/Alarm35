//
//  AlarmListTableViewController.swift
//  AlarmiOS35
//
//  Created by Todd Crandall on 7/27/20.
//  Copyright © 2020 Todd Crandall. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        AlarmController.sharedInstance.loadFromPersistentStore()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AlarmController.sharedInstance.alarms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath)
            as? AlarmTableViewCell else { return UITableViewCell() }
        
        let mockAlarm = AlarmController.sharedInstance.alarms[indexPath.row]
//        cell.textLabel?.text = alarm.nameLabel
        
        cell.delegate = self
        cell.alarm = mockAlarm

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let alarmToDelete = AlarmController.sharedInstance.alarms[indexPath.row]
            AlarmController.sharedInstance.remove(alarm: alarmToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateAlarm" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? AlarmDetailTableViewController else { return }
            let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
            destinationVC.receivedAlarm = alarm
        }
    }
}

extension AlarmListTableViewController: AlarmCellDelegate {
    func alarmSwitchTapped(for cell: AlarmTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        AlarmController.sharedInstance.toggleIsOn(for: alarm)
    }
}
