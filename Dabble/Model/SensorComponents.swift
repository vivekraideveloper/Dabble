//
//  SensorComponents.swift
//  Dabbleabble
//
//  Created by Vivek Rai on 08/06/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import Foundation

struct SensorComponents {
    
    private(set) public var sensorName: String
    private(set) public var firstLabel: String
    private(set) public var secondLabel: String
    private(set) public var thirdLabel: String
    private(set) public var firstUnit: String
    private(set) public var secondUnit: String
    private(set) public var thirdUnit: String
    private(set) public var sensorImage: String
    
    init(sensorName: String, firstLabel: String, secondLabel: String, thirdLabel: String, firstUnit: String, secondUnit: String, thirdUnit: String, sensorImage: String) {
        self.sensorName = sensorName
        self.firstLabel = firstLabel
        self.secondLabel = secondLabel
        self.thirdLabel = thirdLabel
        self.firstUnit = firstUnit
        self.secondUnit = secondUnit
        self.thirdUnit = thirdUnit
        self.sensorImage = sensorImage
    }
    
    
}

