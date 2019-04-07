//
//  NewAlarmViewController.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/25/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit

class NewAlarmViewController: UIViewController {

    @IBOutlet var datePicker: UIDatePicker!

    @IBOutlet var submitButton: UIButton!
    var alarmIsOn: Bool!

    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.layer.backgroundColor = UIColor.black.cgColor
        datePicker.tintColor = UIColor.white
        datePicker.setValue(UIColor.white, forKey: "textColor")
        // Do any additional setup after loading the view.
    }

    

    @IBAction func addAlarm(_ sender: UIButton) {

        let today = datePicker.date
        alarmIsOn = true
        if let alarm = alarm {

            AlarmController.shared.updateAlarm(alarm: alarm, fireDate: datePicker.date, name:"", enabled: alarmIsOn)
        } else {
        AlarmController.shared.addAlarm(fireDate: today, name:  "", enabled: alarmIsOn)

        }
                NotificationCenter.default.post(name: NSNotification.updateAlarmTable, object: self, userInfo: nil)
        self.navigationController?.popViewController(animated: true)
    }
    func updateViews() {
        guard let alarm = alarm else {return}
        datePicker.date = alarm.fireDate

    }


}
