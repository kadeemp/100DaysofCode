//
//  SettingsViewController.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/21/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var alarmTableView: UITableView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var signOutButton: UIButton!

    @IBOutlet var addAlarmButton: UIButton!

    var userDefaults =
        UserDefaults.standard


    // @IBOutlet var addAlarmButton: UIButton!
    var alarms = AlarmController.shared.allAlarms

    override func viewDidLoad() {
        super.viewDidLoad()
        signOutButton.layer.cornerRadius = signOutButton.frame.width/6
        addAlarmButton.layer.cornerRadius = addAlarmButton.frame.width/6
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: NSNotification.updateAlarmTable, object: nil)
        if let username = UserDefaults.standard.string(forKey: "username") {
            usernameLabel.text = username
        }
    }
    func roundViews() {
        alarmTableView.layer.cornerRadius = alarmTableView.frame.width / 4
        signOutButton.layer.cornerRadius = signOutButton.frame.width / 4
    }
    @objc func reloadTable() {

        alarms = AlarmController.shared.allAlarms
        alarmTableView.reloadData()
    }
    // MARK: - IB Actions

    @IBAction func deleteUsername(_ sender: Any) {

    }

    @IBAction func addAlarmPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addAlarmVC = storyboard.instantiateViewController(withIdentifier: "addAlarm")
        self.navigationController?.pushViewController(addAlarmVC, animated: true)
    }

    @IBAction func signOutBtnPressed(_ sender: UIButton) {

        let alertController = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            self.userDefaults.removeObject(forKey: "username")
            //TODO:- Add nav to loging
        }
        let noAction = UIAlertAction(title: "No", style: .cancel)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
    //MARK:- TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.shared.allAlarms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alarm = AlarmController.shared.allAlarms[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell") as! AlarmTableViewCell

        //append switch button

        if alarm.enabled {
            cell.backgroundColor = UIColor.white

            cell.timeLabel?.alpha = 1.0
            // sw.setOn(true, animated: false)
        } else {
            cell.backgroundColor = UIColor.groupTableViewBackground
            cell.timeLabel?.alpha = 0.5
        }
        cell.alarm = alarm
        cell.tag = indexPath.row

        cell.delegate = self

        //delete empty seperator line
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let alarmBeingDeleted = AlarmController.shared.allAlarms[indexPath.row]
            AlarmController.shared.deleteAlarm(alarmBeingDeleted: alarmBeingDeleted)

            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
extension SettingsViewController: AlarmTableViewCellDelegate {
    func switchCellSwitchValueChanged(cell: AlarmTableViewCell) {

        guard let alarm = cell.alarm else { return }
        let index = cell.tag
        AlarmController.shared.toggleEnabledByIndex(index: index)
        cell.updateViews()


    }

}

