//
//  PhoneSensorCell.swift
//  Dabbleabble
//
//  Created by Vivek Rai on 08/06/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import UIKit

class PhoneSensorCell: UITableViewCell {

    @IBOutlet weak var sensorNameLabel: UILabel!
    @IBOutlet weak var sensorToggle: UISwitch!
    @IBOutlet weak var sensorImage: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstValue: UITextField!
    @IBOutlet weak var firstUnit: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondValue: UITextField!
    @IBOutlet weak var secondUnit: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var thirdValue: UITextField!
    @IBOutlet weak var thirdUnit: UILabel!
    @IBOutlet weak var phoneSensorView: UIView!
    
    func updateViews(sensorComponents: SensorComponents) {
        sensorNameLabel.text = sensorComponents.sensorName
        firstLabel.text = sensorComponents.firstLabel
        secondLabel.text = sensorComponents.secondLabel
        thirdLabel.text = sensorComponents.thirdLabel
        firstUnit.text = sensorComponents.firstUnit
        secondUnit.text = sensorComponents.secondUnit
        thirdUnit.text = sensorComponents.thirdUnit
        sensorImage.image = UIImage(named: sensorComponents.sensorImage)
        phoneSensorView.layer.cornerRadius = 10
        phoneSensorView.layer.shadowColor = UIColor.gray.cgColor
        phoneSensorView.layer.shadowOpacity = 1
        phoneSensorView.backgroundColor = UIColor.white
        sensorNameLabel.layer.cornerRadius = 10
        
    }    
}
