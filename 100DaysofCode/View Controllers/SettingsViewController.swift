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
    var alarms = ["1"]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
return alarms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = alarmTableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath)
        cell.textLabel?.text = "-----"

        return cell
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    var userDefaults =
    UserDefaults.standard

    @IBAction func deleteUsername(_ sender: Any) {
        userDefaults.removeObject(forKey: "username")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
