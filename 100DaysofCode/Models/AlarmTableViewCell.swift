//
//  AlarmTableViewCell.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/25/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {
    //MARK: - Outlets and Properties
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!

    weak var delegate: AlarmTableViewCellDelegate?

    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    //MARK: - Actions
    @IBAction func switchValueChanged(_ sender: Any) {
      
        delegate?.switchCellSwitchValueChanged(cell:self )
    }

    func updateViews() {
        guard let alarm = alarm else { return }
        timeLabel.text = alarm.fireDateAsString

        alarmSwitch.isOn = alarm.enabled

    }
}
protocol AlarmTableViewCellDelegate: class {

    func switchCellSwitchValueChanged(cell: AlarmTableViewCell)
}



